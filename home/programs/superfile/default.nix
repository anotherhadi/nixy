{config, ...}: {
  xdg.userDirs = {
    enable = true;
    setSessionVariables = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/Desktop";
    download = "${config.home.homeDirectory}/Downloads";
    pictures = "${config.home.homeDirectory}/Pictures";
    music = null;
    documents = null;
    videos = null;
    templates = null;
    publicShare = null;
  };

  programs.superfile = {
    enable = true;
    firstUseCheck = false;
    pinnedFolders = [
      {
        name = "dev";
        location = "/home/hadrien/dev";
      }
      {
        name = "nixos";
        location = "/home/hadrien/.config/nixos";
      }
      {
        name = "trash";
        location = "/home/hadrien/.local/share/Trash/files";
      }
    ];
    settings = {
      transparent_background = true;
      ignore_missing_fields = true;
    };
  };
}
