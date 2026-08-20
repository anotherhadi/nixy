{
  inputs,
  lib,
  pkgs,
  pkgs-stable,
}:
{
  imports = [inputs.zen-browser.homeModules.beta];

  stylix.targets.zen-browser.profileNames = ["default"];

  home.sessionVariables = {
    MOZ_LEGACY_PROFILES = 1;
    DEFAULT_BROWSER = "zen-beta";
    BROWSER = "zen-beta";
  };

  programs.zen-browser = {
    enable = true;
    languagePacks = ["en-US" "fr"];
  };


  profiles = {
    default = {
      id = 0;
      name = "default";
      isDefault = true;
      containersForce = true;
      pinsForce = true;
      spacesForce = true;
      };
    };
}
