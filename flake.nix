{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-unstable.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs/develop";
    openconnect-sso.url = "github:vlaci/openconnect-sso";
    openconnect-sso.flake = false;
    emacsVlaci.url = "github:vlaci/emacs.d";
    emacsVlaci.inputs.nixpkgs.follows = "nixpkgs";
    github-nvim-theme.url = "github:projekt0n/github-nvim-theme";
    github-nvim-theme.flake = false;

    pkgsrcs.url = "path:./pkgs";
    pkgsrcs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, pkgsrcs, home-manager, flake-utils, nix-doom-emacs, openconnect-sso, emacsVlaci, ... }@inputs:
    let
      inherit (flake-utils.lib) eachDefaultSystem;

      lib = nixpkgs.lib.extend (self: super: (import ./lib) { lib = super; });
      system = "x86_64-linux";
      nixosConfigurations = lib.nixosConfigurations ({
        inherit lib system;
        hmModules = [ nix-doom-emacs.hmModule emacsVlaci.lib.hmModule ];
        nixosModules = [ home-manager.nixosModules.home-manager ];
      } // inputs);
    in
    {
      nixosConfigurations = nixosConfigurations.hostsFromDir ./hosts;
      overlay = final: prev:
        let
          unstable = inputs.nixpkgs-unstable.legacyPackages."${final.system}";
        in
        {
          _ = { inherit unstable; };
          inherit lib;
          myVimPlugins.github-nvim-theme = final.vimUtils.buildVimPlugin {
            name = "github-nvim-theme";
            src = inputs.github-nvim-theme;
            doCheck = false;  # lua-format
            buildPhase = ":";
          };
        };

      overlays = lib.importDir ./overlays // {
        openconnect-sso = import "${openconnect-sso}/overlay.nix";
        emacsVlaci = emacsVlaci.overlay;
        pkgsrcs = pkgsrcs.overlay;
        inherit (self) overlay;
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
          machine = {
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
        pkgs = import nixpkgs { inherit system; overlays = lib.attrValues self.overlays; };
      in
      {
        packages = (import ./pkgs { inherit pkgs; });
        devShell = import ./shell.nix { inherit pkgs; };

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
