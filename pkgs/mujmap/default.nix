{
  rustPlatform,
  pkgsrcs,
  notmuch,
}:

rustPlatform.buildRustPackage {
  inherit (pkgsrcs.mujmap) pname version src;
  cargoLock = pkgsrcs.mujmap.cargoLock."Cargo.lock";

  buildInputs = [
    notmuch
  ];
}
