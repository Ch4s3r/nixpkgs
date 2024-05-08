#!/bin/bash
for dir in */ ; do
    cd "$dir"
    if [ -f default.nix ]; then
        url=$(rg -o -P '(?<=url = ").*(?=";)' default.nix)
        if [ -n "$url" ]; then
            hash=$(nix-prefetch-url "$url")
            sd "sha256 = \".*\";" "sha256 = \"${hash}\";" default.nix
        fi
    fi
    cd ..
done