{ lib, nixosConfig, ... }:

let
  inherit (lib) mkIf mkProfile;
  inherit (nixosConfig._.secrets) vlaci;
in
mkProfile "jujutsu" (
  mkIf vlaci.available {
    programs.jujutsu = {
      enable = true;
      settings.user = {
        name = vlaci.value.fullName;
        email = vlaci.value.git.home.address;
      };
    };
  }
)
