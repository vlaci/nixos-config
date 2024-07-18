{ config, lib, ... }:

lib.mkMerge [
  {
    security.doas = {
      enable = true;
      extraRules = [
        { groups = [ "wheel" ]; persist = true; keepEnv = true; }
      ];
    };
    security.sudo.enable = false;

    programs._1password.enable = true;
    _.users.forAllUsers.persist.directories = [
      ".config/op"
    ];
  }
  (lib.mkIf config._.gui.enable {
    programs._1password-gui.enable = true;
    _.users.forAllUsers.persist.directories = [
      ".config/1Password"
    ];

    environment.etc = {
      "1password/custom_allowed_browsers" = {
        text = ''
          vivaldi-bin
        '';
        mode = "0755";
      };
    };
  })
]
