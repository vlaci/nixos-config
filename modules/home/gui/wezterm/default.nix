{ lib, pkgs, config, ... }:

{
  home.packages = with pkgs; [ gitstatus ];

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm/wezterm.lua;
  };
  xdg.configFile = lib.pipe ./wezterm [
    builtins.readDir
    (lib.filterAttrs (name: type: type == "regular" && name != "wezterm.lua"))
    (lib.mapAttrs' (name: value: lib.nameValuePair "wezterm/${name}" { source = ./wezterm + "/${name}"; }))
  ];
}
