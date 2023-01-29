{ config, lib, pkgs, nixos-hardware, ... }:

{
  networking.hostName = "razorback";
  imports = [
    ./hardware-configuration.nix
    ./hardware-customization.nix
    (nixos-hardware + "/common/cpu/intel")
    (nixos-hardware + "/common/pc/ssd")
    (nixos-hardware + "/common/pc/laptop/acpi_call.nix")
  ];

  _.cachix.enable = true;
  _.networkmanager.enable = true;
  _.sshd.enable = true;
  _.gui.enable = true;
  _.gui.hyprland.enable = true;
  _.libvirt.enable = true;
  _.development.enable = true;
  _.email.enable = true;
  _.podman.enable = true;
  _.keyboardio.enable = true;

  _.users.users.vlaci = {
    isAdmin = true;
    uid = 1000;
    home-manager = {
      _.git.enable = true;
      _.gpg.enable = true;
      _.tools.enable = true;
      _.emacs.enable = true;
      _.sway.enable = true;
      _.hyprland.enable = true;
    };
  };

  system.stateVersion = "22.05";
}
