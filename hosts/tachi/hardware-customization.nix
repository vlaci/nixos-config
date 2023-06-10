{ config, pkgs, ... }:

{
  services.hardware.bolt.enable = true;
  services.fwupd.enable = true;
  services.throttled = {
    enable = true;
    extraConfig = with builtins; (
      replaceStrings
        [ "# HWP_Mode: False" ]
        [ "HWP_Mode: True" ]
        (readFile "${pkgs.throttled}/etc/throttled.conf")
    );
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{authorized}=="0", ATTR{authorized}="1"
  '';

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.tmp.useTmpfs = true;
  boot.kernelParams = [ "mitigations=off" "intel_iommu=on" "msr.allow_writes=on" "psmouse.synaptics_intertouch=0" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ];

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
