{
  programs.git = {
    enable = true;
    userName = "Hadi";
    userEmail = "112569860+anotherhadi@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      # Automatically track remote branch
      push.autoSetupRemote = true;
    };
  };
}
