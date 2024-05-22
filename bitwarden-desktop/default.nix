{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "bitwarde-desktop";
  src = pkgs.fetchurl {
    url = "https://github.com/bitwarden/clients/releases/download/desktop-v2024.5.0/Bitwarden-2024.5.0-universal.dmg";
    sha256 = "sha256-XLrg13a/cpSAslKzJjDaS9NsPUSy1XCQ3ZWNpR9ehp0=";
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
