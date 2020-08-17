{ self, system, nixpkgs, inputs, ... }:

let
  inherit (nixpkgs.lib) attrNames filterAttrs genAttrs;

  config = hostname:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = let
        default =
            { pkgs, ... }: {

              # Let 'nixos-version --json' know about the Git revision
              # of this flake.
              system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            };
        in
        [
          nixpkgs.nixosModules.notDetected
          default
          (import "${toString ./.}/${hostname}")
        ];
      specialArgs = inputs;
    };
  hosts = let
    files = builtins.readDir ./.;
    dirs = filterAttrs (n: v: v == "directory") files;
  in
    attrNames dirs;
in
genAttrs hosts config
