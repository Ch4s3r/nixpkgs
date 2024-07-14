{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "signal-desktop";
  src = pkgs.fetchurl {
    url = "https://updates.signal.org/desktop/signal-desktop-mac-universal-7.15.0.dmg";
    sha256 = "0pq2ql0m34l0zglvml8g1dmp2bszvnncmiz7q8kpr42kjm19sxz4";
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
