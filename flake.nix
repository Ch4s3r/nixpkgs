{
  description = "Flake utils demo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        flutter_rust_bridge_codegen_src = pkgs.fetchurl {
          url = "https://github.com/fzyzcjy/flutter_rust_bridge/releases/download/v2.0.0-dev.19/flutter_rust_bridge_codegen-aarch64-apple-darwin-v2.0.0-dev.19.tgz";
          sha256 = "sha256-hrx1/E7/UkCvYT/1ReoGOzUHTbsfFXUR/BVGRz6OMIU=";
        };
      in
      {
        packages = rec {
          flutter_rust_bridge_codegen = pkgs.stdenv.mkDerivation {
            name = "flutter_rust_bridge_codegen-aarch64-apple-darwin";
            src = flutter_rust_bridge_codegen_src;
            phases = [ "unpackPhase" "installPhase" ];
            unpackPhase = ''
              mkdir unpacked
              tar xzf $src -C unpacked
            '';
            installPhase = ''
              mkdir -p $out/bin
              cp -r unpacked/* $out/bin
            '';
          };
          default = flutter_rust_bridge_codegen;
        };
        apps = rec {
          flutter_rust_bridge_codegen = flake-utils.lib.mkApp { drv = self.packages.${system}.flutter_rust_bridge_codegen; };
          default = flutter_rust_bridge_codegen;
        };
      }
    );
}
