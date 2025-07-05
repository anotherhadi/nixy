{ config, lib, ... }: {
  imports = [
    # Choose your theme here:
    ../../themes/catppuccin.nix
  ];

  config.var = {
    hostname = "nixos";
    username = "nixos";
    configDirectory = "/home/" + config.var.username
      + "/etc/nixos"; # The path of the nixos configuration directory

    # keyboardLayout = "en";

    location = "Berlin";
    timeZone = "Europe/Berlin";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "ru_RU.UTF-8";

    git = {
      username = "NazariiPalahnii";
      email = "nazariipalahnii@gmail.com";
    };

    autoUpgrade = false;
    autoGarbageCollector = true;
  };

  # Let this here
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
