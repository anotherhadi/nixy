{
  programs.git = {
    enable = true;
    userName = "Hadi"; # CHANGEME
    userEmail = "112569860+anotherhadi@users.noreply.github.com"; # CHANGEME
    extraConfig = {
      init.defaultBranch = "main";
      # Automatically track remote branch
      push.autoSetupRemote = true;
    };
  };
}
