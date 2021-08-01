{ pkgs }:

let
  callPackage = pkgs.newScope (pkgs // self);
  self = rec {
    awesome-extensions = callPackage ./awesome-extensions { };
    hexdiff = callPackage ./hexdiff { };
    xcursor-pixelfun = callPackage ./xcursor-pixelfun { };
    mkDerivation = args: pkgs.stdenv.mkDerivation ({
      inherit (args.src) pname version;
    } // args);
  };
in
self