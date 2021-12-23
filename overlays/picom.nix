final: prev: {
  picom = prev.picom.overrideAttrs (prev: {
    inherit (final.pkgsrcs.picom) src version;
  });
}
