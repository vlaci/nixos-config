{ config, lib, pkgs, nix-doom-emacs, ... }: with lib;

let
  cfg = config._.doom-emacs;
in {
  options._.doom-emacs = {
    enable = mkEnableOption "Doom Emacs configuration";
    doomPrivateDir = mkOption {
      description = ''
        Directory containing customizations, `init.el`, `config.el` and `packages.el`
      '';
      default = ./doom.d;
    };
    extraConfig = mkOption {
      description = "Extra configuration options to pass to doom-emacs";
      type = with types; lines;
      default = "";
    };
    extraPackages = mkOption {
      description = "Extra packages to install";
      type = with types; listOf package;
      default = [];
    };
    spellCheckDictionaries = mkOption {
      description = "Use these dictionaries for spell-checking";
      type = with types; listOf package;
      default = [];
    };
    package = mkOption {
      internal = true;
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
    #emacs = pkgs.callPackage (builtins.fetchTarball {
    #  url = https://github.com/vlaci/nix-doom-emacs/archive/develop.tar.gz;
    #}) {
    emacs = pkgs.callPackage nix-doom-emacs {
      extraPackages = (epkgs: cfg.extraPackages);
      inherit (cfg) doomPrivateDir; inherit extraConfig;
    };
  in {
    home.file.".emacs.d/init.el".text = ''
      (load "default.el")
      (after! lsp-mode
        (setq lsp-csharp-server-path "omnisharp")
        (lsp-register-client
        (make-lsp-client :new-connection (lsp-stdio-connection
                                          #'lsp-csharp--language-server-command
                                          )

                          :major-modes '(csharp-mode)
                          :server-id 'csharp
                          )))
    '';
    home.packages = with pkgs; [
      ghc
      python3Packages.grip
      nodePackages.bash-language-server
      shellcheck
    ];
    programs.emacs.package = emacs;
    programs.emacs.enable = true;
    _.doom-emacs.package = emacs;
  });
}
