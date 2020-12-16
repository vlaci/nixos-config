{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:rycee/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs/develop";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, nix-doom-emacs, ... }@inputs:
    let
      inherit (flake-utils.lib) eachDefaultSystem;
    in
      {
        nixosConfigurations = import ./hosts inputs;
        overlay = final: prev:
          let
            unstable = inputs.nixpkgs-unstable.legacyPackages."${final.system}";
          in {
            _ = { inherit unstable; };
          };

        overlays = [
          (import nix-doom-emacs.inputs.emacs-overlay)
          (import overlays/nix-zsh-completions.nix)
          self.overlay
        ];

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
        system: let
            pkgs = import nixpkgs { inherit system; overlays = self.overlays; };
          in {
            packages = pkgs;
            devShell = import ./shell.nix { inherit pkgs; };
          }
      );
}
