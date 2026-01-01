{ config, lib, pkgs, ... }:

{
  # Bootloader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;  # limit number of kernel images, to keep /boot managable
    };

    efi.canTouchEfiVariables = true;
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    timeout = 1;
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable virtual cam.
  boot.kernelModules = [ "v4l2loopback" ];

  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  '';

  boot.plymouth = {
    enable = true;
    theme = "lone";
    themePackages = with pkgs; [adi1090x-plymouth-themes];
  };

  # Enable "Silent boot"
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "udev.log_priority=3"
    "rd.systemd.show_status=auto"
  ];

  boot.initrd.luks.devices."luks-a36bd82a-156c-4388-a5ec-39f82206b1a1".device = "/dev/disk/by-uuid/a36bd82a-156c-4388-a5ec-39f82206b1a1";
}
