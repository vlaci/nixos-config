{ swaylock, pkgsrcs }:

swaylock.overrideAttrs (_: {
  inherit (pkgsrcs.swaylock) pname version src;

  patches = [
    ./0001-Implement-dpms-power-control.patch
    ./0002-schedule-power-off-on-start.patch
  ];
})
