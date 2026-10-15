# Impermanence: "/" is wiped at boot (tmpfs), what must survive lives in /persist
# Hosts opt in by importing this aspect. Features simply declare their state with
#   environment.persistence."/persist".directories = [...];   (system)
#   hjem: persist.directories = [...];                       (home)
# The impermanence module is loaded on every host (common.nix) with /persist
# disabled, so those declarations do nothing on hosts without this aspect.
{aspects, ...}: {
  flake.modules.nixos.impermanence = {
    imports = [aspects.hjem];

    environment.persistence."/persist" = {
      enable = true;
      hideMounts = true;

      directories = [
        "/var/lib/nixos" # keeps uid/gid stable across boots
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/timers" # last-run timestamps (e.g. nix gc weekly)
        "/var/log"
        "/var/db/sudo/lectured" # remembers that the sudo lecture was already shown
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

    # Home: hosts add their own folders (Music, .steam...) with hjem.users.<user>.persist
    hjem.extraModules = [
      {
        persist = {
          directories = [
            ".config/nixos" # this repo itself (nixy manages it here)
            ".local/share"
            ".local/state"
            ".cache"
            "Notes"
            "Projects"
            "Documents"
            "Downloads"
            "Pictures"
            "Videos"
          ];

          files = [
            ".ssh/known_hosts"
            ".config/sops/age/keys.txt"
          ];
        };
      }
    ];
  };
}
