{ pkgs }:

let
  callPackage = pkgs.newScope (pkgs // self);
  self = rec {
    pkgsrcs = pkgs.callPackage ./_sources/generated.nix { };
    age-plugin-yubikey = callPackage ./age-plugin-yubikey { };
    awesome-extensions = callPackage ./awesome-extensions { };
    hexdiff = callPackage ./hexdiff { };
    xcursor-pixelfun = callPackage ./xcursor-pixelfun { };
    uhk-agent = callPackage ./uhk-agent { };
  };
in
self
