{ pkgsrcs, wezterm, rustPlatform }:

rustPlatform.buildRustPackage rec {
  inherit (wezterm) nativeBuildInputs buildInputs buildFeatures postInstall preFixup;
  inherit (pkgsrcs.wezterm-nightly) pname version src;

  cargoLock = pkgsrcs.wezterm-nightly.cargoLock."Cargo.lock";

  postPatch = wezterm.postPatch + ''
    echo ${pkgsrcs.wezterm-nightly.date}-${version} > .tag
  '';
}
