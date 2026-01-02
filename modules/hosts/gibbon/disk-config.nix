let
  mkSubvolume = { name, compress ? "zstd", lazytime ? false }: {
    name = name;
    value = {
      mountpoint = name;
      mountOptions = [
        "compress=${compress}"
        (if lazytime then "lazytime" else "noatime")
      ];
    };
  };
  subvolumes = builtins.listToAttrs (
    map mkSubvolume [
      { name = "/"; }
      { name = "/home"; lazytime = true; }
      { name = "/nix"; }
      { name = "/work"; lazytime = true; }
    ]
  );
in {
  disko.devices.disk = {
    main = {
      type = "disk";
      device = "/dev/nvme0n1";
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
