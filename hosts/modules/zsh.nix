{
  programs.zsh = {
    enable = true;
    loginShellInit = ''
      dbus-update-activation-environment --systemd DISPLAY
    '';
  };
}
