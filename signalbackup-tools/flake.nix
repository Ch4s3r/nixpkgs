{
  description = "A Nix flake for installing signalbackup-tools using BUILDSCRIPT.bash";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib;
    in
    {
      packages.default = pkgs.stdenv.mkDerivation {
        pname = "signalbackup-tools";
        version = "latest";

        src = pkgs.fetchFromGitHub {
          owner = "bepaald";
          repo = "signalbackup-tools";
          rev = "master";
          sha256 = "sha256-FiDvH9hgqarV2ncZSKQZg0O3GiwyG5E5VlcXXYFWMCo=";
        };

        nativeBuildInputs = [
          pkgs.bash
          pkgs.cmake
          pkgs.pkg-config
        ];

        buildInputs = [
          pkgs.clang
          pkgs.openssl
          pkgs.sqlite
        ] ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.dbus ];

        buildPhase = ''
          cmake -B build -DCMAKE_BUILD_TYPE=Release
          cmake --build build -j $(nproc)
        '';

        installPhase = ''
          mkdir -p $out/bin
          cp -r * $out/bin
        '';

        meta = with pkgs.lib; {
          description = "A tool to decrypt Signal backups";
          license = licenses.mit;
          maintainers = [ maintainers.your-name-here ];
        };
      };
    }
  );
}
