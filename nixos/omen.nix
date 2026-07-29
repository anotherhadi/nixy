# Omen laptop configuration for NixOS
# Import this only if you have an HP Omen laptop
{
  config,
  pkgs,
  ...
}: let
  hp-omen-linux-module = pkgs.callPackage (
    {
      kernel ? config.boot.kernelPackages.kernel,
      stdenv,
      fetchFromGitHub,
    }:
      stdenv.mkDerivation (finalAttrs: {
        pname = "hp-omen-linux-module";
        version = "rebase-6.15";
        # Upstream only rebases per kernel branch and currently tops out at
        # rebase-6.15, while linuxPackages_latest is already on 7.x. If the
        # module ever fails to build against a newer kernel, either bump this
        # to a fresh upstream branch or fall back to a stable kernel.
        src = fetchFromGitHub {
          owner = "ranisalt";
          repo = "hp-omen-linux-module";
          rev = "d4b9b5adb84581c3874ca3985dc749c40c3ece67"; # rebase-6.15
          sha256 = "sha256-IOXHzcCB0n1InMjeIu3XYEJ4bhbHS3NIlS8/+4XIwkQ=";
        };
        setSourceRoot = ''
          export sourceRoot=$(pwd)/${finalAttrs.src.name}/src
        '';
        nativeBuildInputs = kernel.moduleBuildDependencies;
        makeFlags = [
          "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
        ];
        installPhase = ''
          runHook preInstall
          install hp-wmi.ko -Dm444 -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86/hp/
          runHook postInstall
        '';
      })
  ) {kernel = config.boot.kernelPackages.kernel;};
in {
  boot.extraModulePackages = [hp-omen-linux-module];
  boot.kernelModules = ["hp-wmi"];
  boot.kernelParams = ["hp_wmi.force_slow_fan_control=1"];

  users.groups.omen-rgb = {};
  users.users.${config.var.username}.extraGroups = ["omen-rgb"];

  systemd.tmpfiles.rules = [
    "w /sys/devices/platform/hp-wmi/rgb_zones/zone00 0660 root omen-rgb -"
    "w /sys/devices/platform/hp-wmi/rgb_zones/zone01 0660 root omen-rgb -"
    "w /sys/devices/platform/hp-wmi/rgb_zones/zone02 0660 root omen-rgb -"
    "w /sys/devices/platform/hp-wmi/rgb_zones/zone03 0660 root omen-rgb -"
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="platform", KERNEL=="hp-wmi", ACTION=="add", \
    RUN+="${pkgs.coreutils-full}/bin/sleep 2", \
    RUN+="${pkgs.coreutils}/bin/chgrp omen-rgb /sys/devices/platform/hp-wmi/rgb_zones/zone00", \
    RUN+="${pkgs.coreutils}/bin/chmod 0660 /sys/devices/platform/hp-wmi/rgb_zones/zone00", \
    RUN+="${pkgs.coreutils}/bin/chgrp omen-rgb /sys/devices/platform/hp-wmi/rgb_zones/zone01", \
    RUN+="${pkgs.coreutils}/bin/chmod 0660 /sys/devices/platform/hp-wmi/rgb_zones/zone01", \
    RUN+="${pkgs.coreutils}/bin/chgrp omen-rgb /sys/devices/platform/hp-wmi/rgb_zones/zone02", \
    RUN+="${pkgs.coreutils}/bin/chmod 0660 /sys/devices/platform/hp-wmi/rgb_zones/zone02", \
    RUN+="${pkgs.coreutils}/bin/chgrp omen-rgb /sys/devices/platform/hp-wmi/rgb_zones/zone03", \
    RUN+="${pkgs.coreutils}/bin/chmod 0660 /sys/devices/platform/hp-wmi/rgb_zones/zone03"
  '';
}
