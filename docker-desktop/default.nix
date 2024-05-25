{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "docker-desktop";
  src = pkgs.fetchurl {
    url = "https://desktop.docker.com/mac/main/arm64/Docker.dmg";
    sha256 = "sha256-VY3+7nZGf6/ETv8cLBXmNUPRGjYyObPeAl6/ZE3V89Y=";
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
