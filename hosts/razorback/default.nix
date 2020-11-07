{ secrets, config, lib, pkgs, ... }:

{
  networking.hostName = "razorback";
  imports = [ secrets.users.vlaci ];

  _.networkmanager.enable = true;
  _.sshd.enable = true;
  _.gui.enable = true;
  _.libvirt.enable = true;

  users.mutableUsers = false;
  users.users.vlaci = {
    extraGroups = [ "libvirtd" "networkmanager" "wheel" ];
    isNormalUser = true;
    shell = pkgs.zsh;
    uid = 1000;
  };

  home-manager.users.vlaci = {
    _.git.enable = true;
    _.gpg.enable = true;
    _.tools.enable = true;
    _.doom-emacs.enable = true;
  };
}
