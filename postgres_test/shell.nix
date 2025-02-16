{
  pkgs ? import <nixpkgs> {}
}:
let
    pythonPackages = with pkgs.python311Packages; [
        pytest
        pytest-asyncio
        pytest-timeout
        pytest-xdist
        psycopg
        psycopg2
	asyncpg
        filelock
	contextlib2
  	black
  	flake8
  	flake8-bugbear
  	isort
    ];
in pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = [
    ];
    buildInputs = [
        pythonPackages
    ];
}
