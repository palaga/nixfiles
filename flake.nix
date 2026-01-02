{
  description = "Oblivious Infrastructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    stylix.url = "github:nix-community/stylix/release-25.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, disko, nixpkgs, nixos-hardware, stylix, home-manager, ... }: {
    nixosConfigurations = {
      mandrill = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit inputs; };

        modules = [
          stylix.nixosModules.stylix
          ./modules/hosts/mandrill
          home-manager.nixosModules.home-manager
          nixos-hardware.nixosModules.lenovo-thinkpad-t490
        ];
      };

      gibbon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit inputs; };

        modules = [
          disko.nixosModules.disko
          stylix.nixosModules.stylix
          ./modules/hosts/gibbon
          # TODO: facter seems to fail for me, on some graphics kernel modules.
          # { hardware.facter.reportPath = ./modules/hosts/gibbon/facter.json; }
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
