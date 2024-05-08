{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "outlook";
  src = pkgs.fetchurl {
    url = "https://go.microsoft.com/fwlink/p/?linkid=525137";
    sha256 = "1hfxvsdslbicwwq56xvv42x4b850v44wg82mk16hqk9iynz4sh9s";
  };
  nativeBuildInputs = with pkgs; [ fd (callPackage ../7zz { }) ];
  unpackPhase = ''
      7zz x $src
      cat Microsoft_Outlook.pkg/Payload | gunzip -dc | ${pkgs.cpio}/bin/cpio -i
  '';
  installPhase = ''
    mkdir -p $out/Applications
    export APP_PATH=$(fd -t d ".app" -1)
    cp -a  "$APP_PATH" $out/Applications
  '';
}
