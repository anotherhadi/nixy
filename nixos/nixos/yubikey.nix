{
  config,
  pkgs,
  ...
}: {
  services.pcscd.enable = true;
  services.udev.packages = [pkgs.yubikey-personalization];

  home-manager.users.gold3n = {
    home.packages = with pkgs; [
      yubikey-manager
      yubikey-personalization
    ];
  };
}
