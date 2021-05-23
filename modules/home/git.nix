{ lib, ... }:

lib.mkProfile "git" {
  programs.git = {
    enable = true;
    delta.enable = true;
    aliases = {
      lol = ''log --graph --pretty=format:"%C(yellow)%h%Creset%C(cyan)%C(bold)%d%Creset %C(cyan)(%cr)%Creset %C(green)%ae%Creset %s"'';
    };
  };
}
