{ lib, pkgs, nixosConfig, ... }:

let
  inherit (lib) listToAttrs mkDefault mkIf mkProfile nameValuePair;
  inherit (nixosConfig._.secrets) vlaci;
in
lib.mkProfile "git" (mkIf vlaci.available {
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
    ignores = [ "\\#*\\#" ".\\#*" ".direnv" ];
    lfs.enable = true;
    userName = vlaci.value.fullName;
    userEmail = mkDefault vlaci.value.email.git.address;
    extraConfig.emailprompt =
      listToAttrs (map (e: nameValuePair e { prompt = " "; }) vlaci.value.email.addresses.github)
      // listToAttrs (map (e: nameValuePair e { prompt = "🏠"; }) vlaci.value.email.addresses.home)
      // listToAttrs (map (e: nameValuePair e { prompt = "👔"; }) vlaci.value.email.addresses.work);
  };

  home.packages = with pkgs.gitAndTools; [
    git-absorb
    git-filter-repo
    git-remote-gcrypt
  ];
})
