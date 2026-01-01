{pkgs, ...}: {
  programs.vivaldi = {
    enable = true;
    commandLineArgs = [
      "--no-default-browser-check"
    ];
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.vivaldi}/bin/vivaldi";
  };
}
