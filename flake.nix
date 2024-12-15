
{ lib, config, pkgs, ... }:

let
  typst_src = pkgs.fetchzip {
    url = "https://github.com/typst/typst/releases/download/v0.12.
0/typst-x86_64-unknown-linux-musl.tar.xz";
    hash = "sha256-ta69kqJM9kyRWJxykXOM5/fP1MTRO0V+ZnFdG0nKCiI=";
  };
in
{
  description = "A flake for building Hello World";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-20.03;

  outputs = { self, nixpkgs }: {

    defaultPackage.x86_64-linux =
      # Notice the reference to nixpkgs here.
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        name = "hello";
        src = self;
        buildPhase = "${typst_src}/typst compile ./resume.typ";
        installPhase = "mkdir -p $out/bin; install -t $out/bin resume.pdf";
      };

  };
}
