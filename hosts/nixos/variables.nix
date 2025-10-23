{
  config,
  lib,
  ...
}: {
  imports = [
    # Choose your theme here:
    ../../themes/catppuccin.nix
  ];

  config.var = {
    hostname = "nixos";
    username = "shaver";
    configDirectory =
      "/home/"
      + config.var.username
      + "/.config/nixos"; # The path of the nixos configuration directory

    keyboardLayout = "es";

    location = "Madrid";
    timeZone = "Europe/Madrid";
    defaultLocale = "es_ES.UTF-8";
    extraLocale = "es_ES.UTF-8";

    git = {
      username = "Shaver";
      email = "Shaver@mail.com";
    };

    autoUpgrade = false;
    autoGarbageCollector = true;
  };

  # Let this here
  options = {
    var = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };
}
