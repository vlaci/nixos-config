{ pkgs }:

let
  callPackage = pkgs.newScope (pkgs // self);
  self = rec {
    pkgsrcs = pkgs.callPackage ./_sources/generated.nix { };
    age-plugin-yubikey = callPackage ./age-plugin-yubikey { };
    berkeley-mono-typeface = callPackage ./berkeley-mono-typeface { };
    hexdiff = callPackage ./hexdiff { };
    xcursor-pixelfun = callPackage ./xcursor-pixelfun { };
    linuxPackages_acs_override = callPackage ./linux_acs_override { };
    # shortcut to allow build-pkgs task to find this derivation
    _kernel_acs_override = linuxPackages_acs_override.kernel;
    _emacs = pkgs.emacsVlaci;
  };
in
self
