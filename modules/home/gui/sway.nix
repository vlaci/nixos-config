{ lib, config, pkgs, ... }:

lib.mkProfile "sway"
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = let
      mod = "Mod4";
      left = "h";
      down = "j";
      up = "k";
      right = "l";
    in {
      bars = [{
        position = "top";
        fonts = config.wayland.windowManager.sway.config.fonts;
        colors = {
          statusline = "#ffffff";
          background = "#323232";
          inactiveWorkspace = {
            background = "#32323200";
            border = "#32323200";
            text = "#5c5c5c";
          };
        };
        statusCommand = "while date +'%Y-%m-%d %l:%M:%S %p'; do sleep 1; done";
      }];
      left = left;
      down = down;
      up = up;
      right = right;
      modifier = mod;
      input = {
        "type:keyboard" = {
          xkb_layout = "us,hu";
          xkb_options = "grp:alt_shift_toggle";
        };
      };
      fonts = {
        names = [ "Sans" "Fontawesome" "Material Design Icons" ];
        size = 11.0;
      };
      keybindings = {
        #
        # Basics:
        #
        "${mod}+Return" = "exec kitty";
        "${mod}+Shift+q" = "kill";
        "${mod}+d" = "exec rofi -show drun";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

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
        "${mod}+1" = "workspace 1";
        "${mod}+2" = "workspace 2";
        "${mod}+3" = "workspace 3";
        "${mod}+4" = "workspace 4";
        "${mod}+5" = "workspace 5";
        "${mod}+6" = "workspace 6";
        "${mod}+7" = "workspace 7";
        "${mod}+8" = "workspace 8";
        "${mod}+9" = "workspace 9";
        "${mod}+0" = "workspace 10";
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
      };
    };
  };
  home.packages = with pkgs; [
    wl-clipboard
    mako # notification daemon
    alacritty # Alacritty is the default terminal in the config
  ];
}
