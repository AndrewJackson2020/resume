{
  description = "A flake for building Hello World";

  outputs = { self, nixpkgs }:
  let pkgs = nixpkgs.legacyPackages.x86_64-linux; in

  {
    apps.x86_64-linux = {
      default = let

        typst = import ./typst.nix { };
        compile_resume = pkgs.writeShellApplication {
          # Our shell script name is serve
          # so it is available at $out/bin/serve
          name = "compile_resume";
          # Caddy is a web server with a convenient CLI interface
          runtimeInputs = [ typst ];
          text = ''
            # Serve the current directory on port 8090
            ${typst}/typst compile ./resume.typ
          '';
        };
      in {
        type = "app";
        # Using a derivation in here gets replaced
        # with the path to the built output
        program = "${compile_resume}/bin/compile_resume";
      };
    };
    packages.x86_64-linux = {
      default = pkgs.callPackage (import ./typst.nix) {}; 
      typst = pkgs.callPackage (import ./typst.nix) {}; 
    };
  };
}
