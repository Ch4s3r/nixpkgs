{
  description = "cranelift";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    cranelift-src = {
      url = "github:rust-lang/rustc_codegen_cranelift";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, cranelift-src }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      defaultPackage.${system} = pkgs.stdenv.mkDerivation {
        name = "cranelift";
        src = cranelift-src;
        nativeBuildInputs = with pkgs; [ cargo ];
        installPhase = ''
          ./y.sh prepare
          ./y.sh build
        '';
      };
    };
}
