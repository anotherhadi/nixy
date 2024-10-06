{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ blueman ];
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;
}
