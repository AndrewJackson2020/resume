{
  pkgs ? import <nixpkgs> {}
}:
let
    x = 1;
in pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    packages = [
    	pkgs.postgresql
        pkgs.git
        pkgs.python311
    ];
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
}
