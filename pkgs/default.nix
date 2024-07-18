{ pkgs }:

let
  callPackage = pkgs.newScope (pkgs // self);
  self = rec {
    pkgsrcs = pkgs.callPackage ./_sources/generated.nix { };
    berkeley-mono-typeface = callPackage ./berkeley-mono-typeface { };
    flameshot-git = callPackage ./flameshot-git { };
    hexdiff = callPackage ./hexdiff { };
    mujmap = callPackage ./mujmap { };
    nix-patched = callPackage ./nix { };
    nu-scripts = callPackage ./nu-scripts { };
    swaylock-dpms = callPackage ./swaylock-dpms { };
    xcursor-pixelfun = callPackage ./xcursor-pixelfun { };
    linuxPackages_acs_override = callPackage ./linux_acs_override { };
    qutebrowser-js-env = callPackage ./qutebrowser-js-env { };
    # shortcut to allow build-pkgs task to find this derivation
    _kernel_acs_override = linuxPackages_acs_override.kernel;
    _kernel_acs_override_dev = linuxPackages_acs_override.kernel.dev;
    _emacs = pkgs.emacsVlaci or null;
  };
in
self
