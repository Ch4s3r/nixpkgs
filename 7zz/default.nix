{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "7zz";
  src = pkgs.fetchurl {
    url = "https://www.7-zip.org/a/7z2403-mac.tar.xz";
    hash = "sha256-7YSOhvp0j59JMR6v3bii7fquAUVy8MXMoOfDUpnz/kI=";
  };
  sourceRoot = ".";
  installPhase = ''
    mkdir -p $out/bin
    cp -a 7zz $out/bin
  '';
}
