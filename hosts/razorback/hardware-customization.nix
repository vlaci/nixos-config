{ lib, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_acs_override;
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "100%";
  };
  boot.kernelParams = [
    "pcie_acs_override=downstream,multifunction"
    "intel_iommu=on"
    "pci=noaer"
    "acpi_enforce_resources=lax"
    "thermal.off=1"
    "module_blacklist=eeepc_wmi"
  ];
  boot.extraModprobeConfig = ''
    options vfio-pci ids=10de:1b81,10de:10f0,1b21:2142
  '';
  boot.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
    "vfio_virqfd"
    "dm_thin_pool"
    "dm_mirror"
  ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.graphics.extraPackages = with pkgs; [ intel-media-driver ];
  hardware.opengl.driSupport32Bit = true;

  services.xserver.videoDrivers = [ "modesetting" ];

  services.fstrim.enable = true;

  networking.hostId = "8425e349";

  boot.supportedFilesystems = [ "zfs" ];

  boot.zfs = {
    allowHibernation = true;
    devNodes = "/dev/mapper";
    forceImportRoot = false;
  };

  services.zfs.autoScrub.enable = true;

  virtualisation.docker.storageDriver = "zfs";

  boot.initrd.systemd = {
    enable = true;
    emergencyAccess = true;
    services.revert-root = {
      after = [ "zfs-import-rpool.service" ];
      requiredBy = [ "initrd.target" ];
      before = [ "sysroot.mount" ];
      path = with pkgs; [ zfs ];
      unitConfig = {
        DefaultDependencies = "no";
        ConditionKernelCommandLine = [ "!zfs_no_rollback" ];
      };
      serviceConfig.Type = "oneshot";

      script = ''
        zfs rollback -r rpool/razorback/root@blank
      '';
    };
    services.zfs-import-rpool.after = [ "cryptsetup.target" ];
    services.create-needed-for-boot-dirs.after = lib.mkForce [ "revert-root.service" ];
  };

  disko.devices = (import ./disko-config.nix { disks = [ "/dev/nvme0n1" ]; }).disko.devices;

  environment.systemPackages = with pkgs; [ powertop ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;
  services.upower.enable = true;

  services.logind = {
    extraConfig = ''
      HandlePowerKey=suspend
      PowerKeyIgnoreInhibited=yes
    '';
  };

  powerManagement.cpuFreqGovernor = "performance";
}
