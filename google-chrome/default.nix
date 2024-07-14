{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "google-chrome";
  src = pkgs.fetchurl {
    url = "https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg";
    sha256 = "sha256-0ur5wFDJF6hE9WwoGX7rhMuRfyIX1k3w54sXrg1ezIg=";
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
