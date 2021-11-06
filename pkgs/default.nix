{ pkgs }:

let
  callPackage = pkgs.newScope (pkgs // self);
  self = rec {
    age-plugin-yubikey = callPackage ./age-plugin-yubikey { };
    awesome-extensions = callPackage ./awesome-extensions { };
    hexdiff = callPackage ./hexdiff { };
    xcursor-pixelfun = callPackage ./xcursor-pixelfun { };
    uhk-agent = callPackage ./uhk-agent { };
    mkDerivation = args: pkgs.stdenv.mkDerivation ({
      inherit (args.src) pname version;
    } // args);
  };
in
self
