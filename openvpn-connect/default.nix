{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "openvpn-connect";
  src = pkgs.fetchurl {
    url = "https://swupdate.openvpn.net/downloads/connect/openvpn-connect-3.4.2.4547_signed.dmg";
    hash = "sha256-0Tlo6wxy8tgWvoieKhPborGIl+BSyfNwxStUGz6laOg=";
    curlOpts = "-A Mozilla/5.0";
  };
  nativeBuildInputs = with pkgs; [ fd (callPackage ../7zz { }) ];
  unpackPhase = ''
    7zz x $src
    cd OpenVPN\ Connect
    7zz x "*_arm64_Installer_signed.pkg"
    cat tmp-app.pkg/Payload | gunzip -dc | ${pkgs.cpio}/bin/cpio -i
  '';
  installPhase = ''
    mkdir -p $out/Applications/OpenVPN\ Connect.app
    cp -a  Contents $out/Applications/OpenVPN\ Connect.app
  '';
}
