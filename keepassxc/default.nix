{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "keepassxc";
  src = pkgs.fetchurl {
    url = "https://github.com/keepassxreboot/keepassxc/releases/download/2.7.8/KeePassXC-2.7.8-arm64.dmg";
    sha256 = "0ydzchm20vh4r9d8qyv6l5g4ajggc9l9fm898zaak470w2gmm6a5";
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
