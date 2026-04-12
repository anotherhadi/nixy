# Auto upgrade some of my inputs every hour.
# With signal notification on failure, but only once per failure streak to avoid spamming me if something is broken for a while.
{
  config,
  pkgs,
  ...
}: let
  configDir = config.var.configDirectory;
  auto-update-inputs = ["blog" "awesome-wallpapers" "iknowyou" "default-creds"];
  signalConfigDir = "/var/lib/signal-cli";
  sentinelFile = "/var/lib/nixos-auto-upgrade/failure-notified";
in {
  sops.secrets."signal-sender-number" = {};
  sops.secrets."signal-receiver-username" = {};

  environment.systemPackages = [pkgs.signal-cli];

  systemd.tmpfiles.rules = [
    "d /var/lib/nixos-auto-upgrade 0700 root root -"
    "d ${signalConfigDir} 0700 root root -"
  ];

  # Main upgrade service
  systemd.services.nixos-auto-upgrade = {
    description = "NixOS auto upgrade";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    onFailure = ["nixos-auto-upgrade-notify.service"];
    script = ''
      set -e
      cd ${configDir}
      ${pkgs.nix}/bin/nix flake update ${builtins.concatStringsSep " " auto-update-inputs}
      /run/current-system/sw/bin/nixos-rebuild switch --flake ${configDir}#jack
      # Clear failure sentinel on success
      rm -f ${sentinelFile}
    '';
  };

  # Notification service — only fires once per failure streak
  systemd.services.nixos-auto-upgrade-notify = {
    description = "Signal notification on NixOS upgrade failure";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Environment = "JAVA_TOOL_OPTIONS=--enable-native-access=ALL-UNNAMED";
    };
    script = ''
      # Already notified for this failure streak, skip
      if [ -f "${sentinelFile}" ]; then
        exit 0
      fi

      SENDER=$(cat ${config.sops.secrets."signal-sender-number".path})
      RECEIVER=$(cat ${config.sops.secrets."signal-receiver-username".path})
      ${pkgs.signal-cli}/bin/signal-cli \
        --config ${signalConfigDir} \
        -u "$SENDER" send \
        -u "$RECEIVER" \
        -m "Jack: nixos-auto-upgrade failed, check the logs: journalctl -u nixos-auto-upgrade"

      touch ${sentinelFile}
    '';
  };

  # Hourly timer
  systemd.timers.nixos-auto-upgrade = {
    description = "NixOS auto upgrade timer";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };
}
