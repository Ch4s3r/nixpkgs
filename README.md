# Custom nixpkgs

Collection of helpful custom nixpkgs which are not available in the official repository.  
`flake.lock` is updated automatically on a daily basis.

## Run an application
```shell
nix run github:Ch4s3r/custom-nixpkgs#outlookWrapper
```

## Ignore flake.lock in case it's outdated
```shell
nix run github:Ch4s3r/custom-nixpkgs#outlookWrapper --recreate-lock-file --no-write-lock-file
```