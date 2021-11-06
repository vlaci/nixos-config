{ modulesPath, pkgs, lib, ... }: {

  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  _.users.enable = false;
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
  isoImage.isoName = lib.mkForce "nixos.iso";
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  environment.systemPackages =
    let
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
    [ prep ];
}
