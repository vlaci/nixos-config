{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    gitAndTools.git-crypt
    gnumake
    nixpkgs-fmt
  ];

  shellHook = ''
    git config --local include.path .gitconfig
  '';
}
