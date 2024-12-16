{
  description = "A flake for building Hello World";

  outputs = { self, nixpkgs }:
    let pkgs = nixpkgs.legacyPackages.x86_64-linux; in

    {
     packages.x86_64-linux.default =  pkgs.callPackage (import ./typst.nix) {}; 
     packages.x86_64-linux.typst=  pkgs.callPackage (import ./typst.nix) {}; 
   };
    }
