{ pkgs }:

let
  callPackage = pkgs.newScope (pkgs // self);
  self = rec {
    pkgsrcs = pkgs.callPackage ./_sources/generated.nix { };
    berkeley-mono-typeface = callPackage ./berkeley-mono-typeface { };
    hexdiff = callPackage ./hexdiff { };
    mujmap = callPackage ./mujmap { };
    wezterm-nightly = callPackage ./wezterm-nightly { };
    xcursor-pixelfun = callPackage ./xcursor-pixelfun { };
    linuxPackages_acs_override = callPackage ./linux_acs_override { };
    # shortcut to allow build-pkgs task to find this derivation
    _kernel_acs_override = linuxPackages_acs_override.kernel;
    _emacs = pkgs.emacsVlaci;
  };
in
self
