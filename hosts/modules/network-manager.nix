{ pkgs, ... }: {
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
