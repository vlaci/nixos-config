{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:rycee/home-manager";
    home-manager.flake = false;
    mozilla.url = "github:mozilla/nixpkgs-mozilla";
    mozilla.flake = false;
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.03";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, home-manager, mozilla, flake-utils, ... }@inputs:
    let
      inherit (flake-utils.lib) eachDefaultSystem;
    in
      {
        nixosConfigurations = import ./hosts inputs;
        overlay = final: prev:
          let
            pkgs = prev;
            callPackage = pkgs.newScope prev;
            mozilla = import (inputs.mozilla + "/package-set.nix") { pkgs = prev; };
            unstable = inputs.nixpkgs-unstable.legacyPackages."${pkgs.system}";
          in {
            _ = { inherit mozilla unstable; };
        };

        checks."x86_64-linux" =
          with import (nixpkgs + "/nixos/lib/testing-python.nix") {
            system = "x86_64-linux";
          };  let
                user = "testuser";
              in {
            default-user = makeTest {
              machine = {
                imports = [
                  ./modules/nixos
                ];
                _.defaultUser = {
                  name = user;
                  fullName = user;
                  hashedPassword = "$6$batdZbDtVk4FIJ$OBueySbHgfx3PGyi/yT3Ur7ydEP/LcX5pRHd7a43wTihY9naCnk6ByCVYY9wXmfj41eAc/Yt/QNEVJcApfInr1";
                };
              };
              testScript = ''
                machine.succeed("id ${user}")
              '';
            };
          };
      } // eachDefaultSystem (
        system: {
          devShell = import ./shell.nix { inherit (nixpkgs.legacyPackages."${system}") pkgs; };
        }
      );
}
