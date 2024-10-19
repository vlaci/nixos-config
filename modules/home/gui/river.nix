{
  lib,
  config,
  pkgs,
  nixosConfig,
  ...
}:

lib.mkProfile "river" {
  wayland.windowManager.river = {
    enable = true;
    settings =
      let
        mod = "Alt";
        left = "h";
        down = "j";
        up = "k";
        right = "l";
        mode_gaps = "Outer Gaps: [I: Inner] [<←↓|↑|→>: Side] (Shift: Global) <H|L>: +/-Horizontal <J|K>: +/- Vertical <+|-|0|9>: All";
      in
      {
        default-layout = "rivertile";
        spawn = [
          "waybar"
          "rivertile"
        ];
        map = {
          normal = {
            "${mod} Return" = {
              spawn = "kitty";
            };
          };
        };
        map-pointer = {
          normal = {
            "${mod} BTN_LEFT" = "move-view";
            "${mod} BTN_RIGHT" = "resize-view";
            "${mod} BTN_MIDDLE" = "toggle-float";
          };
        };
        keyboard-layout =
          with nixosConfig.services.xserver.xkb;
          "${
            lib.optionalString (variant != "") "-variant ${lib.escapeShellArg variant}"
          } -options ${lib.escapeShellArg options} ${lib.escapeShellArg layout}";
      };
    extraConfig = ''
      rivertile -view-padding 6 -outer-padding 6 &
    '';
  };
}
