{ config, ... }: {
  imports = [ ../modules/variables-config.nix ];

  config.var = {
    hostname = "nixy";
    username = "hadi";
    homeDirectory = "/home/" + config.var.username;
    configDirectory = config.var.homeDirectory + "/.config/nixos";

    keyboardLayout = "fr";

    timeZone = "Europe/Paris";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "fr_FR.UTF-8";

    git = {
      username = "Hadi";
      email = "112569860+anotherhadi@users.noreply.github.com";
    };

    stateVersion = "24.05";

    autoUpgrade = false;
    autoGarbageCollector = false;
    # change the sops configuration if you want to enable that:
    sops = true;
    # change the nvim's obsidian configuration if you want to enable that:
    obsidian = true;
    tailscale = true;

    theme = import ../themes/catppuccin.nix; # select your theme here
  };
}
