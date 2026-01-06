{
  imports = [
    ./disk-config.nix
    ./hardware-configuration.nix
    ../../boot.nix
    ../../desktop.nix
    ../../emacs.nix
    ../../system.nix
    ../../users.nix
    ../../network.nix
    ../../stylix.nix
    ../../virtualisation.nix
    ../../work.nix
  ];

  # TODO: facter seems to fail for me, on some graphics kernel modules.
  # hardware.facter.reportPath = ./facter.json;

  networking.hostName = "gibbon";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
