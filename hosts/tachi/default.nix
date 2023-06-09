{ config, lib, pkgs, nixos-hardware, ... }:

{
  networking.hostName = "tachi";
  services.automatic-timezoned.enable = true;
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
  _.gui.hyprland.enable = true;
  _.docker.enable = true;
  _.podman.enable = true;
  _.libvirt.enable = true;
  _.yubikey.enable = true;
  _.yubikey.pamU2f.enable = true;
  _.email.enable = true;
  _.email.work.enable = true;
  _.keyboardio.enable = true;
  _.work.enable = true;

  _.users.users.vlaci = {
    isAdmin = true;
    uid = 1000;
    home-manager = {
      _.git.enable = true;
      _.gpg.enable = true;
      _.nushell.enable = true;
      _.tools.enable = true;
      _.emacs.enable = true;
      _.sway.enable = true;
      _.hyprland.enable = true;
    };
  };
  networking.firewall.interfaces."virbr0".allowedTCPPorts = [ 139 445 ];
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";
  services.printing.enable = true;

  system.stateVersion = "23.05";
}
