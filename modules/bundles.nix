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
      kitty
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
      kimi-code
      nix-index
      signal-notify
      cybersecurity
      nixy
      nvim
      elio
    ];

    # Self-hosted services behind Caddy, reachable through NetBird (modules/server)
    homelab.imports = [
      ssh
      firewall
      fail2ban
      caddy
      adguardhome
      arr
      bentopdf
      cyberchef
      mazanoke
      default-creds
      gitea
      home-assistant
      miniflux
      uptime-kuma
      mosquitto
      frigate
      mealie
      blog
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
      thunar # Backup
      filen
    ];
  };
}
