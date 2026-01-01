{
  disko.devices.disk.main = {
    device = "/dev/sda";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "LuksyDisk";
            settings.allowDiscards = true;
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "/work" = {
                  mountpoint = "/work";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/private" = {
                  mountpoint = "/work";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
