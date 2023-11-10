{ pkgs }:

let
  callPackage = pkgs.newScope (pkgs // self);
  self = rec {
    pkgsrcs = pkgs.callPackage ./_sources/generated.nix { };
    atuin-zfs = callPackage ./atuin { inherit (pkgs) atuin; };
    berkeley-mono-typeface = callPackage ./berkeley-mono-typeface { };
    hexdiff = callPackage ./hexdiff { };
    mujmap = callPackage ./mujmap { };
    nu-scripts = callPackage ./nu-scripts { };
    swaylock-dpms = callPackage ./swaylock-dpms { };
    wezterm-nightly = callPackage ./wezterm-nightly { };
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
