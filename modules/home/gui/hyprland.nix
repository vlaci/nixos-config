{ lib, pkgs, nixosConfig, config, ... }:

let
  colors = nixosConfig._.theme.colors;
in
lib.mkProfile "hyprland" {
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      hyprexpo
      hyprscroller
    ];
    settings = {
      monitor = ",preferred,auto,1";
      exec-once = "hyprpaper & waybar";
      input = with nixosConfig.services.xserver.xkb; {
        kb_layout = layout;
        kb_variant = builtins.replaceStrings [ " " ] [ "" ] variant;
        kb_options = builtins.replaceStrings [ " " ] [ "" ] options;
        follow_mouse = 1;
        touchpad.natural_scroll = false;
        sensitivity = 0;
      };

      device = {
        name = "yubico-yubikey-otp+fido+ccid";
        kb_layout = "us";
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        layout = "scroller";
      };
      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 6;

        blur = {
          enabled = true;
          size = 16;
          passes = 2;
        };

        drop_shadow = true;
        shadow_offset = "4 4";
        shadow_range = 10;
        shadow_render_power = 1;
        "col.shadow" = lib.mkForce "rgba(0e0e0eb0)";

        dim_inactive = true;
        dim_strength = 0.1;
      };

      animations = {
        enabled = true;

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        new_status = "master";
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = false;
      };

      misc = {
        force_default_wallpaper = 0;
        focus_on_activate = true;
      };

      windowrule = [
        "float,title:^(Firefox — Sharing Indicator)$"
        "move 50%-38 100%-32,title:^(Firefox — Sharing Indicator)$"
        "pin,title:^(Firefox — Sharing Indicator)$"
        "float,title:^(MainPicker)$"
      ];

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      "$mainMod" = "SUPER";

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = [
        "$mainMod, Return, exec, wezterm"
        "$mainMod SHIFT, Q, killactive,"
        "$mainMod SHIFT, E, exec, swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit Hyprland? This will end your Wayland session.' -b 'Yes, exit' 'hyprctl dispatch exit'"
        "$mainMod, V, togglefloating,"
        "$mainMod, D, exec, fuzzel"
        "ALT CTRL, L, exec, systemctl --user kill --signal SIGUSR1 swayidle.service"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, J, togglesplit," # dwindle
        "$mainMod, G, togglegroup," # dwindle
        "$mainMod, COMMA, changegroupactive, b" # dwindle
        "$mainMod, PERIOD, changegroupactive, f" # dwindle

        # Move focus with mainMod + arrow keys
        # "$mainMod, left, movefocus, l"
        # "$mainMod, right, movefocus, r"
        # "$mainMod, up, movefocus, u"
        # "$mainMod, down, movefocus, d"

        "$mainMod, grave, hyprexpo:expo, toggle"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, moveworkspacetomonitor, 1 current"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, moveworkspacetomonitor, 2 current"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, moveworkspacetomonitor, 3 current"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, moveworkspacetomonitor, 4 current"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, moveworkspacetomonitor, 5 current"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, moveworkspacetomonitor, 6 current"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, moveworkspacetomonitor, 7 current"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, moveworkspacetomonitor, 8 current"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, moveworkspacetomonitor, 9 current"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, moveworkspacetomonitor, 10 current"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Scratchpad
        "$mainMod, Minus, togglespecialworkspace"
        "$mainMod SHIFT, Minus, movetoworkspace, special"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      plugin = {
        hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "rgb(111111)";
          workspace_method = "center current"; # [center/first] [workspace] e.g. first 1 or center m+1

          enable_gesture = true; # laptop touchpad
          gesture_fingers = 3; # 3 or 4
          gesture_distance = 300; # how far is the "max"
          gesture_positive = true; # positive = swipe down. Negative = swipe up.
        };
        scroller = {
          column_default_width = "twothirds";
          focus_wrap = false;
        };
      };
    };
    extraConfig = ''
      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, scroller:movefocus, l
      bind = $mainMod, right, scroller:movefocus, r
      bind = $mainMod, up, scroller:movefocus, u
      bind = $mainMod, down, scroller:movefocus, d
      bind = $mainMod, home, scroller:movefocus, begin
      bind = $mainMod, end, scroller:movefocus, end

      # Movement
      bind = $mainMod CTRL, left, scroller:movewindow, l
      bind = $mainMod CTRL, right, scroller:movewindow, r
      bind = $mainMod CTRL, up, scroller:movewindow, u
      bind = $mainMod CTRL, down, scroller:movewindow, d
      bind = $mainMod CTRL, home, scroller:movewindow, begin
      bind = $mainMod CTRL, end, scroller:movewindow, end

      # Modes
      bind = $mainMod, bracketleft, scroller:setmode, row
      bind = $mainMod, bracketright, scroller:setmode, col

      # Sizing keys
      bind = $mainMod, equal, scroller:cyclesize, next
      bind = $mainMod, minus, scroller:cyclesize, prev

      # Admit/Expel
      bind = $mainMod, I, scroller:admitwindow,
      bind = $mainMod, O, scroller:expelwindow,

      # Center submap
      # will switch to a submap called center
      bind = $mainMod, C, submap, center
      # will start a submap called "center"
      submap = center
      # sets repeatable binds for resizing the active window
      bind = , C, scroller:alignwindow, c
      bind = , C, submap, reset
      bind = , right, scroller:alignwindow, r
      bind = , right, submap, reset
      bind = , left, scroller:alignwindow, l
      bind = , left, submap, reset
      bind = , up, scroller:alignwindow, u
      bind = , up, submap, reset
      bind = , down, scroller:alignwindow, d
      bind = , down, submap, reset
      # use reset to go back to the global submap
      bind = , escape, submap, reset
      # will reset the submap, meaning end the current one and return to the global one
      submap = reset

      # Resize submap
      # will switch to a submap called resize
      bind = $mainMod SHIFT, R, submap, resize
      # will start a submap called "resize"
      submap = resize
      # sets repeatable binds for resizing the active window
      binde = , right, resizeactive, 100 0
      binde = , left, resizeactive, -100 0
      binde = , up, resizeactive, 0 -100
      binde = , down, resizeactive, 0 100
      # use reset to go back to the global submap
      bind = , escape, submap, reset
      # will reset the submap, meaning end the current one and return to the global one
      submap = reset

      # Fit size submap
      # will switch to a submap called fitsize
      bind = $mainMod, W, submap, fitsize
      # will start a submap called "fitsize"
      submap = fitsize
      # sets binds for fitting columns/windows in the screen
      bind = , W, scroller:fitsize, visible
      bind = , W, submap, reset
      bind = , right, scroller:fitsize, toend
      bind = , right, submap, reset
      bind = , left, scroller:fitsize, tobeg
      bind = , left, submap, reset
      bind = , up, scroller:fitsize, active
      bind = , up, submap, reset
      bind = , down, scroller:fitsize, all
      bind = , down, submap, reset
      # use reset to go back to the global submap
      bind = , escape, submap, reset
      # will reset the submap, meaning end the current one and return to the global one
      submap = reset

      # overview keys
      # bind key to toggle overview (normal)
      bind = $mainMod, tab, scroller:toggleoverview
      # overview submap
      # will switch to a submap called overview
      bind = $mainMod, tab, submap, overview
      # will start a submap called "overview"
      submap = overview
      bind = , right, scroller:movefocus, right
      bind = , left, scroller:movefocus, left
      bind = , up, scroller:movefocus, up
      bind = , down, scroller:movefocus, down
      # use reset to go back to the global submap
      bind = , escape, scroller:toggleoverview,
      bind = , escape, submap, reset
      bind = , return, scroller:toggleoverview,
      bind = , return, submap, reset
      bind = $mainMod, tab, scroller:toggleoverview,
      bind = $mainMod, tab, submap, reset
      # will reset the submap, meaning end the current one and return to the global one
      submap = reset

      # Marks
      bind = $mainMod, M, submap, marksadd
      submap = marksadd
      bind = , a, scroller:marksadd, a
      bind = , a, submap, reset
      bind = , b, scroller:marksadd, b
      bind = , b, submap, reset
      bind = , c, scroller:marksadd, c
      bind = , c, submap, reset
      bind = , escape, submap, reset
      submap = reset

      bind = $mainMod SHIFT, M, submap, marksdelete
      submap = marksdelete
      bind = , a, scroller:marksdelete, a
      bind = , a, submap, reset
      bind = , b, scroller:marksdelete, b
      bind = , b, submap, reset
      bind = , c, scroller:marksdelete, c
      bind = , c, submap, reset
      bind = , escape, submap, reset
      submap = reset

      bind = $mainMod, apostrophe, submap, marksvisit
      submap = marksvisit
      bind = , a, scroller:marksvisit, a
      bind = , a, submap, reset
      bind = , b, scroller:marksvisit, b
      bind = , b, submap, reset
      bind = , c, scroller:marksvisit, c
      bind = , c, submap, reset
      bind = , escape, submap, reset
      submap = reset

      bind = $mainMod CTRL, M, scroller:marksreset
    '';
  };

  home.packages = with pkgs; [
    hyprpaper
  ];

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${config.stylix.image}
    wallpaper = ,${config.stylix.image}
  '';
}
