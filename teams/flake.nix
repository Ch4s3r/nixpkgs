{
  description = "Microsoft Teams";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    teams-src = {
      url = "https://statics.teams.cdn.office.net/production-osx/enterprise/webview2/lkg/MicrosoftTeams.pkg";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, teams-src }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      defaultPackage.${system} = pkgs.stdenv.mkDerivation {
        name = "teams";
        src = teams-src;
        nativeBuildInputs = with pkgs; [ fd _7zz ];
        unpackPhase = ''
          /usr/sbin/pkgutil --expand-full $src teams/
        '';
        installPhase = ''
          mkdir -p $out/Applications
          fd -t d ".app$" -x cp -a {} $out/Applications/
        '';
      };
    };
}
