{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:vlaci/nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    emacsVlaci.url = "github:vlaci/emacs.d";
    emacsVlaci.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    git-agecrypt.url = "github:vlaci/git-agecrypt";
    git-agecrypt.inputs.nixpkgs.follows = "nixpkgs";
    git-agecrypt.inputs.flake-utils.follows = "flake-utils";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hy3.url = "github:outfoxxed/hy3";
    hy3.inputs.hyprland.follows = "hyprland";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    stylix.url = "github:danth/stylix";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, emacsVlaci, git-agecrypt, hyprland, hy3, disko, impermanence, stylix, nix-index-database, ... }@inputs:
    let
      inherit (flake-utils.lib) eachDefaultSystem;

      lib = nixpkgs.lib.extend (self: super: (import ./lib) { lib = super; });
      mkPkgs = system: import nixpkgs { inherit system; overlays = lib.attrValues self.overlays; };

      system = "x86_64-linux";

      nixosConfigurations = lib.nixosConfigurations ({
        inherit lib system;
        hmModules = [ emacsVlaci.lib.hmModule hyprland.homeManagerModules.default impermanence.nixosModules.home-manager.impermanence ];
        nixosModules = [ home-manager.nixosModules.home-manager hyprland.nixosModules.default disko.nixosModules.disko impermanence.nixosModules.impermanence stylix.nixosModules.stylix nix-index-database.nixosModules.nix-index ];
      } // inputs);
    in
    {
      inherit lib;
      nixosConfigurations = nixosConfigurations.hostsFromDir ./hosts;
      overlays = lib.importDir ./overlays // {
        emacsVlaci = emacsVlaci.overlay;
        hyprland = hyprland.overlays.default;
        git-agecrypt = git-agecrypt.overlay;
        default = final: prev:
          let
            pkgsrcs = import ./pkgs {
              pkgs = prev;
            };
          in
          {
            inherit lib pkgsrcs;
            inherit (disko.packages.${final.system}) disko;
            inherit (hy3.packages.x86_64-linux) hy3;
          };
      };
      checks.${system} = with import (nixpkgs + "/nixos/lib/testing-python.nix")
        {
          inherit system;
          extraConfigurations = nixosConfigurations.defaultModules;
          specialArgs = { inherit lib; secrets = { }; };
        }; let
        user = "testuser";
      in
      {
        default = makeTest {
          nodes.machine = {
            _.users.users.${user} = {
              hashedPassword = "$6$batdZbDtVk4FIJ$OBueySbHgfx3PGyi/yT3Ur7ydEP/LcX5pRHd7a43wTihY9naCnk6ByCVYY9wXmfj41eAc/Yt/QNEVJcApfInr1";
              home-manager = { programs.git.enable = true; };
            };
          };
          testScript = ''
            machine.succeed("id ${user}")
            machine.succeed("command -v doas")
            machine.fail("command -v sudo")
          '';
        };
      };
    } // eachDefaultSystem (
      system:
      let
        pkgs = mkPkgs system;
      in
      {
        packages = (import ./pkgs { inherit pkgs; });
        devShell = import ./shell.nix { inherit pkgs; };
        legacyPackages = pkgs;

        apps.repl = flake-utils.lib.mkApp {
          drv = pkgs.writeShellScriptBin "repl" ''
            confnix=$(mktemp)
            echo "builtins.getFlake (toString $(git rev-parse --show-toplevel))" >$confnix
            trap "rm $confnix" EXIT
            nix repl $confnix
          '';
        };
      }
    );
}
