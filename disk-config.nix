let
  mkSubvolume = { name, compress ? "zstd", atime ? "noatime" }: {
    name = name;
    value = {
      mountpoint = name;
      mountOptions = [ "compress=${compress}" atime ];
    };
  };
  subvolumes = builtins.listToAttrs (
    map mkSubvolume [
      { name = "/"; }
      { name = "/home"; atime = "lazyatime"; }
      { name = "/nix"; }
      { name = "/work"; atime = "lazyatime"; }
    ]
  );
in {
  disko.devices.disk = {
    main = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              settings.allowDiscards = true;
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                inherit subvolumes;
              };
            };
          };
        };
      };
    };
  };
}
