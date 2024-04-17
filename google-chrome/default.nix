{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "google-chrome";
  src = pkgs.fetchurl {
    url = "https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg";
    hash = "sha256-9aT7QuKld77C0RZqyGeFFaM0oJA8x3Kq7hm9ryOSMP0=";
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
