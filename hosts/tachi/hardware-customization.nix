{ config, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.tmpOnTmpfs = true;
  boot.kernelParams = [ "mitigations=off" "intel_iommu=on" "msr.allow_writes=on" ];

  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ];

  #services.uvcvideo.dynctrl.enable = true;
  services.xserver = {
    videoDrivers = [ "modesetting" ];
    useGlamor = true;
  };

  services.fstrim.enable = true;

  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/4533dfe8-6714-4841-93cd-c3421ac4a201";
    preLVM = true;
    allowDiscards = true;
  };

  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  environment.systemPackages = with pkgs; [
    brightnessctl
    powertop
    blueman
  ];

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_HWP_ON_AC = "balance_performance";
      CPU_HWP_ON_BAT = "power";
    };
  };
  services.upower.enable = true;

  services.logind = {
    lidSwitch = "ignore";
    extraConfig = ''
      HandlePowerKey=suspend
      PowerKeyIgnoreInhibited=yes
    '';
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;
  hardware.enableAllFirmware = true;

  boot.extraModprobeConfig = ''
    options i915 enable_guc=1
    options hid_apple swap_opt_cmd=1 fnmode=0
    options kvm_intel nested=1
  '';
}
