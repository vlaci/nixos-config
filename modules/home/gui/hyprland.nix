{ lib, pkgs, nixosConfig, ... }:

let
  colors = nixosConfig._.theme.colors;
in
lib.mkProfile "hyprland" {
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      monitor=,preferred,auto,1
      workspace=DP-1,1

      input {
          #kb_file=
          kb_layout=us,hu
          #kb_variant=
          #kb_model=
          #kb_options=
          #kb_rules=

          follow_mouse=1

          touchpad {
              natural_scroll=yes
          }

          sensitivity=0 # -1.0 - 1.0, 0 means no modification.
      }

      general {
          main_mod=SUPER

          gaps_in=5
          gaps_out=20
          border_size=2
          col.active_border=0x90${builtins.substring 1 8 colors.color4}
          col.inactive_border=0x90${builtins.substring 1 8 colors.color0}

          apply_sens_to_raw=0 # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)

          damage_tracking=full # leave it on full unless you hate your GPU and want to make it suffer
      }

      misc {
          mouse_move_enables_dpms=1
      }

      exec-once = waybar

      decoration {
          rounding=10
          blur=1
          blur_size=3 # minimum 1
          blur_passes=1 # minimum 1
          blur_new_optimizations=1
      }

      animations {
          enabled=1
          animation=windows,1,7,default
          animation=border,1,10,default
          animation=fade,1,10,default
          animation=workspaces,1,6,default
      }

      dwindle {
          pseudotile=0 # enable pseudotiling on dwindle
      }

      gestures {
          workspace_swipe=no
      }

      # example window rules
      # for windows named/classed as abc and xyz
      #windowrule=move 69 420,abc
      #windowrule=size 420 69,abc
      #windowrule=tile,xyz
      #windowrule=float,abc
      #windowrule=pseudo,abc
      #windowrule=monitor 0,xyz

      # example binds
      bind=SUPERSHIFT,Q,killactive,
      bind=SUPER,Return,exec,kitty
      bind=SUPERSHIFT,E,exit,
      bind=SUPER,V,togglefloating,
      bind=SUPER,D,exec,rofi -show drun
      bind=SUPER,P,pseudo,

      bind=SUPER,left,movefocus,l
      bind=SUPER,right,movefocus,r
      bind=SUPER,up,movefocus,u
      bind=SUPER,down,movefocus,d

      bind=SUPER,1,workspace,1
      bind=SUPER,2,workspace,2
      bind=SUPER,3,workspace,3
      bind=SUPER,4,workspace,4
      bind=SUPER,5,workspace,5
      bind=SUPER,6,workspace,6
      bind=SUPER,7,workspace,7
      bind=SUPER,8,workspace,8
      bind=SUPER,9,workspace,9
      bind=SUPER,0,workspace,10

      bind=SUPERSHIFT,1,movetoworkspace,1
      bind=SUPERSHIFT,2,movetoworkspace,2
      bind=SUPERSHIFT,3,movetoworkspace,3
      bind=SUPERSHIFT,4,movetoworkspace,4
      bind=SUPERSHIFT,5,movetoworkspace,5
      bind=SUPERSHIFT,6,movetoworkspace,6
      bind=SUPERSHIFT,7,movetoworkspace,7
      bind=SUPERSHIFT,8,movetoworkspace,8
      bind=SUPERSHIFT,9,movetoworkspace,9
      bind=SUPERSHIFT,0,movetoworkspace,10

      bind=SUPER,mouse_down,workspace,e+1
      bind=SUPER,mouse_up,workspace,e-1

      bind=SUPER,R,submap,resize

      submap=resize

      binde=,right,resizeactive,10 0
      binde=,left,resizeactive,-10 0
      binde=,up,resizeactive,0 -10
      binde=,down,resizeactive,0 10

      bind=,escape,submap,reset

      submap=reset
    '';
  };

  programs.waybar.package = pkgs.waybar-hyprland;
}
