{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "calibre";
  src = pkgs.fetchurl {
    url = "https://calibre-ebook.com/dist/osx";
    hash = "sha256-ugA+ekCx/fyIeb11DTDumC4iREkhgz2Wcs14P+TMSe4=";
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
