{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "dokku";
  src = pkgs.fetchFromGitHub {
    owner = "dokku";
    repo = "dokku";
    rev = "v0.34.4";
    sha256 = "0hpyyfcm5hz7l36cbw3j8l0sxypdlawdvbqy654rz3vlza38x17d";
  };
  installPhase = ''
    mkdir -p $out/bin
    cp -a contrib/dokku_client.sh $out/
    cat > $out/bin/dokku <<EOF
    #!/bin/bash
    exec $out/dokku_client.sh "\$@"
    EOF
    chmod +x $out/bin/dokku
  '';
}