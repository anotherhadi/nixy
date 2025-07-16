# Omen laptop configuration for NixOS
# Import this only if you have an HP Omen laptop
{
  config,
  pkgs,
  ...
}: let
  hp-omen-linux-module =
    pkgs.callPackage
    ({
      kernel ? config.boot.kernelPackages.kernel,
      stdenv,
      fetchFromGitHub,
    }:
      stdenv.mkDerivation (finalAttrs: {
        pname = "hp-omen-linux-module";
        version = "rebase-6.14";
        src = fetchFromGitHub {
          owner = "ranisalt";
          repo = "hp-omen-linux-module";
          rev = finalAttrs.version;
          sha256 = "sha256-2zCm29bdboSjRm/caMjBPGNc0tZXPUnIIYlHxxfhAok=";
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
      })) {kernel = config.boot.kernelPackages.kernel;};
in {
  boot.extraModulePackages = [hp-omen-linux-module];
  boot.kernelModules = ["hp-wmi"];

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
