{ config, lib, pkgs, ... }: with lib;

let
  cfg = config._.doom-emacs;
in {
  options._.doom-emacs = {
    enable = mkEnableOption "Doom Emacs configuration";
    doomPrivateDir = mkOption {
      description = ''
        Directory containing customizations, `init.el`, `config.el` and `packages.el`
      '';
    };
    extraConfig = mkOption {
      description = "Extra configuration options to pass to doom-emacs";
      type = with types; lines;
      default = "";
    };
    spellCheckDictionaries = mkOption {
      description = "Use these dictionaries for spell-checking";
      type = with types; listOf package;
      default = [];
    };
  };

  config = mkIf cfg.enable (let
    extraConfig = let
      hunspell = pkgs.hunspellWithDicts cfg.spellCheckDictionaries;
      languages = lib.concatMapStringsSep "," (dct: dct.dictFileName) cfg.spellCheckDictionaries;
    in ''
      ;; Pull from PRIMARY (same as middle mouse click)
      (defun paste-primary-selection ()
        (interactive)
        (insert
        (x-get-selection 'PRIMARY)))
      (global-set-key (kbd "S-<insert>") 'paste-primary-selection)
      (setq ispell-program-name "${hunspell}/bin/hunspell"
            ispell-dictionary "${languages}")
      (after! ispell
        (ispell-set-spellchecker-params)
        (ispell-hunspell-add-multi-dic ispell-dictionary))
      ${cfg.extraConfig}
    '';
  in {
    programs.doom-emacs = {
      enable = true;
      doomPrivateDir = ./doom.d;
      inherit extraConfig;
    };
    home.packages = with pkgs; [
      python3Packages.grip
      nodePackages.bash-language-server
      shellcheck
      ghc
    ];
  });
}
