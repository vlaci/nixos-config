{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_acs_override;
  boot.tmpOnTmpfs = true;
  boot.tmpOnTmpfsSize = "100%";
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

  boot.initrd.luks.devices.root = {
    name = "root";
    device = "/dev/disk/by-uuid/28172ac8-55d8-4d6b-93f9-b849aa46187c";
    preLVM = true;
    allowDiscards = true;
  };

  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

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
  services.tlp.enable = true;
}
