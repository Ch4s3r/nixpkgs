{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "calibre";
  src = pkgs.fetchurl {
    url = "https://calibre-ebook.com/dist/osx";
    sha256 = "1d0m888rw39fxia6gg0z8m1havbj5qrdcvnwdzslxnaqgib4ndvn";
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
