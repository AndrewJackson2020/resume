{ pkgs ? import <nixpkgs> { }
}:
let
  pythonPackages = with pkgs.python311Packages; [
  ];
in
{
  pgbouncer = pkgs.mkShell {
    nativeBuildInputs = [
      pkgs.pkg-config
      pkgs.cmake
      pkgs.gcc
    ];
    buildInputs = [
      pkgs.cirrus-cli
      pkgs.automake
      pkgs.autoconf
      pkgs.c-ares
      pkgs.curl
      pkgs.cacert
      pkgs.libevent
      pkgs.libtool
      pkgs.openssl
      pkgs.uncrustify
      pkgs.pam
      pkgs.which
      pkgs.git
      pkgs.postgresql
      pkgs.python311
      pkgs.systemd
      pkgs.valgrind
    ];
    shellHook = ''
      		cp ${pkgs.uncrustify}/bin/uncrustify ./uncrustify
      	    '';
  };
  postgres = pkgs.mkShell {
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
  };
  rust-postgres = pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = [
      pkgs.pkg-config
    ];
    buildInputs = [
      pkgs.openssl
      pkgs.postgresql
    ];
  };
  sqlalchemy = pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    packages = [
      pkgs.postgresql
      pkgs.git
      pkgs.python311
    ];
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };
}
