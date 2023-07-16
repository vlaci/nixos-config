{ swaylock, pkgsrcs }:

swaylock.overrideAttrs (_: {
  inherit (pkgsrcs.swaylock-dpms) pname version src;
})
