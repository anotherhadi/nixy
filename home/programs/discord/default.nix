# Discord is a popular chat application.
{ inputs, ... }: {
  imports = [ inputs.nixcord.homeManagerModules.nixcord ];

  programs.nixcord = {
    enable = true;
    config = { frameless = true; };
  };
}
