{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  #boot.kernelPackages = pkgs.linuxPackages_5_6;
  boot.kernelPatches = [
    {
      name = "add-acs-overrides";
      patch = ./add-acs-overrides_5_x.patch;
    }
  ];
  boot.tmpOnTmpfs = true;
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
  boot.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ];
  hardware.opengl.driSupport32Bit = true;

  services.xserver = {
    videoDrivers = [ "modesetting" ];
    useGlamor = true;
  };

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

  services.upower.enable = true;

  services.logind = {
    extraConfig = ''
      HandlePowerKey=suspend
      PowerKeyIgnoreInhibited=yes
    '';
  };
  services.tlp.enable = true;
}
