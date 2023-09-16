{ lib, config, pkgs, ... }:

{
  # smart card (+yubikey)
  services.pcscd.enable = true;

  imports = [
    (lib.mkProfile "sshd" {
      services.openssh = {
        enable = true;
        startWhenNeeded = true;
        settings = {
          PasswordAuthentication = true;
          PermitRootLogin = "no";
          X11Forwarding = true;
        };
      };
      _.persist.directories = [
        "/etc/ssh"
      ];
    })
    (lib.mkProfile "libvirt" {
      virtualisation.libvirtd.enable = true;
      virtualisation.spiceUSBRedirection.enable = true;
      _.users.defaultGroups = [ "libvirtd" ];
      services.dbus.packages = with pkgs; [ dconf ];
      _.persist.directories = [
        "/var/lib/libvirt"
      ];
    })
    (lib.mkProfile "docker" {
      virtualisation.docker = {
        enable = true;
        autoPrune.enable = true;
      };
      _.users.defaultGroups = [ "docker" ];
      environment.systemPackages = with pkgs; [
        docker-compose
      ];
      _.persist.directories = [
        "/var/lib/docker"
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
    })
  ];
}
