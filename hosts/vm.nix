{ modulesPath, secrets, config, lib, pkgs, ... }: {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    secrets.users.vlaci
  ];

  _.sshd.enable = true;
  _.gui.enable = true;

  _.users.users.vlaci = {
    isAdmin = true;
    uid = 1000;
  };


  boot.extraModulePackages = [ ];
  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.opengl.package = (pkgs.mesa.override {
    enableGalliumNine = false;
    galliumDrivers = [ "swrast" "virgl" ];
  }).drivers;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  fileSystems."/" =
    {
      device = "/dev/mapper/vg-root";
      fsType = "xfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-partlabel/EFI\\x20System";
      fsType = "vfat";
    };

  fileSystems."/etc/nixos" =
    {
      device = "nixos-config";
      fsType = "9p";
      options = [ "trans=virtio" ];
    };
  swapDevices =
    [{ device = "/dev/mapper/vg-swap"; }];

  nix.settings.max-jobs = lib.mkDefault 2;
}
