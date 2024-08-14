{ pkgs, lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      keep-outputs = true;
      keep-env-derivations = true;
      keep-derivations = true;
      trusted-users = [ "root" "@wheel" ];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };


  programs.command-not-found.enable = false;
  programs.nix-index-database.comma.enable = true;

  system.activationScripts.diff = ''
    if [[ -L /run/current-system ]]; then
      PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
      echo
      echo =================================  [ Changes ]  =================================
      ${pkgs.nvd}/bin/nvd diff /run/current-system "$systemConfig"
      echo =================================================================================
      echo
    fi
  '';

  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;
}
