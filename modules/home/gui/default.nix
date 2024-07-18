{ config, nixosConfig, lib, pkgs, ... }:

let
  inherit (lib) mkProfile optionalString;
in
mkProfile "gui" {
  imports = [
    ./theme
    ./wezterm
    ./hyprland.nix
    ./niri.nix
    ./river.nix
    ./sway.nix
  ];

  programs.firefox = {
    enable = true;
    package = with pkgs; firefox.override {
      nativeMessagingHosts = [
        tridactyl-native
      ];
    };
  };

  programs.qutebrowser = {
    enable = true;
    package = pkgs.buildEnv { name = "qutebrowser-env"; paths = with pkgs; [ bitwarden-cli keyutils qutebrowser ]; };
    keyBindings = {
      normal = {
        ",pp" = "spawn --userscript qute-bitwarden -t";
        ",pu" = "spawn --userscript qute-bitwarden --username-only";
        ",ps" = "spawn --userscript qute-bitwarden --password-only";
        ",pt" = "spawn --userscript qute-bitwarden --totp-only";
        "<Ctrl-g>" = "clear-keychain ;; search ;; fullscreen --leave";
      };
      caret = {
        "<Ctrl-g>" = "mode-leave";
      };
      command = {
        "<Ctrl-g>" = "mode-leave";
      };
      hint = {
        "<Ctrl-g>" = "mode-leave";
      };
      insert = {
        "<Ctrl-g>" = "mode-leave";
      };
      passthrough = {
        "<Ctrl-g>" = "mode-leave";
      };
      prompt = {
        "<Ctrl-g>" = "mode-leave";
      };
      register = {
        "<Ctrl-g>" = "mode-leave";
      };
    };
    searchEngines = {
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      nw = "https://nixos.wiki/index.php?search={}";
      g = "https://www.google.com/search?hl=en&q={}";
    };
    settings = {
      spellcheck.languages = [ "en-US" "hu-HU" ];
    };
    extraConfig = ''
      c.qt.environ = {
        "NODE_PATH": "${pkgs.qutebrowser-js-env}/libexec/qutebrowser-js-env/node_modules"
      }
    '';
  };

  home.sessionVariables = {
    GTK_USE_PORTAL = 1;
    MOZ_ENABLE_WAYLAND = 1;
  };

  programs.kitty = {
    enable = true;
    keybindings."ctrl+shift+p>n" = ''kitten hints --type=linenum --linenum-action=window bat --pager "less --RAW-CONTROL-CHARS +{line}" -H {line} {path}'';
    settings = {
      select_by_word_characters = "@-./_~?&%+#";
      scrollback_lines = 20000;
      scrollback_pager_history_size = 20; # 10k line / MiB
    };
    extraConfig = lib.mkAfter ''
      include themes.conf
    '';
  };

  programs.zsh.initExtra = ''
    ssh() {
      TERM=''${TERM/-kitty/-256color} command ssh "$@"
    }
  '';

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  services.syncthing.enable = true;

  _.persist.directories = [
    ".config/qutebrowser"
    ".config/syncthing"
    ".local/share/qutebrowser"
    ".mozilla"
  ];
  _.persist.files = [
    ".cache/rofi3.druncache"
  ];

  home.keyboard = null;

  home.packages = with pkgs; [
    evince
    flameshot-git
    gimp
    material-design-icons
    signal-desktop
    vivaldi
    slurp
    wl-clipboard
  ];

  services.flameshot = {
    enable = true;
    package = pkgs.flameshot-git;
  };

  systemd.user.services.flameshot = {
    Unit.PartOf = [ "sway-session.target" ];
    Service.Environment = lib.mkForce "PATH=${config.home.profileDirectory}/bin XDG_CURRENT_DESKTOP=sway";
  };

  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";

        modules-left = [ "hyprland/workspaces" "hyprland/submap" "sway/workspaces" "sway/mode" "river/tags" "river/mode" ];
        modules-center = [ "clock" ];
        modules-right = [ "idle_inhibitor" "sway/language" "hyprland/language" "pulseaudio" "disk" "disk#home" "battery" "tray" ];

        "hyprland/workspaces" = {
          "format" = "{icon}";
          "on-click" = "activate";
          "format-icons" = {
            "1" = "𐘹";
            "2" = "𐝐";
            "3" = "𐙁";
            "4" = "𐚒";
            "5" = "𐙢";
            "6" = "𐘠";
            "7" = "𐘴";
            "8" = "𐘢";
            "9" = "𐚐";
            "10" = "𐝀";
          };
          "sort-by-number" = true;
        };

        "sway/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = true;
          "format" = "{icon}";
          "format-icons" = {
            "1" = "𐘹";
            "2" = "𐝐";
            "3" = "𐙁";
            "4" = "𐚒";
            "5" = "𐙢";
            "6" = "𐘠";
            "7" = "𐘴";
            "8" = "𐘢";
            "9" = "𐚐";
            "10" = "𐝀";
          };
        };

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

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        "sway/language" = {
          format = "{}";
          on-click = "swaymsg input type:keyboard xkb_switch_layout next";
        };

        "hyprland/language" = {
          format = "{}";
          on-click = "hyprctl switchxkblayout";
        };

        "pulseaudio" = {
          format = "{icon}";
          format-bluetooth = "{icon} ";
          format-muted = "󰝟";
          format-icons = {
            headphone = "";
            default = [ "" "" ];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
        };

        disk = {
          path = "/";
          format = "󰉋 {percentage_used}%";
        };
        "disk#home" = {
          path = "/home";
          format = "󱂵 {percentage_used}%";
        };

        clock =
          {
            format = "{:%H:%M}  ";
            format-alt = "{:%A; %B %d, %Y (%R)}  ";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              "mode" = "year";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
              on-click-right = "mode";
              format = {
                "months" = "<span color='#ffead3'><b>{}</b></span>";
                days = "<span color='#ecc6d9'><b>{}</b></span>";
                weeks = "<span color='#99ffdd'><b>W{}</b></span>";
                weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                today = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
            };
            actions = {
              on-click-right = "mode";
              on-click-forward = "tz_up";
              on-click-backward = "tz_down";
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };

        battery = {
          format = "{icon}";

          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          states = {
            battery-10 = 10;
            battery-20 = 20;
            battery-30 = 30;
            battery-40 = 40;
            battery-50 = 50;
            battery-60 = 60;
            battery-70 = 70;
            battery-80 = 80;
            battery-90 = 90;
            battery-100 = 100;
          };

          format-plugged = "󰚥";
          format-charging-battery-10 = "󰢜";
          format-charging-battery-20 = "󰂆";
          format-charging-battery-30 = "󰂇";
          format-charging-battery-40 = "󰂈";
          format-charging-battery-50 = "󰢝";
          format-charging-battery-60 = "󰂉";
          format-charging-battery-70 = "󰢞";
          format-charging-battery-80 = "󰂊";
          format-charging-battery-90 = "󰂋";
          format-charging-battery-100 = "󰂅";
          tooltip-format = "{capacity}% {timeTo}";
        };

        tray = {
          icon-size = 21;
          spacing = 10;
        };
      }
    ];
    style = lib.mkAfter
      ''
        * {
            font-family: FontAwesome, monospace, Material Icons;
            font-size: 13px;
            font-weight: bold;
            min-height: 0;
        }

        window#waybar {
            background: alpha(@theme_base_color, 0.9);
            color: @theme_text_color;
        }

        #workspaces button {
            border: none;
            border-radius: 0;
        }

        #submap,
        #mode,
        #clock,
        #pulseaudio,
        #disk,
        #battery,
        #language,
        #tray,
        #idle_inhibitor {
            border-bottom: 3px solid transparent;
        }

        #idle_inhibitor.activated {
            border-bottom: 3px solid @base06;
        }

        #battery.warning:not(.charging) {
            background: @base08;
            color: @base05;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }
      '';
  };
  services.swayidle =
    let
      lockCommand = "${config.programs.swaylock.package}/bin/swaylock --daemonize";
      dpms = cmd: "true; ${optionalString config._.sway.enable "${pkgs.sway}/bin/swaymsg 'output * dpms ${cmd}';"} ${optionalString config._.hyprland.enable "${pkgs.hyprland}/bin/hyprctl dispatch dpms ${cmd};"}";
    in
    {
      enable = true;
      events = [
        { event = "lock"; command = "${lockCommand}"; }
        { event = "before-sleep"; command = "${lockCommand}"; }
        { event = "after-resume"; command = dpms "on"; }
      ];
      timeouts = [
        { timeout = 290; command = "${pkgs.libnotify}/bin/notify-send -u critical -t 10000 -i system-lock-screen 'Screen will be locked in 10 seconds...'"; }
        { timeout = 300; command = "${lockCommand}"; }
        { timeout = 310; command = dpms "off"; resumeCommand = dpms "on"; }
      ];
      systemdTarget = "graphical-session.target";
    };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-dpms;
  };

  services.mako = {
    enable = true;
    anchor = "top-center";
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

  services.kanshi = {
    enable = true;
  };

  services.darkman = {
    enable = true;
    settings.usegeoclue = true;
  };

  services.gammastep = {
    enable = true;
    provider = "geoclue2";
    tray = true;
    temperature.night = 3000;
  };
}
