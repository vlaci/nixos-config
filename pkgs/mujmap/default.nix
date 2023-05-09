{ rustPlatform, pkgsrcs, notmuch }:

rustPlatform.buildRustPackage {
  inherit (pkgsrcs.mujmap) pname version src;
  cargoHash = "sha256-xO73kP0ACPfMZnDEj9Np+wwtxFyfOYDX4To2wBReKZo=";

  buildInputs = [
    notmuch
  ];
}
