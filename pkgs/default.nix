{ pkgs }:

let
  callPackage = pkgs.newScope (pkgs // self);
  self = rec {
    pkgsrcs = pkgs.callPackage ./_sources/generated.nix { };
    age-plugin-yubikey = callPackage ./age-plugin-yubikey { };
    awesome-extensions = callPackage ./awesome-extensions { };
    hexdiff = callPackage ./hexdiff { };
    xcursor-pixelfun = callPackage ./xcursor-pixelfun { };
    linuxPackages_acs_override = callPackage ./linux_acs_override { };
  };
in
self
