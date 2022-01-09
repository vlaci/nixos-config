{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  buildInputs = [
    git
    gnumake
    just
    nixpkgs-fmt
    git-agecrypt
    age-plugin-yubikey
  ];

  shellHook = ''
    echo "For help, run \`make help\`"
  '';
}
