{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "outlook";
  src = pkgs.fetchurl {
    url = "https://go.microsoft.com/fwlink/p/?linkid=525137";
    sha256 = "1gj8x36453j1hlcgrrsx8wrvwdagsw8b9i9h42j74kcs0w49jhiw";
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
