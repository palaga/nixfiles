# save as sd-image.nix somewhere
{ pkgs, ... }: {
  # Raspberry Pi 3 specific
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi3;

    # Filesystem support
    supportedFilesystems.btrfs = true;
  };

  # Hardware
  hardware.enableRedistributableFirmware = true;

  # Enable SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  # put your own configuration here, for example ssh keys:
  users.users.root.openssh.authorizedKeys.keys = [
     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINn4vy/oDBsMjwjasAcPjv0gQ86Uw9ERAi+bBH6m6wcF termux@nord3t"
  ];

  # Create your user with SSH key
  users.users.chris = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINn4vy/oDBsMjwjasAcPjv0gQ86Uw9ERAi+bBH6m6wcF termux@nord3t"
    ];
    # Initial password (change after first login)
    initialPassword = "changeme";
  };

  # Allow passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  # Network configuration - DHCP on ethernet
  networking = {
    useDHCP = false;
    interfaces.eth0.useDHCP = true;
    hostName = "maki";
  };

  # Useful packages
  environment.systemPackages = with pkgs; [
    mg
    git
    htop
    curl
  ];

  system.stateVersion = "25.11";
}
