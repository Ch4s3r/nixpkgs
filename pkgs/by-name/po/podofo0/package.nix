{
  lib,
  stdenv,
  podofo,
  libidn,
}:
podofo.overrideAttrs (prevAttrs: {
  version = "0.10.6";
  src = prevAttrs.src.override {
    hash = "sha256-DlCKQYlsgTfnZACk6yTeoIiaOL5AtICcHjRd8jl0RkI=";
  };
  buildInputs = prevAttrs.buildInputs ++ [ libidn ];
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    MACOSX_DEPLOYMENT_TARGET = "26.0";
  };
})
