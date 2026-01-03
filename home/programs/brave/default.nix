{pkgs, ...}: {
  programs.brave = {
    enable = true;
    commandLineArgs = [
      "--no-default-browser-check"
    ];
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.brave}/bin/brave";
  };
}
