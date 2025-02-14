{ pkgs ? import <nixpkgs> {} }:
let
  typst = import ./typst.nix { };
in 
  pkgs.stdenv.mkDerivation {
    name = "resume";
    src = builtins.path {
        path = ./.;
    };
    buildPhase = "${typst}/typst compile ./resume.typ";
    installPhase = "mkdir -p $out/bin; install -t $out/bin resume.pdf";
  }

