{ secrets, config, lib, pkgs, nixos-hardware, ... }:

{
  networking.hostName = "tachi";
  imports = [
    ./hardware-configuration.nix
    ./hardware-customization.nix
    (nixos-hardware + "/common/cpu/intel")
    (nixos-hardware + "/common/pc/ssd")
    (nixos-hardware + "/lenovo/thinkpad/t480s")

    secrets.users.vlaci
    secrets.work
  ];

  _.networkmanager.enable = true;
  _.sshd.enable = false;
  _.gui.enable = true;
  _.docker.enable = true;
  _.libvirt.enable = true;
  _.yubikey.enable = true;
  _.yubikey.pamU2f.enable = true;

  _.users.users.vlaci = {
    isAdmin = true;
    uid = 1000;
    home-manager = {
      _.git.enable = true;
      _.gpg.enable = true;
      _.development.enable = true;
      _.tools.enable = true;
      _.doom-emacs.enable = true;
      _.awesome.enable = true;
      home.packages = with pkgs; [ openconnect-sso ];
    };
  };
}
