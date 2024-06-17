{ config, ... }: {
  imports = [ ../shared/variables-config.nix ];

  config.var = {
    hostname = "nixy";
    username = "hadi";
    homeDirectory = "/home/" + config.var.username;

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
    sops = true; # change the sops configuration if you want to enable that
    nextcloud = true;
    obsidian = true; # change the nvim's obsidian configuration if you want to enable that

    theme = import ../themes/nixy.nix; # select your theme here
  };
}
