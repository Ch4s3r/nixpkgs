{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "7zz";
  src = pkgs.fetchurl {
    url = "https://www.7-zip.org/a/7z2403-mac.tar.xz";
    sha256 = "0hpyyfcm5hz7l36cbw3j8l0sxypdlawdvbqy654rz3vlza38x17d";
  };
  sourceRoot = ".";
  installPhase = ''
    mkdir -p $out/bin
    cp -a 7zz $out/bin
  '';
}
