{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    git
    gitAndTools.git-crypt
    gnumake
    nixpkgs-fmt
  ];

  shellHook = ''
    echo "For help, run \`make help\`"
  '';
}
