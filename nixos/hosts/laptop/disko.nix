{
  disko.devices = {
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "size=12G"
          "mode=755"
        ];
      };
    };

    disk = {
      boot = {
        type = "disk";
        device = "/dev/disk/by-uuid/5251-9B85";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = ["fmask=0077" "dmask=0077"];
        };
      };

      nixos = {
        type = "disk";
        device = "/dev/disk/by-uuid/e3110976-78ee-4868-94c4-a3c052aee359";
        content = {
          type = "luks";
          name = "crypted";
          settings = {
            allowDiscards = true;
            bypassWorkqueues = true;
          };
          content = {
            type = "btrfs";
            extraArgs = ["-f"];
            subvolumes = {
              "/nix" = {
                mountpoint = "/nix";
                mountOptions = ["compress=zstd" "noatime"];
              };
              "/persist" = {
                mountpoint = "/persist";
                mountOptions = ["compress=zstd" "noatime"];
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;
}
