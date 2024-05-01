{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "signal-desktop";
  src = pkgs.fetchurl {
    url = "https://updates.signal.org/desktop/signal-desktop-mac-universal-7.6.0.dmg";
    hash = "sha256-xA86jN5GbnUWGwHtd/D9OoQPkhufne0nU7n4LHoaVT4=";
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
