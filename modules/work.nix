{ config, lib, pkgs, pkgs-unstable, ... }:

{
  # create /etc/timezone with the same value.
  # Required by the tooling to setup our work repositories (devr).
  environment.etc."timezone".text = config.time.timeZone + "\n";

  environment.systemPackages = with pkgs; [
    pyright
    docker
    docker-buildx
    docker-compose
    openssh_gssapi
    devbox
    pam_u2f                     # Used for yubikey
    libfido2                    # Used for yubikey
    libsecret
    pkgs-unstable.crush
    pkgs-unstable.agent-browser
    jan
  ];

  nixpkgs.overlays = [
    (final: prev: {
      agent-browser =
        let
          version = "0.25.4";
          src = prev.fetchFromGitHub {
            owner = "vercel-labs";
            repo = "agent-browser";
            tag = "v${version}";
            hash = "sha256-2Dv+ZY9cvcz6EIpI+gkV9w5eqQzpAD2N+yf4dJrmdwg=";
          };
        in
          pkgs-unstable.agent-browser.overrideAttrs {
            inherit version src;
            cargoDeps = prev.rustPlatform.fetchCargoVendor {
              inherit src;
              sourceRoot = "source/cli";
              hash = "sha256-3vzVVHFo13ZLsbbXw7n9BE/YXBJwoxzhvfjuqOQwdfg=";
            };
          };
    })

    (final: prev: {
      jan = let
        pname = "Jan";
        version = "0.7.9";
        linux-src = prev.fetchurl {
          url = "https://github.com/janhq/jan/releases/download/v${version}/jan_${version}_amd64.AppImage";
          hash = "sha256-SMcjig6J/HCpLthT8dHC6yED6uuHyaTG/xLnUIlZHP8=";
        };
      in
        prev.appimageTools.wrapType2 {
          inherit version pname;

          meta = {
            changelog = "https://github.com/janhq/jan/releases/tag/v${version}";
            description = "Jan is an open source alternative to ChatGPT that runs 100% offline on your computer";
            homepage = "https://github.com/janhq/jan";
            license = lib.licenses.asl20;
            mainProgram = "Jan";
            maintainers = [ ];
            platforms = (with lib.systems.inspect; patternLogicalAnd patterns.isLinux patterns.isx86_64);
          };

          src = linux-src;

          extraInstallCommands =
            let
              appimageContents = prev.appimageTools.extractType2 {
                inherit pname version;
                src = linux-src;
              };
            in
              ''
              install -Dm444 ${appimageContents}/Jan.desktop -t $out/share/applications
              cp -r ${appimageContents}/usr/share/icons $out/share
              '';
        };
    })
  ];

  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  #
  # YubiKey config
  #

  # Enable udev rules for YubiKey
  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  # Enable U2F authentication
  security.pam.u2f = {
    enable = true;
    settings = {
      origin = "pam://yubi";    # Use same origin across machines
      interactive = true;       # Prompts to insert device
      cue = true;               # Shows "Please touch the device"
    };
  };

  ####################

  #
  # Docking station things
  #

  services.hardware.bolt.enable = true;
  services.fwupd.enable = true;
  boot.initrd.kernelModules = [ "i915" "thunderbolt" ];
  boot.blacklistedKernelModules = [ "xe" ];

  boot.kernelParams = [
    "i915.enable_dp_mst=1"
  ];

  ####################

  #
  # Flip cam
  #

  systemd.user.services.camera-flip = {
    description = "Stream flipped webcam to virtual device";
    serviceConfig = {
      Type = "simple";
      Environment = [
        "GST_PLUGIN_PATH=${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0"
      ];
      ExecStart = "${pkgs.gst_all_1.gstreamer}/bin/gst-launch-1.0 -v v4l2src device=/dev/video4 ! jpegdec ! videoconvert ! videoflip method=rotate-180 ! v4l2sink device=/dev/video10";
    };
  };

  ####################

  #
  # Ollama ftw
  #

  services.ollama = {
    enable = true;
    loadModels = [ "gemma4" "nemotron-3-nano:4b" "functiongemma" ];
    package = pkgs-unstable.ollama;
  };

  services.envfs.enable = true;

  # Necessary for openconnect, but maybe need to move to OS level.
  services.resolved.enable = true;
}
