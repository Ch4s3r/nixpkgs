{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "docker-desktop";
  src = pkgs.fetchurl {
    url = "https://desktop.docker.com/mac/main/arm64/Docker.dmg";
    hash = "sha256-u+pYDL2lkjPGIKJY5KJzaeBNUGhzWgh7jhNiLV5p/NU=";
  };
  nativeBuildInputs = with pkgs; [ fd (callPackage ../7zz { }) ];
  unpackPhase = ''
    7zz x $src  || true
  '';
  installPhase = ''
    mkdir -p $out/Applications
    export APP_PATH=$(fd -t d ".app" -1)
    cp -a  "$APP_PATH" $out/Applications
  '';
}
