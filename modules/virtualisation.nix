{ config, lib, pkgs, ... }:

{
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  virtualisation.incus = {
    enable = true;
    softDaemonRestart = true;
  };
}
