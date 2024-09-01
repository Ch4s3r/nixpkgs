{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "calibre";
  src = pkgs.fetchurl {
    url = "https://calibre-ebook.com/dist/osx";
    sha256 = "sha256-y/rUjRCEenWP24sw8YcI+2R9FHM7I2yX10hIV3qnDwU=";
  };
  nativeBuildInputs = with pkgs; [ fd _7zz ];
  unpackPhase = ''
    7zz x $src || true
  '';
  installPhase = ''
    mkdir -p $out/Applications
    export APP_PATH=$(fd -t d ".app" -1)
    cp -a "$APP_PATH" $out/Applications
    cd $out/Applications/calibre.app/Contents/ebook-viewer.app/Contents/ebook-edit.app/Contents/headless.app/Contents/MacOS/
    mv calibre-parallel-placeholder-for-codesigning calibre-parallel || true
  '';
}
