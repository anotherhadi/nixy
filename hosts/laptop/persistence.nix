# Impermanence: declares what should survive a wipe of "/".
{config, ...}: {
  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      "/etc/NetworkManager/system-connections" # Wifi connections, VPN
      "/var/lib/bluetooth" # Bluetooth connections
      "/var/lib/nixos" # keeps uid/gid stable across boots
      "/var/lib/systemd/coredump"
      "/var/lib/upower" # battery calibration state
      "/var/lib/systemd/backlight" # remembers screen brightness
      "/var/lib/systemd/timers" # last-run timestamps (e.g. nix gc weekly)
      "/var/log"
      "/var/cache/tuigreet"
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/var/lib/systemd/random-seed" # avoid a weak entropy pool on first boot
    ];
  };

  # -- How to find what's missing --
  # Use the system normally for a week or two, then look for files that
  # changed recently outside of what's already declared above:
  #   find "/home/${config.var.username}" -xdev -type f -mtime -14 \
  #     -not -path '*/.cache/*' -not -path '*/Cache/*' | less
  # Anything that keeps showing up there (app state, history files,
  # game saves, browser profile, spotify/lazygit config, GPG state, etc.)
  # is a candidate to add above. Do this *before* switching root to a
  # wipeable filesystem, not after.
}
