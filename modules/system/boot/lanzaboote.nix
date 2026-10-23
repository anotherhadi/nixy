# Secure Boot via lanzaboote (signed systemd-boot + unified kernel images)
#
# One-time setup on the machine (not handled by Nix):
#   1. sudo sbctl create-keys
#   2. Reboot into firmware setup, put Secure Boot in "Setup Mode"
#   3. nixos-rebuild switch (this signs the current generation with the new keys)
#   4. sudo sbctl enroll-keys --microsoft
#   5. Reboot, re-enable Secure Boot in firmware
{
  inputs,
  aspects,
  ...
}: {
  flake.modules.nixos.lanzaboote = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.lanzaboote.nixosModules.lanzaboote
      aspects.boot
    ];

    # lanzaboote replaces systemd-boot
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    environment.systemPackages = [pkgs.sbctl];
    environment.persistence."/persist".directories = ["/var/lib/sbctl"]; # Secure Boot keys
  };
}
