{ pkgs, ... }:

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
  boot.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" "dm_thin_pool" "dm_mirror" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
  hardware.opengl.driSupport32Bit = true;

  services.xserver.videoDrivers = [ "modesetting" ];

  services.fstrim.enable = true;
  networking.hostId = "8425e349";
  boot.zfs.requestEncryptionCredentials = true;
  boot.initrd.systemd = {
    enable = true;
    services.revert-root = {
      after = [
        "zfs-import-rpool.service"
      ];
      requiredBy = [ "initrd.target" ];
      before = [
        "sysroot.mount"
      ];
      path = with pkgs; [
        zfs
      ];
      unitConfig = {
        DefaultDependencies = "no";
        ConditionKernelCommandLine = [ "!zfs_no_rollback" ];
      };
      serviceConfig.Type = "oneshot";

      script = ''
        zfs rollback -r rpool/nixos/empty@start
      '';
    };
  };
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-partlabel/";

  fileSystems."/" =
    {
      device = "rpool/nixos/empty";
      fsType = "zfs";
      options = [ "X-mount.mkdir" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/.root" =
    {
      device = "rpool/nixos/root";
      fsType = "zfs";
      options = [ "X-mount.mkdir" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/home" =
    {
      device = "rpool/nixos/home";
      fsType = "zfs";
      options = [ "X-mount.mkdir" "relatime" ];
      neededForBoot = true;
    };

  fileSystems."/var/lib" =
    {
      device = "rpool/nixos/var/lib";
      fsType = "zfs";
      options = [ "X-mount.mkdir" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/var/log" =
    {
      device = "rpool/nixos/var/log";
      fsType = "zfs";
      options = [ "X-mount.mkdir" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/nix" =
    {
      device = "/.root/nix";
      fsType = "none";
      options = [ "bind" "X-mount.mkdir" "noatime" ];
    };

  fileSystems."/etc/nixos" =
    {
      device = "/.root/etc/nixos";
      fsType = "none";
      options = [ "bind" "X-mount.mkdir" "noatime" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-partlabel/EFI";
      options = [ "X-mount.mkdir" "noatime" ];
      fsType = "vfat";
    };

  swapDevices =
    [{
      device = "/dev/disk/by-partlabel/swap";
      discardPolicy = "both";
      randomEncryption = {
        enable = true;
        allowDiscards = true;
      };
    }];

  environment.systemPackages = with pkgs; [
    powertop
  ];

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
