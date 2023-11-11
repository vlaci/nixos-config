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
        mount nixos-config -t9p -otrans=virtio /etc/nixos/
      '';
      run-disko = pkgs.writeShellScriptBin "run-disko" ''
        disko -m disko /etc/nixos/hosts/razorback/disko-config.nix --arg disks '[ "/dev/vda" ]'
      '';
    in
    with pkgs; [ prep run-disko disko zellij ];
}
