{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "signal-desktop";
  src = pkgs.fetchurl {
    url = "https://updates.signal.org/desktop/signal-desktop-mac-universal-7.7.0.dmg";
    sha256 = "1pwxj5lrvdawwf3s5rv9gmg37vdba4bhxjxdfg9b3vv5ia4gp6fd";
  };
  nativeBuildInputs = with pkgs; [ fd (callPackage ../7zz { }) ];
  unpackPhase = ''
    7zz x $src || true
  '';
  installPhase = ''
    mkdir -p $out/Applications
    export APP_PATH=$(fd -t d ".app" -1)
    cp -a  "$APP_PATH" $out/Applications
  '';
}
