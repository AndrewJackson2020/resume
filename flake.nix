{
  description = "Attempted nix monorepo";

  inputs = {
    nixpkgs = {
    	url = "github:NixOS/nixpkgs/nixos-24.11";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, ...}:
  let pkgs = nixpkgs.legacyPackages.x86_64-linux; in

  {
    nixosConfigurations = {
      nixos-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nix-os-config/hardware_configuration/desktop.nix
          ./nix-os-config/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.andrew = import ./nix-os-config/home.nix;
          }
        ];
      };
      nixos-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nix-os-config/hardware_configuration/laptop.nix
          ./nix-os-config/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.andrew = import ./nix-os-config/home.nix;
          }
        ];
      };
      nixos-hyperv-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nix-os-config/hardware_configuration/hyperv_vm.nix
          ./nix-os-config/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.andrew = import ./nix-os-config/home.nix;
          }
        ];
      };
      qvm_vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nix-os-config/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.andrew = import ./nix-os-config/home.nix;
          }
        ];
      };
    };
    homeConfigurations.andrew = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        (import ./nix-os-config/home.nix)
      ];
    };
    apps.x86_64-linux = {
      resume = let

        typst = import ./typst.nix { };
        compile_resume = pkgs.writeShellApplication {
          name = "compile_resume";
          runtimeInputs = [ typst ];
          text = ''
            # Serve the current directory on port 8090
            ${typst}/typst compile ./resume/resume.typ
          '';
        };
      in {
        type = "app";
        program = "${compile_resume}/bin/compile_resume";
      };
    };
    packages.x86_64-linux = {
      default = pkgs.callPackage (import ./typst.nix) {}; 
      typst = pkgs.callPackage (import ./typst.nix) {}; 
    };
  };
}
