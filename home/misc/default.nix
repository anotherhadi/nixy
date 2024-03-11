{

  # TODO:
  # choose output sound
  # choose wallpaper
  # import wireguard config
  # powermenu
  # menu
  # custom colors on all config files
  # vim format on save

  home.file = {
    ".ssh/config" = {
      text = ''
        Host github.com
          User git
          Hostname github.com
          PreferredAuthentications publickey
          IdentityFile ~/.ssh/github
      '';
      executable = false;
    };
  };
}
