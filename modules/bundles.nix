# Groups of aspects, so hosts list features by area
# Importing a bundle and one of its members is fine: aspects are deduplicated (flake/parts.nix)
{aspects, ...}: {
  flake.modules.nixos = with aspects; {
    # System base, on every host
    base.imports = [
      common
      secrets
      theme
      hjem
      nix
      users
      networking
      locale
      cli-base
      kernel-hardening
    ];

    # Terminal environment, on every host
    tui.imports = [
      shell
      ghostty
      git
      btop
      cli-tools
      tldr
      yoinks
      mcat
      chafa
      imagemagick
      opencode
      kew
      eilmeldung
      usbguard-tui
      myx
      proton
      ilovetui
      dev
      claude-code
      nix-index
      signal-notify
      cybersecurity
      nixy
      nvim
      elio
    ];

    # Self-hosted services exposed through the Cloudflare tunnel (modules/server)
    homelab.imports = [
      ssh
      firewall
      fail2ban
      cloudflared
      adguardhome
      glance
      arr
      bentopdf
      cyberchef
      mazanoke
      default-creds
      gitea
      signal-cli-rest-api
      home-assistant
      miniflux
      uptime-kuma
    ];

    # Graphical session: sway + bar, notifications, launcher, lock, theming...
    gui.imports = [
      sway
      desktop
      helium
      signal
      obsidian
      ticktick
      imv
      vlc
      pinta
      onlyoffice
      blanket
      thunar # Backup
      gnome-text-editor # Backup
      filen
    ];
  };
}
