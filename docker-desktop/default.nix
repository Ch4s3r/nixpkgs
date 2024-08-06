{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "docker-desktop";
  src = pkgs.fetchurl {
    url = "https://desktop.docker.com/mac/main/arm64/Docker.dmg";
    sha256 = "1q7zk5nnca3h4dvclr8hhc76nzkks4ic4bwg0nwvchs9g0c9qjbl";
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
