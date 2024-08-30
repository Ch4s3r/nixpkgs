{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "docker-desktop";
  src = pkgs.fetchurl {
    url = "https://desktop.docker.com/mac/main/arm64/153195/Docker.dmg";
    sha256 = "sha256-GuYg6Srhz4e2YHuGsRp5Khp6Tr/doWY8ubzo8nX0CxA=";
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
