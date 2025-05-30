{
  pkgs ? import <nixpkgs> {}
}:
let
in pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = [
        pkgs.pkg-config
        pkgs.perl
    ];
    buildInputs = [
        pkgs.automake
	pkgs.perl540Packages.IPCRun
        pkgs.c-ares
        pkgs.curl
        pkgs.cacert
        pkgs.libevent
        pkgs.libtool
        pkgs.openssl
        pkgs.pam
        pkgs.openldap
        pkgs.systemd
        pkgs.valgrind
	pkgs.icu
	pkgs.bison
	pkgs.flex
	pkgs.readline
    ];
}
