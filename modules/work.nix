{ config, lib, pkgs, ... }:

{
  # create /etc/timezone with the same value.
  # Required by the tooling to setup our work repositories (devr).
  environment.etc."timezone".text = config.time.timeZone + "\n";

  environment.systemPackages = with pkgs; [
    docker
    docker-buildx
    docker-compose
  ];

  services.envfs.enable = true;
}
