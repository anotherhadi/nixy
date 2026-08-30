{
  config,
  lib,
  ...
}: {
  imports = [
    # Choose your theme here:
    ../../themes/nixy.nix
  ];

  config.var = {
    hostname = "nixtop";
    username = "gold3n";
    configDirectory = "/home/" + config.var.username + "/.config/nixos"; # The path of the nixos configuration directory

    keyboardLayout = "us,cz";

    timeZone = "Europe/Prague";
    defaultLocale = "en_GB.UTF-8";
    extraLocale = "cs_CZ.UTF-8";

    git = {
      username = "JustGold3n";
      email = "marek@pavlicek.eu";
    };

    autoUpgrade = false;
    autoGarbageCollector = true;
    impermanenceEnabled = true;
  };

  # DON'T TOUCH THIS
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };
}
