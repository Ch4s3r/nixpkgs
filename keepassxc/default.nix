{ pkgs ? import <nixpkgs> {} }:
let
  version = "2.7.7";
in
pkgs.stdenv.mkDerivation {
  name = "keepassxc";
  src = pkgs.fetchurl {
    url = "https://github.com/keepassxreboot/keepassxc/releases/download/${version}/KeePassXC-${version}-arm64.dmg";
    hash = "sha256-hoFUBifQP3D2g9xazXmvj0K7ohQl/681LHnrXDH7lxI=";
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
