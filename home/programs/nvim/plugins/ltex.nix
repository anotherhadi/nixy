{
  programs.nixvim.plugins.ltex-extra = {
    enable = true;
    settings = {
      initCheck = true;
      loadLangs = [ "en-US" "fr-FR" ];
      logLevel = "non";
    };
  };
}
