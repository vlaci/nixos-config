{ lib, config, pkgs, nixosConfig, ... }:

let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;
  colors = nixosConfig._.theme.colors;
  cfg = config._.sway;
in
{
  options = {
    _.sway.enable = mkEnableOption "sway";

  };
  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.swayfx;
      wrapperFeatures.gtk = true;
      config =
        let
          mod = "Mod4";
          left = "h";
          down = "j";
          up = "k";
          right = "l";
          mode_gaps = "Outer Gaps: [I: Inner] [<←↓|↑|→>: Side] (Shift: Global) <H|L>: +/-Horizontal <J|K>: +/- Vertical <+|-|0|9>: All";
        in
        {
          bars = [{
            command = "waybar";
          }];
          output = { "*" = { bg = "${config.stylix.image} fill"; }; };
          left = left;
          down = down;
          up = up;
          right = right;
          modifier = mod;
          input = with nixosConfig.services.xserver.xkb; {
            "type:keyboard" = mkMerge [
              {
                xkb_layout = layout;
              }
              (
                let xkb_variant = builtins.replaceStrings [ " " ] [ "" ] variant;
                in mkIf (xkb_variant != "") {
                  inherit xkb_variant;
                }
              )
              (
                let xkb_options = builtins.replaceStrings [ " " ] [ "" ] options;
                in mkIf (xkb_options != "") {
                  inherit xkb_options;
                }
              )
            ];
          };
          fonts = {
            names = [ "Sans" "Fontawesome" "Material Design Icons" ];
          };
          keybindings = {
            #
            # Basics:
            #
            "${mod}+Return" = "exec wezterm";
            "${mod}+Shift+q" = "kill";
            "${mod}+d" = "exec fuzzel";
            "${mod}+Shift+c" = "reload";
            "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
            "Mod1+Ctrl+l" = "exec systemctl --user kill --signal SIGUSR1 swayidle.service";

            #
            # Moving around:
            #
            # Move your focus around
            "${mod}+${left}" = "focus left";
            "${mod}+${down}" = "focus down";
            "${mod}+${up}" = "focus up";
            "${mod}+${right}" = "focus right";
            # Or use $mod+[up|down|left|right]
            "${mod}+Left" = "focus left";
            "${mod}+Down" = "focus down";
            "${mod}+Up" = "focus up";
            "${mod}+Right" = "focus right";

            # Move the focused window with the same, but add Shift
            "${mod}+Shift+${left}" = "move left";
            "${mod}+Shift+${down}" = "move down";
            "${mod}+Shift+${up}" = "move up";
            "${mod}+Shift+${right}" = "move right";
            # Ditto, with arrow keys
            "${mod}+Shift+Left" = "move left";
            "${mod}+Shift+Down" = "move down";
            "${mod}+Shift+Up" = "move up";
            "${mod}+Shift+Right" = "move right";
            #
            # Workspaces:
            #
            # Switch to workspace
            "${mod}+1" = ''[workspace="1"] move workspace to output current; workspace number 1'';
            "${mod}+2" = ''[workspace="2"] move workspace to output current; workspace number 2'';
            "${mod}+3" = ''[workspace="3"] move workspace to output current; workspace number 3'';
            "${mod}+4" = ''[workspace="4"] move workspace to output current; workspace number 4'';
            "${mod}+5" = ''[workspace="5"] move workspace to output current; workspace number 5'';
            "${mod}+6" = ''[workspace="6"] move workspace to output current; workspace number 6'';
            "${mod}+7" = ''[workspace="7"] move workspace to output current; workspace number 7'';
            "${mod}+8" = ''[workspace="8"] move workspace to output current; workspace number 8'';
            "${mod}+9" = ''[workspace="9"] move workspace to output current; workspace number 9'';
            "${mod}+0" = ''[workspace="0"] move workspace to output current; workspace number 0'';
            # Move focused container to workspace
            "${mod}+Shift+1" = "move container to workspace 1";
            "${mod}+Shift+2" = "move container to workspace 2";
            "${mod}+Shift+3" = "move container to workspace 3";
            "${mod}+Shift+4" = "move container to workspace 4";
            "${mod}+Shift+5" = "move container to workspace 5";
            "${mod}+Shift+6" = "move container to workspace 6";
            "${mod}+Shift+7" = "move container to workspace 7";
            "${mod}+Shift+8" = "move container to workspace 8";
            "${mod}+Shift+9" = "move container to workspace 9";
            "${mod}+Shift+0" = "move container to workspace 10";
            # Note: workspaces can have any name you want, not just numbers.
            # We just use 1-10 as the default.
            #
            # Layout stuff:
            #
            # You can "split" the current object of your focus with
            # $mod+b or $mod+v, for horizontal and vertical splits
            # respectively.
            "${mod}+b" = "splith";
            "${mod}+v" = "splitv";

            # Switch the current container between different layout styles
            "${mod}+s" = "layout stacking";
            "${mod}+w" = "layout tabbed";
            "${mod}+e" = "layout toggle split";

            # Make the current focus fullscreen
            "${mod}+f" = "fullscreen";

            # Toggle the current focus between tiling and floating mode
            "${mod}+Shift+space" = "floating toggle";

            # Swap focus between the tiling area and the floating area
            "${mod}+space" = "focus mode_toggle";

            # Move focus to the parent container
            "${mod}+a" = "focus parent";
            #
            # Scratchpad:
            #
            # Sway has a "scratchpad", which is a bag of holding for windows.
            # You can send windows there and get them back later.

            # Move the currently focused window to the scratchpad
            "${mod}+Shift+minus" = "move scratchpad";

            # Show the next scratchpad window or hide the focused scratchpad window.
            # If there are multiple scratchpad windows, this command cycles through them.
            "${mod}+minus" = "scratchpad show";
            #
            # Resizing containers:
            #
            "${mod}+r" = ''mode "resize"'';
            "${mod}+g" = ''mode "${mode_gaps}"'';
            "${mod}+x" = "move workspace to output left";
            "${mod}+c" = "move workspace to output right";
            "--locked XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
            "--locked XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
          };
          modes =
            let
              mode_gaps_inner = mkGapsLabel "Inner";
              mode_gaps_left = mkGapsLabel "Left";
              mode_gaps_bottom = mkGapsLabel "Bootom";
              mode_gaps_top = mkGapsLabel "Top";
              mode_gaps_right = mkGapsLabel "Right";

              mkGapsLabel = dir: "${dir} Gaps: (Shift: Global) <+|-|0|9>: All";
              mkGaps = dir: {
                plus = "gaps ${dir} current plus 5";
                minus = "gaps ${dir} current minus 5";
                "0" = "gaps ${dir} current set 0";
                "9" = "gaps ${dir} current set 40";

                "Shift+plus" = "gaps ${dir} all plus 5";
                "Shift+minus" = "gaps ${dir} all minus 5";
                "Shift+0" = "gaps ${dir} all set 0";
                "Shift+9" = "gaps ${dir} all set 40";

                Escape = ''mode "${mode_gaps}"'';
                Return = ''mode "${mode_gaps}"'';
              };
            in
            {
              resize = rec {
                Down = "resize grow height 10 px";
                Escape = "mode default";
                Left = "resize shrink width 10 px";
                Return = "mode default";
                Right = "resize grow width 10 px";
                Up = "resize shrink height 10 px";
                h = Left;
                j = Down;
                k = Up;
                l = Right;
              };
              ${mode_gaps} = (mkGaps "outer") // {
                Left = ''mode "${mode_gaps_left}"'';
                Down = ''mode "${mode_gaps_bottom}"'';
                Up = ''mode "${mode_gaps_top}"'';
                Right = ''mode "${mode_gaps_right}"'';

                i = ''mode "${mode_gaps_inner}"'';

                h = "gaps horizontal current minus 10";
                j = "gaps vertical current plus 10";
                k = "gaps vertical current minus 10";
                l = "gaps horizontal current plus 10";

                "Shift+h" = "gaps horizontal all minus 10";
                "Shift+j" = "gaps vertical all plus 10";
                "Shift+k" = "gaps vertical all minus 10";
                "Shift+l" = "gaps horizontal all plus 10";

                Escape = "mode default";
                Return = "mode default";
              };
              ${mode_gaps_inner} = mkGaps "inner";
              ${mode_gaps_left} = mkGaps "left";
              ${mode_gaps_bottom} = mkGaps "bottom";
              ${mode_gaps_top} = mkGaps "top";
              ${mode_gaps_right} = mkGaps "right";
            };
        };
      extraConfig = ''
        blur enable
        shadows enable
        corner_radius 5
        layer_effects waybar blur enable; shadows enable
      '';
      checkConfig = false;
    };
  };
}
