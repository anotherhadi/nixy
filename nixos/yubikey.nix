{
  config,
  pkgs,
  ...
}: {
  # ==========================================
  # 1. SYSTEM CONFIGURATION
  # ==========================================

  services.pcscd.enable = true;

  services.udev.packages = with pkgs; [
    yubikey-personalization
    libfido2
  ];

  services.usbguard.rules = ''
    allow id 1050:*
  '';

  # Enable GPG Agent and tell it to act as the SSH agent
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # ==========================================
  # 2. USER CONFIGURATION (Home Manager)
  # ==========================================

  home-manager.users.gold3n = {
    home.packages = with pkgs; [
      yubikey-manager
      yubikey-personalization
      gnupg # Ensure GPG is installed
    ];
  };
}
