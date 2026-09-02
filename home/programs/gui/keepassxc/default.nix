{
  pkgs,
  config,
  ...
}: {
  systemd.user.services.keepassxc-autounlock = {
    Unit = {
      Description = "Securely auto-unlock KeePassXC in the background";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "exec";
      # Pipes the sops-nix secret via stdin to prevent exposure in process lists.
      # KeePassXC will automatically request the YubiKey challenge-response upon startup.
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.keepassxc}/bin/keepassxc --background --pw-stdin /path/to/your/database.kdbx < ${config.sops.secrets.keepassxc_secret.path}'";

      # Hardening measures to restrict service capabilities
      NoNewPrivileges = true;
      RestrictRealtime = true;
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
