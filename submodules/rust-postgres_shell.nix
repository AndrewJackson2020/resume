{
  pkgs ? import <nixpkgs> {}
}:
let
in pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = [
        pkgs.pkg-config
    ];
    buildInputs = [
        pkgs.openssl
        pkgs.postgresql
    ];
}
