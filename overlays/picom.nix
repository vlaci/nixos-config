final: prev: {
  picom = prev.picom.overrideAttrs (prev: {
    inherit (final.pkgsrcs.picom) version;
    src = final.pkgsrcs.picom;
  });
}
