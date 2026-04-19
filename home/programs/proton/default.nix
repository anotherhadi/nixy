{pkgs, ...}: {
  home.packages = with pkgs; [
    proton-vpn
    proton-pass
    proton-authenticator
  ];

  # Fix Proton Authenticator desktop entry
  xdg.desktopEntries = {
    "Proton Authenticator" = {
      name = "Proton Authenticator";
      exec = "env WEBKIT_DISABLE_COMPOSITING_MODE=1 ${pkgs.proton-authenticator}/bin/proton-authenticator";
      icon = "proton-authenticator";
      type = "Application";
      categories = ["Utility"];
      terminal = false;
    };
    "Proton Calendar" = {
      name = "Proton Calendar";
      exec = "${pkgs.qutebrowser}/bin/qutebrowser \"https://calendar.proton.me\"";
      icon = "proton-calendar";
      type = "Application";
      categories = ["Utility"];
      terminal = false;
    };
    "Proton Mail" = {
      name = "Proton Mail";
      exec = "${pkgs.qutebrowser}/bin/qutebrowser \"https://mail.proton.me/\"";
      icon = "proton-mail";
      type = "Application";
      categories = ["Utility"];
      terminal = false;
    };
  };
}
