{
  description = "not slop coded tool for slop creation";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
  };

  outputs = {nixpkgs, ...}: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ] (
        system:
          function rec {
            inherit system;
            pkgs = import nixpkgs {
              inherit system;
            };
            nativeBuildInputs = [
              pkgs.nodejs_24
              pkgs.rustc
              pkgs.cargo
            ];
          }
      );
  in {
    devShells = forAllSystems ({
      pkgs,
      nativeBuildInputs,
      ...
    }: {
      default = pkgs.mkShell {
        packages = nativeBuildInputs;
      };
    });

    formatter = forAllSystems ({pkgs, ...}: pkgs.alejandra);
  };
}
