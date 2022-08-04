{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc902", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, jwt, lib, scotty, tomland, microlens-platform
      , text, http-types, wai-extra, attoparsec, aeson
      , containers
      , haskell-language-server
   }:
      mkDerivation {
        pname = "jfs";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        executableHaskellDepends = [ base jwt scotty tomland microlens-platform 
            text http-types wai-extra attoparsec aeson 
            containers
            haskell-language-server
         ];
        license = "unknown";
        mainProgram = "jfs";
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
