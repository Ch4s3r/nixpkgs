{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "rancher-desktop";
  src = pkgs.fetchurl {
    url = "https://github.com/rancher-sandbox/rancher-desktop/releases/download/v1.13.1/Rancher.Desktop-1.13.1.aarch64.dmg";
    sha256 = "123k686qffg0p7v9a5b7jqr9f65fmg4rnzv96dbh23cfdhjf4d3k";
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
