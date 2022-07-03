let
  flakePkgs = builtins.getFlake (toString ./.);
in
{ pkgs ? flakePkgs.legacyPackages.${builtins.currentSystem} }:

with pkgs;

mkShell {
  buildInputs = [
    git
    gnumake
    just
    nixpkgs-fmt
    nvfetcher
    git-agecrypt
    age-plugin-yubikey
  ];

  shellHook = ''
    echo "For help, run \`make help\`"
  '';
}
