# Discord is a popular chat application.
{inputs, ...}: {
  imports = [inputs.nixcord.homeModules.nixcord];

  programs.nixcord = {
    enable = true;
    config = {frameless = true;};
  };
}
