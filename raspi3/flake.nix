{
  description = "Build raspi image";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

  inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  outputs = { self, nixpkgs, disko, nixos-hardware }: rec {
    nixosConfigurations.rpi3 = nixpkgs.lib.nixosSystem {
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

        nixos-hardware.nixosModules.raspberry-pi-3

        {
          nixpkgs.config.allowUnsupportedSystem = true;
          nixpkgs.hostPlatform.system = "aarch64-linux";
          nixpkgs.buildPlatform.system = "x86_64-linux";
        }

        disko.nixosModules.disko

        ./configuration.nix
      ];
    };

    images.rpi3 = nixosConfigurations.rpi3.config.system.build.sdImage;
  };
}
