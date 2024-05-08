{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "google-chrome";
  src = pkgs.fetchurl {
    url = "https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg";
    sha256 = "1ayiz9k9h4x7vlpi97hcixkyflyviblrqymijq1rvpc5fnx6gzns";
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
