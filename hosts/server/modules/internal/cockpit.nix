# Web-based graphical interface for servers
{ pkgs, ... }: {
  services.cockpit = {
    enable = true;
    port = 3009;
    openFirewall = true;
    settings.WebService = { AllowUnencrypted = true; };
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    selinux-python
    cockpit
  ];
}
