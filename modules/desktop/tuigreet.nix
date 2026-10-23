# Tuigreet: TUI login manager (greetd)
{config, ...}: let
  c = config.theme.colors;
in {
  flake.modules.nixos.tuigreet = {
    pkgs,
    lib,
    ...
  }: let
    theme = lib.concatStringsSep ";" [
      "border=#${c.base0D}"
      "text=#${c.base05}"
      "prompt=#${c.base0D}"
      "action=#${c.base0C}"
      "button=#${c.base0D}"
      "container=#${c.base00}"
      "input=#${c.base02}"
    ];

    tuigreet-launch = pkgs.writeShellScript "tuigreet-launch" ''
      exec ${pkgs.tuigreet}/bin/tuigreet \
        --time \
        --time-format '%H:%M  %A %d %B' \
        --sessions /run/current-system/sw/share/wayland-sessions \
        --remember \
        --remember-user-session \
        --asterisks \
        --greeting 'Welcome' \
        --container-padding 2 \
        --theme '${theme}' \
        --power-shutdown 'systemctl poweroff' \
        --power-reboot 'systemctl reboot'
    '';
  in {
    environment.persistence."/persist".directories = ["/var/cache/tuigreet"]; # --remember

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${tuigreet-launch}";
          user = "greeter";
        };
      };
    };

    security.pam.services.greetd.enableGnomeKeyring = true;

    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
