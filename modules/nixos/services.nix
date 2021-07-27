{ lib, pkgs, ... }:

{
  # smart card (+yubikey)
  services.pcscd.enable = true;

  imports = [
    (lib.mkProfile "sshd" {
      services.openssh = {
        enable = true;
        forwardX11 = true;
        passwordAuthentication = true;
        permitRootLogin = "no";
        startWhenNeeded = true;
      };
    })
    (lib.mkProfile "libvirt" {
      virtualisation.libvirtd.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;
      _.users.defaultGroups = [ "libvirtd" ];
      services.dbus.packages = with pkgs; [ gnome3.dconf ];
    })
    (lib.mkProfile "docker" {
      virtualisation.docker.enable = true;
      _.users.defaultGroups = [ "docker" ];
    })
  ];
}
