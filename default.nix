{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc902" }:
nixpkgs.pkgs.haskell.packages.${compiler}.callPackage ./release.nix { }
