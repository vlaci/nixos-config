{ lib, pkgs, nixosConfig, config, ... }:

let
  colors = nixosConfig._.theme.colors;
in
lib.mkProfile "hyprland" {
  wayland.windowManager.hyprland = {
    enable = true;
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
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        layout = "dwindle";
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
        new_is_master = true;
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
        "$mainMod, D, exec, rofi -show drun"
        "ALT CTRL, L, exec, systemctl --user kill --signal SIGUSR1 swayidle.service"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, J, togglesplit," # dwindle
        "$mainMod, G, togglegroup," # dwindle
        "$mainMod, COMMA, changegroupactive, b" # dwindle
        "$mainMod, PERIOD, changegroupactive, f" # dwindle

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

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
    };
    extraConfig = ''
      device {
        name=yubico-yubikey-otp+fido+ccid
        kb_layout=us
      }
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
