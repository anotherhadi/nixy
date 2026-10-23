# XDG user directories (Documents, Downloads... plus Notes and Cyber)
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({config, ...}: let
      home = config.directory;
    in {
      xdg.config.files."user-dirs.dirs".text = ''
        XDG_CYBER_DIR="${home}/Cyber"
        XDG_DOCUMENTS_DIR="${home}/Documents"
        XDG_DOWNLOAD_DIR="${home}/Downloads"
        XDG_MUSIC_DIR="${home}/Music"
        XDG_NOTES_DIR="${home}/Notes"
        XDG_PICTURES_DIR="${home}/Pictures"
        XDG_PROJECTS_DIR="${home}/Projects"
        XDG_VIDEOS_DIR="${home}/Videos"
      '';
      # Don't let xdg-user-dirs-update rewrite the file above
      xdg.config.files."user-dirs.conf".text = "enabled=False";
    })
  ];
}
