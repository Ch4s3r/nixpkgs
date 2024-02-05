{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    outlook_src = { url = "https://go.microsoft.com/fwlink/p/?linkid=525137"; flake = false; };
  };
  outputs = { self, nixpkgs, outlook_src }:
    let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      outlook = import ./outlook.nix { inherit pkgs outlook_src; };
    in
    {
      packages.aarch64-darwin.outlook = outlook.outlook;
      apps.aarch64-darwin.outlookWrapper = outlook.outlookWrapper;
    };
}