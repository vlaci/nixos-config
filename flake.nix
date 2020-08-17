{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.03";
    home-manager.url = "github:rycee/home-manager/bqv-flakes";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
    in
      {
        nixosConfigurations = import ./hosts (inputs // { inherit inputs system; });
        devShell."${system}" = import ./shell.nix { inherit (nixpkgs.legacyPackages."${system}") pkgs; };
      };
}
