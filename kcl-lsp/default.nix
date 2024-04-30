{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "kcl-lsp";
  src = pkgs.fetchurl {
    url = "https://github.com/kcl-lang/kcl/releases/download/v0.8.5/kclvm-v0.8.5-darwin-arm64.tar.gz";
    hash = "sha256-Ljt3/oTbBTQrD3+XOzyHgw06vnDyZi8b3LMgbogay+g=";
  };
  nativeBuildInputs = with pkgs; [ fd (callPackage ../7zz { }) ];
  unpackPhase = ''
    7zz x $src -so | 7zz x -si -ttar
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp -a kclvm/bin/* $out/bin
  '';
}
