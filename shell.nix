{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  buildInputs = [
    git
    gnumake
    just
    nixpkgs-fmt
  ];

  shellHook = ''
    echo "For help, run \`make help\`"
  '';
}
