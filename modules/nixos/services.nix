{ lib, config, pkgs, ... }:

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
      services.dbus.packages = with pkgs; [ dconf ];
    })
    (lib.mkProfile "docker" {
      virtualisation.docker.enable = true;
      _.users.defaultGroups = [ "docker" ];
      environment.systemPackages = with pkgs; [
        docker-compose
      ];
    })
    (lib.mkProfile "podman" {
      _.users.defaultGroups = [ "podman" ];
      environment.systemPackages = with pkgs; [
        arion
        buildah

        # Do install the docker CLI to talk to podman.
        # Not needed when virtualisation.docker.enable = true;
        docker-client
        docker-compose
        podman-compose
      ];

      # Arion works with Docker, but for NixOS-based containers, you need Podman
      # since NixOS 21.05.
      virtualisation.podman.enable = true;
      virtualisation.podman.dockerSocket.enable = !config._.docker.enable;
      virtualisation.podman.defaultNetwork.dnsname.enable = true;
    })
  ];
}
