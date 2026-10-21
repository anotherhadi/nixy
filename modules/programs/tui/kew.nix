# Kew is a TUI audio player
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mime;
in {
  flake.modules.nixos.kew = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: let
        kewLauncher = pkgs.writeShellScript "kew-launcher" ''
          if [ -n "$1" ]; then
            exec ${pkgs.kew}/bin/kew play "$1"
          else
            exec ${pkgs.kew}/bin/kew
          fi
        '';
      in {
        packages = [
          pkgs.kew
          (pkgs.makeDesktopItem {
            name = "kew";
            desktopName = "Music Player";
            exec = "${pkgs.ghostty}/bin/ghostty --window-padding-x=0 --window-padding-y=0 -e ${kewLauncher} %f";
            comment = "Play music from the terminal";
            categories = ["Audio" "Music"];
            terminal = false;
            mimeTypes = mime.types.audio;
            keywords = ["lofi" "player" "music"];
          })
        ];

        xdg.mime-apps = mime.defaultFor "kew.desktop" mime.types.audio;

        persist.directories = [".config/kew"];
      })
    ];
  };
}
