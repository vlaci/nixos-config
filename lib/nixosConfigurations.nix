{
  self,
  lib,
  nixpkgs,
  hmModules,
  nixosModules,
  specialArgs ? { },
  system,
  ...
}@args:

let
  inputs = lib.filterAttrs (n: v: v ? outputs) args;

  defaultModules = nixosModules ++ [
    nixpkgs.nixosModules.notDetected
    ../modules/nixos

    (
      { config, lib, ... }:
      {
        nix.nixPath = [
          "nixpkgs=${nixpkgs}"
          "nixpkgs-overlays=${toString ../overlays}"
        ];

        nix.registry = builtins.mapAttrs (n: i: { flake = i; }) inputs;

        nixpkgs.overlays = lib.attrValues self.overlays;
        _.home-manager.forAllUsers =
          { config, ... }:
          {
            _module.args = inputs;
            imports = hmModules ++ [ ../modules/home ];
          };
      }
    )
  ];

  nixosSystem =
    host:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit lib;
      } // inputs // specialArgs;
      modules = defaultModules ++ [
        host
      ];
    };

  hostsFromDir =
    dir:
    let
      hosts = lib.readModulesFromDir dir;
    in
    builtins.listToAttrs (
      map (host: lib.nameValuePair (lib.removeSuffix ".nix" host) (nixosSystem (dir + "/${host}"))) hosts
    );
in
{
  inherit hostsFromDir defaultModules;
}
