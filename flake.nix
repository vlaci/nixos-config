{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:vlaci/nixpkgs";
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware";
    emacsVlaci.url = "sourcehut:~vlaci/emacs-config";
    emacsVlaci.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    git-agecrypt.url = "github:vlaci/git-agecrypt";
    git-agecrypt.inputs.nixpkgs.follows = "nixpkgs";
    git-agecrypt.inputs.flake-utils.follows = "flake-utils";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    stylix.url = "github:danth/stylix";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    onepassword-shell-plugins.url = "github:1Password/shell-plugins";
  };

  outputs = { self, nixpkgs, lix-module, home-manager, flake-utils, emacsVlaci, git-agecrypt, hyprland, disko, impermanence, stylix, nix-index-database, onepassword-shell-plugins, ... }@inputs:
    let
      inherit (flake-utils.lib) eachDefaultSystem;

      lib = nixpkgs.lib.extend (self: super: (import ./lib) { lib = super; });
      mkPkgs = system: import nixpkgs { inherit system; overlays = lib.attrValues self.overlays; };

      system = "x86_64-linux";

      nixosConfigurations = lib.nixosConfigurations ({
        inherit lib system;
        hmModules = [ emacsVlaci.homeManagerModules.default hyprland.homeManagerModules.default impermanence.nixosModules.home-manager.impermanence onepassword-shell-plugins.hmModules.default ];
        nixosModules = [ lix-module.nixosModules.default home-manager.nixosModules.home-manager hyprland.nixosModules.default disko.nixosModules.disko impermanence.nixosModules.impermanence stylix.nixosModules.stylix nix-index-database.nixosModules.nix-index ];
      } // inputs);
    in
    {
      inherit lib;
      nixosConfigurations = nixosConfigurations.hostsFromDir ./hosts;
      overlays = lib.importDir ./overlays // {
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
      }
    );
}
