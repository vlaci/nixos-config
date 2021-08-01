{ config, lib, pkgs, system, nixpkgs, ... }:

let
  dotDir = ".config/zsh";
in

{
  programs.zsh = lib.mkMerge [
    {
      # grml configuration should be loaded before any other customization
      # That way any defaults set by it can be overriden in subsequent
      # initExtra assignments
      initExtra = lib.mkBefore ''
        source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
      '';
    }
    {
      # powerlevel stuff should come at the very end because the instant prompt stuff
      # may skip execution of the code after it.
      initExtra = lib.mkAfter ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        function prompt_git_useremail() {
          p10k segment -t "$(git_prompt_useremail_symbol)"
        }
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh

        export ZSH_PLUGINS_ALIAS_TIPS_TEXT="💡 Alias: "
      '';
    }
    {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = false;
      enableVteIntegration = true;
      inherit dotDir;
      history = {
        expireDuplicatesFirst = true;
        extended = true;
        ignoreSpace = true;
        path = "$HOME/${dotDir}/.zsh_history";
      };
      plugins = [
        {
          name = "command_not_found";
          src = pkgs.runCommand "plugin"
            {
              inherit nixpkgs system;
              inherit (pkgs) sqlite;
              plugin = ./plugins/command_not_found/command_not_found.plugin.zsh;
            } ''
            mkdir $out
            substituteAll $plugin $out/command_not_found.plugin.zsh
          '';
        }
        {
          name = "colors";
          src = ./plugins/colors;
        }
        {
          name = "doas";
          src = ./plugins/doas;
        }
        {
          name = "navigate";
          src = ./plugins/navigate;
        }
        {
          name = "alias-tips"; # Depends: python
          src = pkgs.pkgsrcs.zsh-alias-tips;
        }
        {
          name = "calc";
          src = pkgs.pkgsrcs.zsh-calc;
        }
        {
          name = "git-prompt-useremail";
          src = pkgs.pkgsrcs.zsh-git-prompt-useremail;
        }
        {
          name = "fast-syntax-highlighting";
          src = pkgs.pkgsrcs.zsh-fast-syntax-highlighting;
        }
      ];
      shellAliases = {
        sshn = "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no";
        scpn = "scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no";
        fd = "noglob fd";
        find = "noglob find";
        gg = "git grep -ni";
        gco = "git checkout";
        gcp = "git cherry-pick";
        glg = "git log --stat";
        grb = "git rebase";
        gst = "git status";
        gb = "git branch";
        ec = "emacsclient";
        ecw = "emacsclient -c";
      };
    }
  ];

  home.file."${dotDir}/.p10k.zsh".source = ./p10k.zsh;
}
