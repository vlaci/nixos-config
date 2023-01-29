{ lib, config, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config._.gui.hyprland;
in
{
  options = {
    _.gui.hyprland.enable = mkEnableOption "wayland";
  };
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
    };

    nixpkgs.overlays = [
      (final: prev: {
        waybar =
          let
            hyprctl = "${pkgs.hyprland}/bin/hyprctl";
          in
          prev.waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
            postPatch = (oldAttrs.postPatch or "") + ''
              sed -i 's|zext_workspace_handle_v1_activate(workspace_handle_);|const std::string command = "${hyprctl} dispatch workspace " + name_;\n\tsystem(command.c_str());|g' src/modules/wlr/workspace_manager.cpp
            '';
          });
      })
    ];
  };
}
