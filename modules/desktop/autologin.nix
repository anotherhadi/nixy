# Autologin at boot: greetd starts sway directly on the first VT (Hyprland: pick it in tuigreet)
{
  flake.modules.nixos.autologin = {
    pkgs,
    config,
    lib,
    ...
  }: {
    services.greetd.settings.initial_session = {
      # Same command as tuigreet's "Sway (UWSM)" entry (modules/desktop/sway/system.nix)
      command = "${pkgs.uwsm}/bin/uwsm start -F -- /run/current-system/sw/bin/sway";
      user = config.nixy.username;
    };

    # Needed so the LUKS passphrase entered at boot is cached in the kernel
    # keyring, where pam_fde_boot_pw can retrieve it (see below).
    boot.initrd.systemd.enable = true;

    security.pam.services.greetd.rules.session.fde_boot_pw = {
      order = 12550; # kwallet=12500, gnome_keyring=12600: must run in between
      control = "optional";
      modulePath = "${pkgs.pam_fde_boot_pw}/lib/security/pam_fde_boot_pw.so";
      args = ["inject_for=gkr"];
    };

    security.pam.services.login.enableGnomeKeyring = true;

    systemd.services.greetd.serviceConfig.KeyringMode = lib.mkForce "shared";

    systemd.services.greetd = {
      after = ["systemd-udevd.service"];
      serviceConfig.ExecStartPre = "${pkgs.systemd}/bin/udevadm settle --timeout=10";
    };
  };
}
