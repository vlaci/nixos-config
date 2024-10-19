{ lib, pkgs, ... }:

{
  services.hardware.bolt.enable = true;
  services.fwupd.enable = true;
  services.throttled = {
    enable = true;
    extraConfig =
      with builtins;
      (replaceStrings
        [
          "# HWP_Mode: False"
          "cTDP: 0"
        ]
        [
          "HWP_Mode: True"
          "cTDP: 2"
        ]
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
  boot.kernelParams = [
    "mitigations=off"
    "intel_iommu=on"
    "msr.allow_writes=on"
    "psmouse.synaptics_intertouch=0"
  ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.graphics.extraPackages = with pkgs; [ intel-media-driver ];

  services.xserver.videoDrivers = [ "modesetting" ];

  services.fstrim.enable = true;

  networking.hostId = "7d185cbc";

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
      wantedBy = [ "zfs.target" ];
      before = [ "sysroot.mount" ];
      path = with pkgs; [
        coreutils
        zfs
      ];
      unitConfig = {
        DefaultDependencies = "no";
        ConditionKernelCommandLine = [ "!zfs_no_rollback" ];
      };
      serviceConfig.Type = "oneshot";

      script = ''
        zfs rollback -r rpool/tachi/root@blank
      '';
    };
    services.zfs-import-rpool.after = [ "cryptsetup.target" ];
    services.create-needed-for-boot-dirs.after = lib.mkForce [ "revert-root.service" ];
  };

  disko.devices = (import ./disko-config.nix { disks = [ "/dev/nvme0n1" ]; }).disko.devices;

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
