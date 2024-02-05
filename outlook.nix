{ pkgs, outlook_src }:

rec {
  outlook = pkgs.stdenv.mkDerivation {
    name = "outlook.app";
    src = outlook_src;
    phases = [ "unpackPhase" "installPhase" ];
    unpackPhase = ''
      ${pkgs.xar}/bin/xar -xf $src
      cat Microsoft_Outlook.pkg/Payload | gunzip -dc | ${pkgs.cpio}/bin/cpio -i
    '';
    installPhase = ''
      mkdir -p $out/Applications
      cp -r Microsoft\ Outlook.app $out/Applications/Microsoft\ Outlook.app
    '';
  };
  outlookWrapper = {
    type = "app";
    program = "${pkgs.writeShellScriptBin "outlookWrapper" ''
      open ${outlook}/Applications/Microsoft\ Outlook.app
    ''}/bin/outlookWrapper";
  };
}