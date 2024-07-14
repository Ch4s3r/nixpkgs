{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "calibre";
  src = pkgs.fetchurl {
    url = "https://calibre-ebook.com/dist/osx";
    sha256 = "sha256-ogosGCg1Ot/fyoXazSzBoxCApFjUwIpBGhVgcCcFpXw=";
  };
  nativeBuildInputs = with pkgs; [ fd _7zz ];
  unpackPhase = ''
    7zz x $src || true
  '';
  installPhase = ''
    mkdir -p $out/Applications
    export APP_PATH=$(fd -t d ".app" -1)
    cp -a  "$APP_PATH" $out/Applications
  '';
}
