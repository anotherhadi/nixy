{ config, ... }: {
  imports = [ ../../nixos/variables-config.nix ];

  config.var = {
    hostname = "nixy";
    username = "hadi";
    configDirectory = "/home/" + config.var.username
      + "/.config/nixos"; # The path of the nixos configuration directory

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

    theme = import ../../themes/var/nixy.nix;
  };
}
