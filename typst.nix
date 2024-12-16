{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "typst";
  src = pkgs.fetchzip {
    url = "https://github.com/typst/typst/releases/download/v0.12.
  0/  typst-x86_64-unknown-linux-musl.tar.xz";
    hash = "sha256-ta69kqJM9kyRWJxykXOM5/fP1MTRO0V+ZnFdG0nKCiI=";
  };
  sourceRoot = ".";
  installPhase = "install -m755 -D $src/typst $out/typst";
}
