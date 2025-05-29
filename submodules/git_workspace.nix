{ pkgs ? import <nixpkgs> {} }:

pkgs.python3Packages.buildPythonApplication {
  pname = "git-workspace";
  version = "0.1.0";
  propagatedBuildInputs = with pkgs.python3Packages; [
    click
  ];
  src = ./.;
}
