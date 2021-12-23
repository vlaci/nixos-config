final: prev: {
  nix-plugins = (prev.nix-plugins.override { nix = final.nixUnstable; }).overrideAttrs (prev: {
    inherit (final.pkgsrcs.nix-plugins) version src;
  });
}
