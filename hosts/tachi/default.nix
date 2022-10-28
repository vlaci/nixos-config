{ config, lib, pkgs, nixos-hardware, ... }:

{
  networking.hostName = "tachi";
  services.tzupdate.enable = true;
  imports = [
    ./hardware-configuration.nix
    ./hardware-customization.nix
    (nixos-hardware + "/common/cpu/intel")
    (nixos-hardware + "/lenovo/thinkpad/t14")
  ];

  _.cachix.enable = true;
  _.development.enable = true;
  _.networkmanager.enable = true;
  _.sshd.enable = true;
  _.gui.enable = true;
  _.docker.enable = true;
  _.podman.enable = true;
  _.libvirt.enable = true;
  _.yubikey.enable = true;
  _.yubikey.pamU2f.enable = true;
  _.email.enable = true;
  _.email.work.enable = true;
  _.work.enable = true;

  _.users.users.vlaci = {
    isAdmin = true;
    uid = 1000;
    home-manager = {
      _.git.enable = true;
      _.gpg.enable = true;
      _.tools.enable = true;
      _.emacs.enable = true;
      _.awesome.enable = true;
      home.packages = with pkgs; [ thunderbird-bin ];
    };
  };
  networking.firewall.interfaces."virbr0".allowedTCPPorts = [ 139 445 ];
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  system.stateVersion = "22.05";
}
