{ self, nixpkgs, home-manager, nixos-hardware, ... }:

let
  defaultModules = [
    (home-manager + "/nixos")
    nixpkgs.nixosModules.notDetected

    ../modules/nixos
    {

      nix.nixPath = [
        "home-manager=${home-manager}"
        "nixpkgs=${nixpkgs}"
      ];
      nixpkgs.overlays = [ self.overlay ];
      _.home-manager.forAllUsers.nixpkgs.overlays = [ self.overlay ];
    }
  ];

in
{
  razorback = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = defaultModules ++ [
      ./razorback
      (nixos-hardware + "/common/cpu/intel")
      (nixos-hardware + "/common/pc/ssd")
      (nixos-hardware + "/common/pc/laptop/acpi_call.nix")
    ];
  };
}
