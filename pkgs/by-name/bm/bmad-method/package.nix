{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "bmad-method";
  version = "6.8.0";

  src = fetchFromGitHub {
    owner = "bmad-code-org";
    repo = "bmad-method";
    tag = "v${version}";
    hash = "sha256-lEMUaIFHuFvcqTEMIH95pB4Bmnuq6N5J8LCHHiRnv1A=";
  };

  npmDepsHash = "sha256-VM2ICB1LxHh2l5iIeKzMOyWm1qoAKMPfxCUMGTBtX/g=";

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Breakthrough Method for Agile AI Driven Development";
    homepage = "https://github.com/bmad-code-org/bmad-method";
    license = lib.licenses.mit;
    mainProgram = "bmad";
    maintainers = with lib.maintainers; [ ];
  };
}
