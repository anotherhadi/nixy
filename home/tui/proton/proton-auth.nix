{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = [
    pkgs-unstable.andcli # 2FA TUI for your shell
  ];

  home.persistence."/persist" = lib.mkIf (config.var.impermanenceEnabled or false) {
    directories = [".config/andcli"];
  };

  programs.zsh.shellAliases."andcli" = "${pkgs-unstable.andcli}/bin/andcli ~/.cache/protonauth.json.txt --type protonauth";

  xdg.desktopEntries.andcli = {
    name = "andcli";
    exec = "${pkgs.ghostty}/bin/ghostty +new-window -e ${pkgs-unstable.andcli}/bin/andcli ${config.home.homeDirectory}/.cache/protonauth.json.txt --type protonauth";
    comment = "2FA TUI for your shell";
    categories = ["Utility" "Security" "ConsoleOnly"];
    terminal = false;
    settings.Keywords = "2fa;otp;totp;authenticator;security";
  };
}
