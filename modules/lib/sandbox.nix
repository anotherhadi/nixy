# Sandboxing helper built on nixpak
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

        # Hidden paths missing on the host can't get a
        # tmpfs mountpoint under a read-only $HOME bind. Nothing to hide there: skip them.
        substituteInPlace launcher/bubblewrap.go --replace-fail \
          '"4"}, conf.BwrapArgs...)' \
          '"4"}, skipMissingTmpfs(conf.BwrapArgs)...)'
        cat >> launcher/bubblewrap.go <<'EOF'

        func skipMissingTmpfs(args []string) (out []string) {
        	for i := 0; i < len(args); i++ {
        		if args[i] == "--tmpfs" && i+1 < len(args) {
        			if _, err := os.Lstat(args[i+1]); err != nil {
        				i++
        				continue
        			}
        		}
        		out = append(out, args[i])
        	}
        	return
        }
        EOF

        # Scripts copied to rewrite their paths (e.g. imv's bin/imv picking imv-wayland)
        # lose their exec bit to --no-preserve=mode: restore it from the original
        substituteInPlace modules/launch.nix --replace-fail \
          'substituteInPlace "$line" --replace-fail' \
          'test -x ''${app}/$(realpath -s --relative-to=$out "$line") && chmod +x "$line"; substituteInPlace "$line" --replace-fail'

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
    # nixpak's waylandProxy (filters, but breaks wl-copy) or a wp_security_context_v1
    # socket (sway restricts privileged protocols for those clients).
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
        "org.freedesktop.portal.Desktop" = "talk";
        "org.freedesktop.portal.Documents" = "talk";
      };

      bubblewrap = {
        sockets.wayland = true;
        bind.ro = map (sloth.concat' sloth.homeDir) [
          "/.config/gtk-3.0"
          "/.config/gtk-4.0"
          "/.gtkrc-2.0"
          "/.icons"
        ];
        # Files picked through the portal file chooser
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
        # Mounted after the binds, it would hide /tmp/.X11-unix: X11 apps get bwrap's empty /tmp
        tmpfs = pkgs.lib.optional (!config.bubblewrap.sockets.x11) "/tmp";
        env.NIXOS_XDG_OPEN_USE_PORTAL = "1"; # xdg-open goes through the portal
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
