{ config, ... }: {
  imports = [ ../../nixos/variables-config.nix ];

  config.var = {
    hostname = "nixy";
    username = "hadi";
    configDirectory = "/home/" + config.var.username + "/.config/nixos";

    keyboardLayout = "fr";

    location = "Paris";
    timeZone = "Europe/Paris";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "fr_FR.UTF-8";

    git = {
      username = "Hadi";
      email = "112569860+anotherhadi@users.noreply.github.com";
    };

    autoUpgrade = false;
    autoGarbageCollector = false;

    theme = {
      rounding = 15;
      gaps-in = 10;
      gaps-out = 10 * 2;
      active-opacity = 1;
      inactive-opacity = 0.89;
      blur = true;
      border-size = 3;
      animation-speed = "medium"; # "fast" | "medium" | "slow"
      fetch = "nerdfetch"; # "nerdfetch" | "neofetch" | "pfetch" | "none"

      bar = {
        transparent = false;
        floating = true;
        font-size = 15;
      };
    };
  };
}
