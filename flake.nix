{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.03";
  inputs.home.url = "github:rycee/home-manager/bqv-flakes";

  outputs = { self, nixpkgs, home }:
    let
      system = "x86_64-linux";
    in
      {
        nixosConfigurations.razorback = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules =
            [
              (
                { pkgs, ... }: {
                  boot.isContainer = true;

                  # Let 'nixos-version --json' know about the Git revision
                  # of this flake.
                  system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

                }
              )
            ];
        };

        devShell."${system}" = import ./shell.nix { inherit (nixpkgs.legacyPackages."${system}") pkgs; };
      };
}
