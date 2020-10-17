{ self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, ... }@inputs:

let
  defaultModules = [
    home-manager.nixosModules.home-manager
    nixpkgs.nixosModules.notDetected

    ../modules/nixos
    ({ config, lib, ... }: {
      nix.nixPath = [
        "home-manager=${home-manager}"
        "nixpkgs=${nixpkgs}"
      ];
      nixpkgs.overlays = [
        self.overlay
        (self: super: {
          inherit lib;
        })
      ];
      _.home-manager.forAllUsers = { config, ...}: {
        _module.args = inputs;
        nixpkgs.overlays = [
          self.overlay
          #(self: super: {
          #  lib = super.lib.extend (self: super: (import ../lib) { lib = super; });
          #})
        ];
      };
      _.home-manager.defaultUser = {
        imports = [ ../modules/home ];
      };
    })
  ];

  nixos = { modules, ...}@args: nixpkgs.lib.nixosSystem ({
    system = "x86_64-linux";
    specialArgs = {
      lib = nixpkgs.lib.extend (self: super: (import ../lib) { lib = super; });
    };
    modules = defaultModules ++ modules;
  } // (builtins.removeAttrs args [ "modules" ]));

in
{
  razorback = nixos {
    modules = [
      ./razorback
      ./razorback/hardware-configuration.nix
      ./razorback/hardware-customization.nix
      (nixos-hardware + "/common/cpu/intel")
      (nixos-hardware + "/common/pc/ssd")
      (nixos-hardware + "/common/pc/laptop/acpi_call.nix")
    ];
  };

  iso = nixos {
    modules = let
      iso = { modulesPath, pkgs, lib, ... }: {
        imports = [
          "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
        ];

        isoImage.makeEfiBootable = true;
        isoImage.makeUsbBootable = true;
        isoImage.isoName = lib.mkForce "nixos.iso";
        nix.package = pkgs.nixUnstable;
        nix.extraOptions = ''
          experimental-features = nix-command flakes
        '';
        environment.systemPackages = let
          prep = pkgs.writeShellScriptBin "prep" ''
            swapon /dev/mapper/vg-swap
            mount -oremount,size=7G /nix/.rw-store/
            mount /dev/mapper/vg-root /mnt/
            mkdir -p /mnt/boot /mnt/etc/nixos
            mount /dev/vda1 /mnt/boot/
            mount nixos-config -t9p -otrans=virtio /mnt/etc/nixos/
            nixos-install --flake path:/mnt/etc/nixos#vm
          '';
        in
          [ pkgs.jq prep ];
      };
    in [
      iso
    ];
  };

  /*
    Install commands:

        mount /dev/mapper/vg-root /mnt/
        mount /dev/vda1 /mnt/boot/
        swapon /dev/mapper/vg-swap
        mount nixos-config -t9p -otrans=virtio /mnt/etc/nixos/
        mount -oremount,size=7G /nix/.rw-store/
        /mnt/etc/nixos/scripts/nixos-install --flake path:/mnt/etc/nixos#vm
  */
  vm = nixos {
    modules = let
      qemu-guest = { modulesPath, config, lib, pkgs, ... }: {
        imports =
          [ "${modulesPath}/profiles/qemu-guest.nix"
          ];

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

        # services.xserver.videoDrivers = [ "qxl" ];
        # services.xserver.modules = [ pkgs.xorg.xf86videoqxl ];
         services.qemuGuest.enable = true;
        services.spice-vdagentd.enable = true;

        fileSystems."/" =
          { device = "/dev/mapper/vg-root";
            fsType = "xfs";
          };

        fileSystems."/boot" =
          { device = "/dev/disk/by-partlabel/EFI\\x20System";
            fsType = "vfat";
          };

        fileSystems."/etc/nixos" =
          { device = "nixos-config";
            fsType = "9p";
            options = [ "trans=virtio" ];
          };
        swapDevices =
          [ { device = "/dev/mapper/vg-swap"; }
          ];

        nix.maxJobs = lib.mkDefault 2;
      };
    in [
      qemu-guest
      ./razorback
    ];
  };
}
