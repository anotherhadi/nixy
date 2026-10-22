# Sandboxing helper built on nixpak (declarative bubblewrap)
# Usage, from any flake-parts module:
#   (config.flake.lib.mkSandbox pkgs).wrap { package = pkgs.foo; config = { sloth, ... }: { ... }; }
# Returns the package with its main binary replaced by the sandboxed wrapper
# (its .desktop files are rewritten to launch the wrapper too).
# gui = true adds what graphical apps need (GPU, Wayland, GTK theme, /tmp...).
{inputs, ...}: {
  flake.lib.mkSandbox = pkgs: let
    # nixpak's launcher starts bwrap in a background process group, so TUI apps
    # get stopped by SIGTTOU. Give it the terminal foreground when stdin is a tty.
    nixpak = pkgs.applyPatches {
      name = "nixpak-tui";
      src = inputs.nixpak;
      postPatch = ''
        substituteInPlace launcher/bubblewrap.go --replace-fail \
          'cmd.SysProcAttr = &syscall.SysProcAttr{Setpgid: true}' \
          'cmd.SysProcAttr = &syscall.SysProcAttr{Setpgid: true}
        if _, err := unix.IoctlGetTermios(0, unix.TCGETS); err == nil {
          cmd.SysProcAttr.Foreground = true
          cmd.SysProcAttr.Ctty = 0
        }'

        # With network, nixpak also binds /etc/{resolv.conf,hosts}: redundant since
        # the base binds all of /etc, and fatal as NixOS's /etc/hosts is a symlink
        substituteInPlace modules/bubblewrap.nix --replace-fail \
          'mapNetFiles = config.bubblewrap.network && !config.pasta.enable;' \
          'mapNetFiles = false;'
      '';
    };

    mkNixPak = import "${nixpak}/modules" {
      inherit (pkgs) lib;
      inherit pkgs;
    };

    # Secrets hidden from every sandbox, even when $HOME is bound (shown as empty dirs)
    hiddenPaths = [
      "/.ssh"
      "/.gnupg"
      "/.local/share/keyrings"
      "/.config/sops"
      "/.config/gh"
      "/.mozilla"
      "/.config/net.imput.helium"
    ];

    # TODO: sockets.wayland exposes the raw Wayland socket, including privileged protocols
    # (screencopy, virtual-keyboard, data-control). Look into filtering them later:
    # nixpak's waylandProxy (filters, but breaks wl-copy), Hyprland permissions
    # (ecosystem:enforce_permissions), or a wp_security_context_v1 socket.
    base = {sloth, ...}: {
      dbus.enable = pkgs.lib.mkDefault false; # Opt-in per app
      bubblewrap = {
        network = pkgs.lib.mkDefault false; # Opt-in per app
        dieWithParent = true;
        bind.ro = [
          "/etc" # passwd, /etc/profiles (user PATH), fonts...
          "/run/current-system" # system PATH
        ];
        tmpfs = map (sloth.concat' sloth.homeDir) hiddenPaths;
      };
    };

    guiBase = {
      config,
      sloth,
      ...
    }: {
      gpu.enable = true; # /dev/dri + /run/opengl-driver

      # Only reachable when the app enables dbus
      dbus.policies = {
        "org.freedesktop.portal.Desktop" = "talk"; # File chooser (elio), OpenURI, Settings (dark mode)
        "org.freedesktop.portal.Documents" = "talk";
      };

      bubblewrap = {
        sockets.wayland = true;
        bind.ro = map (sloth.concat' sloth.homeDir) [
          "/.config/gtk-3.0"
          "/.config/gtk-4.0"
          "/.gtkrc-2.0"
          "/.icons" # Cursor
        ];
        # Files picked through the portal file chooser (only this app's view of the document store)
        bind.rw = [
          [
            (sloth.concat [sloth.runtimeDir "/doc/by-app/" config.flatpak.appId])
            (sloth.concat' sloth.runtimeDir "/doc")
          ]
        ];
        bind.dev = [
          # Nvidia, skipped on hosts without it
          "/dev/nvidia0"
          "/dev/nvidiactl"
          "/dev/nvidia-modeset"
          "/dev/nvidia-uvm"
          "/dev/nvidia-uvm-tools"
        ];
        tmpfs = ["/tmp"];
        env.NIXOS_XDG_OPEN_USE_PORTAL = "1"; # xdg-open goes through the portal (when dbus is on)
      };
    };
  in {
    wrap = {
      package,
      gui ? false,
      config ? {},
    }:
      (mkNixPak {
        config = {imports = [base config {app.package = package;}] ++ pkgs.lib.optional gui guiBase;};
      }).config.env;
  };
}
