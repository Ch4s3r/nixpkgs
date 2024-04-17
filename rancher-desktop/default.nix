{ pkgs ? import <nixpkgs> {} }:
let
  version = "1.13.1";
in
pkgs.stdenv.mkDerivation {
  name = "rancher-desktop";
  src = pkgs.fetchurl {
    url = "https://github.com/rancher-sandbox/rancher-desktop/releases/download/v${version}/Rancher.Desktop-${version}.aarch64.dmg";
    hash = "sha256-czTiJGyODQFXM2l/m8mrrhiXMpZnFZX2ueA5hw0yc4g=";
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
