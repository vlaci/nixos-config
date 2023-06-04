{ pkgs, ... }:

{
  home.packages = with pkgs; [ gitstatus wezterm ];

  xdg.configFile."wezterm".source = ./wezterm;

  programs.bash.initExtra = ''
    source ${pkgs.wezterm}/etc/profile.d/wezterm.sh
  '';

  programs.zsh.initExtra = ''
    source ${pkgs.wezterm}/etc/profile.d/wezterm.sh
  '';
}
