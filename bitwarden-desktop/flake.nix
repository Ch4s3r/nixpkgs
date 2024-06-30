{
  description = "Bitwarden Desktop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    bitwarden-src = {
      url = "https://github.com/bitwarden/clients/releases/download/desktop-v2024.5.0/Bitwarden-2024.5.0-universal.dmg";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, bitwarden-src }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      defaultPackage.${system} = pkgs.stdenv.mkDerivation {
        name = "bitwarden-desktop";
        src = bitwarden-src;
        nativeBuildInputs = with pkgs; [ fd _7zz ];
        unpackPhase = ''
          7zz x $src || true
        '';
        installPhase = ''
          mkdir -p $out/Applications
          export APP_PATH=$(fd -t d ".app" -1)
          cp -a  "$APP_PATH" $out/Applications
        '';
      };
    };
}
