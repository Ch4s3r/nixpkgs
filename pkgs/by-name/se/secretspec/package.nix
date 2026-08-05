{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  sops,
  jq,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "secretspec";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "secretspec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ckaHzN8nAVnhBgdWLCbCnWcoovoUWOcnJv0eSQSpcWU=";
  };

  cargoHash = "sha256-g7tv7Fjzzkl+Q1FdS/d+E7aQMDI2uehqheRS38AtFEk=";

  buildAndTestSubdir = "secretspec";

  nativeBuildInputs = [ pkg-config ];
  nativeCheckInputs = [
    sops
    jq
  ];
  buildInputs = [ dbus ];

  preCheck = ''
    export HOME="$TMPDIR"
  '';

  # A test binds to localhost, which requires an explicit Darwin sandbox exception.
  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Declarative secrets, every environment, any provider";
    homepage = "https://secretspec.dev";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      domenkozar
      sandydoo
    ];
    mainProgram = "secretspec";
  };
})
