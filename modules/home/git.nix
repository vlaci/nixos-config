{ lib, pkgs, ... }:

lib.mkProfile "git" {
  programs.git = {
    enable = true;
    delta.enable = true;
    aliases = {
      lol = ''log --graph --pretty=format:"%C(yellow)%h%Creset%C(cyan)%C(bold)%d%Creset %C(cyan)(%cr)%Creset %C(green)%ae%Creset %s"'';
    };
    extraConfig = {
      absorb.maxStack = 50;
      merge.conflictStyle = "diff3";
    };
  };

  home.packages = with pkgs.gitAndTools; [
    git-absorb
    git-filter-repo
  ];
}
