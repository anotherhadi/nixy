let variable = import ../../../variables.nix;
in {
  programs.git = {
    enable = true;
    userName = variable.git.username;
    userEmail = variable.git.email;
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };
}
