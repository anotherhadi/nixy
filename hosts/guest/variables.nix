{ config, ... }: {
  imports = [ ../modules/variables-config.nix ];

  config.var = {
    hostname = "nixy";
    username = "your_username";
    homeDirectory = "/home/" + config.var.username;
    configDirectory = config.var.homeDirectory + "/.config/nixos";

    keyboardLayout = "fr";

    timeZone = "Europe/Paris";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "fr_FR.UTF-8";

    git = {
      username = "your_username";
      email = "your_email";
    };

    stateVersion = "24.05";

    autoUpgrade = false;
    autoGarbageCollector = false;
    nextcloud = false;
    # change the sops configuration if you want to enable that:
    sops = false;
    # change the nvim's obsidian configuration if you want to enable that:
    obsidian = false;

    theme = import ../themes/catppuccin.nix; # select your theme here
  };
}
