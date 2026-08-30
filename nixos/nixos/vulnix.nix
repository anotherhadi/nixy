# Vulnix scans the Nix store against the NVD CVE feed to find packages with
# known vulnerabilities.
{pkgs, ...}: {
  environment.systemPackages = [pkgs.vulnix];

  systemd.services.vulnix-scan = {
    description = "Scan the system closure for known vulnerabilities (vulnix)";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.vulnix}/bin/vulnix --system --cache-dir /var/cache/vulnix";
      CacheDirectory = "vulnix";
      # vulnix exits non-zero when it finds vulnerabilities; that's expected,
      # don't let systemd treat the scan itself as a failure.
      SuccessExitStatus = "1 2";
    };
  };

  systemd.timers.vulnix-scan = {
    description = "Daily vulnix scan";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };
}
