{
  config,
  lib,
  ...
}: {
  imports = [
    # Choose your theme here:
    ../../themes/rose-pine.nix
  ];

  config.var = {
    hostname = "jack";
    username = "hadi";
    configDirectory = "/home/" + config.var.username + "/.config/nixos"; # The path of the nixos configuration directory

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
    autoGarbageCollector = true;

    domain = "hadi.icu";
    tunnelId = "a1dfa315-7fc3-4a65-8c02-8387932c35c3";
    networkInterface = "enp3s0";
  };

  # Let this here
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };
}
