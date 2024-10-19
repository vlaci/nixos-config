{
  flameshot,
  pkgsrcs,
  libsForQt5,
  buildEnv,
  grim,
}:

let
  flameshot-git = flameshot.overrideAttrs (super: {
    inherit (pkgsrcs.flameshot) pname version src;

    buildInputs = super.buildInputs ++ [ libsForQt5.kguiaddons ];

    cmakeFlags = [
      "-DUSE_WAYLAND_CLIPBOARD=1"
      "-DUSE_WAYLAND_GRIM=1"
    ];
  });
in
buildEnv {
  name = "flameshot-env";
  paths = [
    flameshot-git
    grim
  ];
}
