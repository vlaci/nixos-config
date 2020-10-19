{ secrets, config, lib, pkgs, ... }:

{
  networking.hostName = "razorback";
 
  users.mutableUsers = false;

  _.defaultUser = secrets.users.default;
  _.networkmanager.enable = true;
  _.sshd.enable = true;
  _.gui.enable = true;

  _.home-manager.defaultUser = { secrets, ... }: {
    _.user = secrets.users.default;
    _.git.enable = true;
    _.gpg.enable = true;
    _.gui.enable = true;
    _.tools.enable = true;
    _.doom-emacs.enable = true;

    programs.git.extraConfig = secrets.git.extraConfig;
  };
  home-manager.users.root = {};
}
