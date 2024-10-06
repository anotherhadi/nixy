{ config, ... }: {
  imports = [ ../../nixos/variables-config.nix ];

  config.var = {
    hostname = "nixy";
    username = "hadi";
    homeDirectory = "/home/" + config.var.username;
    configDirectory = config.var.homeDirectory + "/.config/nixos";

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

    # SOPS
    # Sops is a tool to store secrets in git repositories encrypted with GPG.
    # change the sops configuration if you want to enable that:
    sops = true;

    # theme = import ../themes/nixy.nix; # select your theme here
    theme = {
      rounding = 15;
      gaps-in = 10;
      gaps-out = 10 * 2;
      active-opacity = 1;
      inactive-opacity = 0.89;
      blur = true;
      border-size = 3;
      animation-speed = "fast"; # "fast" | "medium" | "slow"
      fetch = "nerdfetch"; # "nerdfetch" | "neofetch" | "pfetch" | "none"

      bar = {
        transparent = false;
        floating = false;
        font-size = 16;
      };
    };
  };
}
