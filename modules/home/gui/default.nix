{ config, nixosConfig, lib, pkgs, ... }:

let
  inherit (lib) mkMerge mkIf mkProfile optionals;
  isWayland = nixosConfig._.gui.wayland.enable;
in
lib.mkProfile "gui" {
  imports = [
    ./awesome
    ./herbstluftwm
    ./theme
    ./hyprland.nix
    ./sway.nix
  ];

  services.picom = {
    enable = !isWayland;
    experimentalBackends = true;
    settings.blur-method = "dual_kawase";
    opacityRules = [
      "90:class_g = 'kitty'"
    ];
    vSync = true;
    backend = "glx";
  };

  programs.firefox = mkMerge [
    {
      enable = true;
    }
    (mkIf isWayland {
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        forceWayland = true;
        extraPolicies = {
          ExtensionSettings = { };
        };
      };
    })
  ];

  home.sessionVariables = mkIf isWayland {
    GTK_USE_PORTAL = 1;
    MOZ_ENABLE_WAYLAND = 1;
  };

  programs.kitty = {
    enable = true;
    keybindings."ctrl+shift+p>n" = ''kitten hints --type=linenum --linenum-action=window bat --pager "less --RAW-CONTROL-CHARS +{line}" -H {line} {path}'';
    settings.select_by_word_characters = "@-./_~?&%+#";
  };
  programs.zsh.initExtra = ''
    ssh() {
      TERM=''${TERM/-kitty/-256color} command ssh "$@"
    }
  '';

  programs.rofi = {
    enable = true;
  };

  services.screen-locker = {
    enable = !isWayland;
    lockCmd = "${pkgs.xsecurelock}/bin/xsecurelock";
    xautolock.extraOptions = [
      "-notify 15"
      "-notifier 'XSECURELOCK_DIM_TIME_MS=10000 XSECURELOCK_WAIT_TIME_MS=5000 ${pkgs.xsecurelock}/libexec/xsecurelock/until_nonidle ${pkgs.xsecurelock}/libexec/xsecurelock/dimmer'"
    ];
    xss-lock.extraOptions = [
      "--notifier ${pkgs.xsecurelock}/libexec/xsecurelock/dimmer"
      "--transfer-sleep-lock"
    ];
  };

  services.redshift = {
    enable = !isWayland;
    provider = "geoclue2";
    temperature.night = 3200;
  };

  services.syncthing.enable = true;

  home.keyboard = null;

  home.packages = with pkgs; [
    evince
    flameshot
    gimp
    signal-desktop
    vivaldi
  ] ++ (optionals isWayland [
    slurp
    wl-clipboard
    wofi
  ]);

  services.flameshot.enable = true;
  systemd.user.services.flameshot.Unit = mkIf isWayland {
    PartOf = [ "sway-session.target" ];
  };

  programs.waybar = {
    enable = isWayland;
    settings = [
      {
        layer = "top";
        position = "top";

        modules-left = [ "wlr/workspaces" "sway/workspaces" "sway/mode" "wlr/taskbar" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "sway/language" "pulseaudio" "idle_inhibitor" "disk" "disk#home" "clock" "tray" ];

        "sway/mode" = {
          format = " {}";
          max-length = 60;
        };

        "sway/window" = {
          icon = true;
        };

        "wlr/taskbar" = {
          format = "{icon} {title:.15}";
          on-click = "minimize-raise";
        };

        "sway/language" = {
          format = "{}";
          on-click = "swaymsg input type:keyboard xkb_switch_layout next";
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            headphone = "";
            default = [ "" "" ];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        disk = {
          path = "/";
          format = "/: {percentage_used}%";
        };
        "disk#home" = {
          path = "/home";
          format = "/home: {percentage_used}%";
        };
        clock = {
          format = "{:%B. %d, %H:%M}";
        };

        tray = {
          icon-size = 21;
          spacing = 10;
        };
      }
    ];
    style =
      let
        colors = nixosConfig._.theme.colors;
        theme_css = pkgs.writeText "theme.css" ''
          @define-color background ${colors.background};
          @define-color foreground ${colors.foreground};
          @define-color black ${colors.color0};
          @define-color red   ${colors.color1};
          @define-color green ${colors.color2};
          @define-color yellow ${colors.color3};
          @define-color blue  ${colors.color4};
          @define-color magenta ${colors.color5};
          @define-color cyan  ${colors.color6};
          @define-color white ${colors.color7};

          @define-color magenta_b ${colors.color13};
          @define-color cyan_b   ${colors.color14};
          @define-color yellow_b ${colors.color11};
          @define-color white_b  ${colors.color15};
          @define-color black_b  ${colors.color8};
          @define-color red_b    ${colors.color9};
          @define-color green_b  ${colors.color10};
          @define-color blue_b   ${colors.color12};
        '';
      in
      ''
         * {
             border: none;
             border-radius: 0;
             font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif;
             font-size: 13px;
             min-height: 0;
         }

         @import "${theme_css}";

         window#waybar {
             background: @background;
             /*border-bottom: 3px solid rgba(69, 133, 136, 1);*/
             color: @foreground;
         }

         #workspaces button {
             padding: 0 5px;
             background: transparent;
             color: @foreground;
             /* Use box-shadow instead of border so the text isn't offset */
             box-shadow: inset 0 -3px transparent;
             /* Avoid rounded borders under each workspace name */
             border: none;
             border-radius: 0;
         }

         /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
         #workspaces button:hover {
             background: shade(@background, 1.25);
             box-shadow: inset 0 -3px #ffffff;
         }

         #workspaces button.focused {
             background-color: shade(@background, 1.25);
             box-shadow: inset 0 -3px @yellow_b;
         }

         #workspaces button.urgent {
             background-color: @red;
         }

         #mode, #clock, #battery {
             padding: 0 10px;
             margin: 0 5px;
         }

         #mode {
             background: @red;
             box-shadow: inset 0 -3px @white;
         }

         #clock {
             box-shadow: inset 0 -3px @green;
         }

         #language {
             box-shadow: inset 0 -3px @green;
             padding: 0 0px;
             margin: 0 5px;
             min-width: 24px;
         }

         #disk {
             box-shadow: inset 0 -3px @blue;
         }

         #idle_inhibitor {
             box-shadow: inset 0 -3px @yellow;
         }

         #idle_inhibitor.activated {
             background-color: @yellow_b;
         }

         #pulseaudio {
             box-shadow: inset 0 -3px @magenta;
         }

         #pulseaudio.muted {
             background-color: @black_b;
         }

         #battery {
             box-shadow: inset 0 -3px @white_b;
         }

         #battery.charging {
             color: @background;
             background-color: @green;
         }

         @keyframes blink {
             to {
                 background-color: @white_b;
                 color: @background;
             }
         }

         #clock,
         #battery,
         #cpu,
         #memory,
         #disk,
         #temperature,
         #backlight,
         #network,
         #pulseaudio,
         #custom-media,
         #tray,
         #mode,
         #idle_inhibitor,
         #mpd {
              padding: 0 18px;
              margin: 0 3px;
         }

         #window,
         #workspaces {
             margin: 0 4px;
         }

         #battery.warning:not(.charging) {
             background: @red;
             color: @white_b;
             animation-name: blink;
             animation-duration: 0.5s;
             animation-timing-function: linear;
             animation-iteration-count: infinite;
             animation-direction: alternate;
         }

        #taskbar button.active {
             background-color: shade(@background, 1.25);
             box-shadow: inset 0 -3px @yellow_b;
        }
      '';
  };
  services.swayidle =
    let
      lockCommand = pkgs.writeShellScript "swaylock" ''
        ${pkgs.swaylock}/bin/swaylock --daemonize --color 000000
      '';
    in
    {
      enable = isWayland;
      events = [
        { event = "lock"; command = "${lockCommand}"; }
        { event = "before-sleep"; command = "${lockCommand}"; }
        { event = "after-resume"; command = "${pkgs.sway}/bin/swaymsg 'output * dpms on'"; }
      ];
      timeouts = [
        { timeout = 295; command = "${pkgs.libnotify}/bin/notify-send -u critical -t 5000 -i system-lock-screen 'Screen will be locked in 5 seconds...'"; }
        { timeout = 300; command = "${lockCommand}"; }
        { timeout = 310; command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'"; resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'"; }
      ];
    };

  systemd.user.services.swayidle.Service.Environment = [ "PATH=/bin" ];

  programs.mako = {
    enable = isWayland;
    anchor = "top-center";
    font = "sans 11";
    borderSize = 2;
    iconPath =
      let
        iconsPath = "${nixosConfig._.theme.iconTheme.package}/share/icons";
        themes = map (t: "${iconsPath}/${t}") (lib.attrNames (builtins.readDir iconsPath));
      in
      lib.concatStringsSep ":" themes;
    extraConfig = ''
      [urgency=low]
      border-color=#cccccc

      [urgency=high]
      border-color=#bf616a
      border-size=5
      default-timeout=0
    '';
  };
  services.kanshi = mkIf isWayland {
    enable = true;
  };

}
