{ inputs, ... }: {
  imports = [ inputs.nixcord.homeManagerModules.nixcord ];

  programs.nixcord = {
    enable = true;
    config = { frameless = true; };
  };
}
