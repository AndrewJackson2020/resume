{
  description = "Attempted nix monorepo";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let pkgs = nixpkgs.legacyPackages.x86_64-linux; in

    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      nixosConfigurations = {
        nixos-desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nix-os-config/hardware_configuration/desktop.nix
            ./nix-os-config/configuration.nix
            home-manager.nixosModules.home-manager
            {
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
            home-manager.nixosModules.home-manager
            {
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
            home-manager.nixosModules.home-manager
            {
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
            home-manager.nixosModules.home-manager
            {
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
	git_workspace = 
	let 
	  git_workspace_app = import ./git_workspace_app/git_workspace.nix { };
          git_workspace = pkgs.writeShellApplication {
            name = "git_workspace";
            runtimeInputs = [ 
	      pkgs.python3
              pkgs.python3Packages.click
	    ];
            text = ''
	    ${git_workspace_app}/bin/git_workspace.py "$@"
            '';
	  };
        in
        {
          type = "app";
          program = "${git_workspace}/bin/git_workspace";
        };
        resume =
          let
            typst = import ./typst.nix { };
            typst_wrapper = pkgs.writeShellApplication {
              name = "typst_wrapper";
              runtimeInputs = [ typst ];
              text = ''
	      ${typst}/typst "$@"
              '';
            };
          in
          {
            type = "app";
            program = "${typst_wrapper}/bin/typst_wrapper";
          };
      };
      packages.x86_64-linux = {
        default = pkgs.callPackage (import ./typst.nix) { };
        typst = pkgs.callPackage (import ./typst.nix) { };
      };
    };
}
