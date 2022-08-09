{ mkDerivation, aeson, attoparsec, base, containers, http-types
, jwt, lib, microlens-platform, scotty, text, tomland, wai-extra
}:
mkDerivation {
  pname = "jfs";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson attoparsec base containers http-types jwt microlens-platform
    scotty text tomland wai-extra
  ];
  license = "unknown";
  mainProgram = "jfs";
}
