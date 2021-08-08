{ secrets, config, lib, pkgs, nixos-hardware, ... }:

{
  networking.hostName = "razorback";
  imports = [
    ./hardware-configuration.nix
    ./hardware-customization.nix
    (nixos-hardware + "/common/cpu/intel")
    (nixos-hardware + "/common/pc/ssd")
    (nixos-hardware + "/common/pc/laptop/acpi_call.nix")
    secrets.users.vlaci
  ];

  _.cachix.enable = true;
  _.networkmanager.enable = true;
  _.sshd.enable = true;
  _.gui.enable = true;
  _.libvirt.enable = true;

  _.users.users.vlaci = {
    isAdmin = true;
    uid = 1000;
    home-manager = {
      _.development.enable = true;
      _.git.enable = true;
      _.gpg.enable = true;
      _.tools.enable = true;
      _.emacs.enable = true;
      _.awesome.enable = true;
    };
  };
}
