# Sandboxing helper built on nixpak (declarative bubblewrap)
# Usage, from any flake-parts module:
#   (config.flake.lib.mkSandbox pkgs).wrap { package = pkgs.foo; config = { sloth, ... }: { ... }; }
# Returns the package with its main binary replaced by the sandboxed wrapper.
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
      '';
    };

    mkNixPak = import "${nixpak}/modules" {
      inherit (pkgs) lib;
      inherit pkgs;
    };

    # Secrets hidden from every sandbox, even when $HOME is bound (shown as empty dirs)
    # TODO: Why this start with /
    hiddenPaths = [
      "/.ssh"
      "/.gnupg"
      "/.local/share/keyrings"
      "/.config/sops"
      "/.config/gh"
      "/.mozilla"
      "/.config/net.imput.helium"
    ];

    base = {sloth, ...}: {
      dbus.enable = false; # Opt-in per app
      bubblewrap = {
        network = false; # Opt-in per app
        dieWithParent = true;
        bind.ro = [
          "/etc" # passwd, /etc/profiles (user PATH), fonts...
          "/run/current-system" # system PATH
        ];
        tmpfs = map (sloth.concat' sloth.homeDir) hiddenPaths;
      };
    };
  in {
    wrap = {
      package,
      config ? {},
    }:
      (mkNixPak {
        config = {imports = [base config {app.package = package;}];};
      }).config.env;
  };
}
