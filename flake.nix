{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    outlook_src = { url = "https://go.microsoft.com/fwlink/p/?linkid=525137"; flake = false; };
  };
  outputs = { self, nixpkgs, outlook_src }:
    let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in
    {
      packages.aarch64-darwin = rec {
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
        outlookWrapper = pkgs.writeShellScriptBin "outlookWrapper" ''
          open ${outlook}/Applications/Microsoft\ Outlook.app
        '';
        default = outlookWrapper;
      };
    };
}