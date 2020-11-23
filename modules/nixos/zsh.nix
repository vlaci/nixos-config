{ pkgs, ... }:

{
  programs.zsh.enable = true;
  programs.zsh.enableGlobalCompInit = false;

  users.defaultUserShell = pkgs.zsh;
}
