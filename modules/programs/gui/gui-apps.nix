# Graphical applications
{
  aspects,
  config,
  ...
}: let
  inherit (config.flake.lib) mime;
in {
  flake.modules.nixos.gui-apps = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({
        lib,
        pkgs,
        ...
      }: {
        packages = with pkgs; [
          imv # Image viewer
          vlc # Video player
          obsidian # Note taking app
          pinta # Image editor
          onlyoffice-desktopeditors # Office suite
          blanket # Listen to different sounds
          signal-desktop # Messaging app
          ticktick # Todo app

          # Backup
          thunar
          gnome-text-editor
        ];

        xdg.mime-apps = lib.mkMerge [
          (mime.defaultFor "imv-dir.desktop" mime.types.image)
          (mime.defaultFor "vlc.desktop" mime.types.video)
          (mime.defaultFor "onlyoffice-desktopeditors.desktop" mime.types.office)
        ];

        persist.directories = [
          ".config/ticktick"
          ".config/Signal"
          ".config/obsidian"
        ];
      })
    ];
  };
}
