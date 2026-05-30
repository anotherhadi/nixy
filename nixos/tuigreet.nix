{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  c = config.lib.stylix.colors;
  tuigreet = inputs.notashelf-tuigreet.packages.${pkgs.stdenv.hostPlatform.system}.default;

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
    exec ${tuigreet}/bin/tuigreet \
      --time \
      --time-format '%H:%M  %A %d %B' \
      --sessions /run/current-system/sw/share/wayland-sessions \
      --remember \
      --remember-user-session \
      --asterisks \
      --greeting '  Welcome' \
      --container-padding 2 \
      --theme '${theme}' \
      --power-shutdown 'systemctl poweroff' \
      --power-reboot 'systemctl reboot'
  '';
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet-launch}";
        user = "greeter";
      };
    };
  };

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  environment.systemPackages = [tuigreet];
}
