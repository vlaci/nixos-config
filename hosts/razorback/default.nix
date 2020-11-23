{ secrets, config, lib, pkgs, ... }:

{
  networking.hostName = "razorback";
  imports = [ secrets.users.vlaci ];

  _.networkmanager.enable = true;
  _.sshd.enable = true;
  _.gui.enable = true;
  _.libvirt.enable = true;

  _.users.users.vlaci = {
    isAdmin = true;
    uid = 1000;
    home-manager = {
      _.git.enable = true;
      _.gpg.enable = true;
      _.tools.enable = true;
      _.doom-emacs.enable = true;
      #home.packages = with pkgs; [
      #  emacs-all-the-icons-fonts
      #  emacs
      #];
    };
  };
}
