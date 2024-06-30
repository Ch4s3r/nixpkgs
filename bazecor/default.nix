{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "bazecor";
  src = pkgs.fetchurl {
    url = "https://github.com/Dygmalab/Bazecor/releases/download/v1.3.11/Bazecor-1.3.11-arm64.dmg";
    sha256 = "sha256-CKXN2AnLoilmMe8j2DMyBdlIqRiPyQ4ciOikBEYCgSQ=";
  };
  nativeBuildInputs = with pkgs; [ fd _7zz ];
  unpackPhase = ''
    7zz x $src || true
  '';
  installPhase = ''
    mkdir -p $out/Applications
    export APP_PATH=$(fd -t d ".app" -1)
    cp -a "$APP_PATH" $out/Applications
  '';
}
