{
  config,
  pkgs,
  ...
}: {
  # Enable offline sync and background notification services
  programs.mbsync.enable = true;
  services.imapnotify.enable = true;

  accounts.email.accounts = {
    # ----------------------------------------------------
    # 1. Personal Account
    # ----------------------------------------------------
    personal = {
      primary = true;
      address = "marek@pavlicek.eu";
      userName = "marek@pavlicek.eu";
      realName = "Marek Pavlíček";

      imap.host = "imap.zoner.com";
      smtp.host = "smtp.zoner.com";

      passwordCommand = "${pkgs.coreutils}/bin/cat /run/secrets/personal-email";
      aerc.enable = true;

      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };

      imapnotify = {
        enable = true;
        boxes = ["INBOX"];
        onNotify = "${pkgs.libnotify}/bin/notify-send 'Email' 'New message in Personal'";
        onNotifyPost = "${pkgs.isync}/bin/mbsync personal";
      };
    };

    # ----------------------------------------------------
    # 2. Seznam Account
    # ----------------------------------------------------
    seznam = {
      address = "e1markus@seznam.cz";
      userName = "e1markus@seznam.cz";
      realName = "E1 Markus";

      imap.host = "imap.seznam.cz";
      smtp.host = "smtp.seznam.cz";

      passwordCommand = "${pkgs.coreutils}/bin/cat /run/secrets/seznam-email";
      aerc.enable = true;

      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };

      imapnotify = {
        enable = true;
        boxes = ["INBOX"];
        onNotify = "${pkgs.libnotify}/bin/notify-send 'Email' 'New message in Seznam'";
        onNotifyPost = "${pkgs.isync}/bin/mbsync seznam";
      };
    };

    # ----------------------------------------------------
    # 3. Google Account
    # ----------------------------------------------------
    google = {
      address = "m2a3r3k4@gmail.com";
      userName = "m2a3r3k4@gmail.com";
      realName = "M2A3";

      imap.host = "imap.gmail.com";
      smtp.host = "smtp.gmail.com";

      passwordCommand = "${pkgs.coreutils}/bin/cat /run/secrets/google-email";
      aerc.enable = true;

      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };

      imapnotify = {
        enable = true;
        boxes = ["INBOX"];
        onNotify = "${pkgs.libnotify}/bin/notify-send 'Email' 'New message in Google'";
        onNotifyPost = "${pkgs.isync}/bin/mbsync google";
      };
    };

    # ----------------------------------------------------
    # 4. Work Account
    # ----------------------------------------------------
    work = {
      address = "pavlicek@vshosting.cz";
      userName = "pavlicek@vshosting.cz";
      realName = "Marek Pavlíček";

      imap.host = "intcom.vshosting.cz";
      smtp.host = "intcom.vshosting.cz";

      passwordCommand = "${pkgs.coreutils}/bin/cat /run/secrets/work-email";
      aerc.enable = true;

      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };

      imapnotify = {
        enable = true;
        boxes = ["INBOX"];
        onNotify = "${pkgs.libnotify}/bin/notify-send 'Email' 'New message in Work'";
        onNotifyPost = "${pkgs.isync}/bin/mbsync work";
      };
    };
  };

  # ----------------------------------------------------
  # Aerc UI and General Configuration
  # ----------------------------------------------------
  programs.aerc = {
    enable = true;
    extraConfig = {
      general = {
        editor = "nvim";
        unsafe-accounts-conf = true;
      };
      ui = {
        border-char-vertical = "│";
        border-char-horizontal = "─";
      };
    };
  };

  # ----------------------------------------------------
  # Custom Keybindings Injection
  # ----------------------------------------------------
  xdg.configFile."aerc/binds.conf".source = pkgs.runCommand "aerc-binds.conf" {} ''
    cp ${pkgs.aerc}/share/aerc/binds.conf $out
    chmod +w $out

    cat << 'EOF' >> $out

    [messages]
    <C-l> = :next-tab<Enter>
    <C-h> = :prev-tab<Enter>
    r = :read -t<Enter>
    R = :mark -a<Enter>:read<Enter>
    [view]
    <C-l> = :next-tab<Enter>
    <C-h> = :prev-tab<Enter>

    [terminal]
    <C-l> = :next-tab<Enter>
    <C-h> = :prev-tab<Enter>
    EOF
  '';
}
