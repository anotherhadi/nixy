{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    proton-vpn
    proton-pass
  ];

  # Fix Proton Authenticator desktop entry
  xdg.desktopEntries = {
    "Proton Calendar" = {
      name = "Proton Calendar";
      exec = ''${config.programs.helium.package}/bin/helium "https://calendar.proton.me"'';
      icon = "proton-calendar";
      type = "Application";
      categories = ["Utility"];
      terminal = false;
    };
    "Proton Mail" = {
      name = "Proton Mail";
      exec = ''${config.programs.helium.package}/bin/helium "https://mail.proton.me/"'';
      icon = "proton-mail";
      type = "Application";
      categories = ["Utility"];
      terminal = false;
    };
  };

  home.persistence."/persist" = lib.mkIf (config.var.impermanenceEnabled or false) {
    directories = [
      ".config/protonvpn"
      ".config/Proton Pass"
    ];
  };
}
