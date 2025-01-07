{
  description = "Rancher Desktop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rancher-desktop-src = {
      url = "https://objects.githubusercontent.com/github-production-release-asset-2e65be/306701996/650052ab-03de-4298-9ea2-e309781a66c1?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20250107%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250107T091956Z&X-Amz-Expires=300&X-Amz-Signature=ef302db8da61b99da1592e058b11827a2bd44bc91ede940f4b9fac0e66d7a37c&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3DRancher.Desktop-1.17.0.aarch64.dmg&response-content-type=application%2Foctet-stream";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, rancher-desktop-src }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      defaultPackage.${system} = pkgs.stdenv.mkDerivation {
        name = "rancher-desktop";
        src = rancher-desktop-src;
        nativeBuildInputs = with pkgs; [ fd _7zz ];
        unpackPhase = ''
          7zz x $src || true
        '';
        installPhase = ''
          mkdir -p $out/Applications
          export APP_PATH=$(fd -t d ".app" -1)
          cp -a "$APP_PATH" $out/Applications
        '';
      };
    };
}
