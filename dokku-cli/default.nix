{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "dokku";
  src = pkgs.fetchFromGitHub {
    owner = "dokku";
    repo = "dokku";
    rev = "v0.34.4";
    sha256 = "ukeL1lxY/0nHNKPvexyePnI37+0/h5Ln/snEeraO8A4=";
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