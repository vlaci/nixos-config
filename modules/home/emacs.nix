{ lib, config, ... }:

let
  cfg = config._.emacs;
  inherit (lib) mkEnableOption mkIf mkOption types;
in
{
  options = {
    _.emacs.enable = mkEnableOption "emacs";
    accounts.email.accounts = mkOption {
      type = with types; attrsOf (submodule ({ config, ... }:
        {
          options = {
            mu4e.extraConfig = mkOption { type = types.separatedString "\n"; default = ""; };
          };
        }
      ));
    };
  };

  config = mkIf cfg.enable {
    vl-emacs = {
      enable = true;
    };
    home.sessionVariables = {
      ALTERNATE_EDITOR = "";
      EDITOR = "emacsclient -t";
      VISUAL = "emacsclient -c -a emacs";
    };
    _.persist.directories = [
      ".config/emacs/var"
      ".config/enchant"
    ];
  };
}
