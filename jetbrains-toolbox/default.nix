{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "jetbrains-toolbox";
  src = pkgs.fetchurl {
    url = "https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.3.2.31487-arm64.dmg";
    sha256 = "sha256-Ueob5ltnHxrpkCQjCk/rnDJF0JEN0n0qPp1fWdCpnH8=";
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
