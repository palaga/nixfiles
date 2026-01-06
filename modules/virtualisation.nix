{ config, lib, pkgs, ... }:

{
  virtualisation.docker = {
    rootless = {
      enable = true;
      setSocketVariable = true;

      daemon.settings = {
        experimental = true;
        dns = [ "1.1.1.1" "8.8.8.8" ];

        features = {
          containerd-snapshotter = true; # Modern.
        };

        default-address-pools = [
          {
            base = "172.30.0.0/16";
            size = 24;
          }
        ];
      };
    };
  };

  virtualisation.incus = {
    enable = true;
    softDaemonRestart = true;
  };
}
