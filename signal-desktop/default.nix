{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "signal-desktop";
  src = pkgs.fetchurl {
    url = "https://updates.signal.org/desktop/signal-desktop-mac-universal-7.12.0.dmg";
    sha256 = "sha256-Ye3Kryk0PC1X0HXPOcNLkIfL9zDePmZYNddio/qGE/o=";
  };
  nativeBuildInputs = with pkgs; [ fd (callPackage ../7zz { }) ];
  unpackPhase = ''
    7zz x $src || true
  '';
  installPhase = ''
    mkdir -p $out/Applications
    export APP_PATH=$(fd -t d ".app" -1)
    cp -a  "$APP_PATH" $out/Applications
  '';
}
