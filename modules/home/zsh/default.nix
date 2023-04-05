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
        if [[ "$TERM" = dumb ]]; then
            unsetopt zle prompt_cr prompt_subst
            return
        fi
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        prompt_git_useremail() {
          p10k segment -t "$(git_prompt_useremail_symbol)"
        }

        export ZSH_PLUGINS_ALIAS_TIPS_TEXT="󱍄 Alias: "

        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
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
              nix_index = pkgs.nix-index;
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
          name = "up";
          src = pkgs.runCommand "plugin"
            {
              inherit (pkgs) up;
              plugin = ./plugins/up/up.plugin.zsh;
            } ''
            mkdir $out
            substituteAll $plugin $out/up.plugin.zsh
          '';
        }
        {
          name = "alias-tips"; # Depends: python
          src = pkgs.runCommand "plugin"
            {
              plugin = pkgs.pkgsrcs.zsh-alias-tips.src;
            } ''
            cp -a $plugin $out
            substituteInPlace $out/alias-tips.plugin.zsh --replace python3 ${pkgs.python3}/bin/python
          '';
        }
        {
          name = "calc";
          inherit (pkgs.pkgsrcs.zsh-calc) src;
        }
        {
          name = "git-prompt-useremail";
          inherit (pkgs.pkgsrcs.zsh-git-prompt-useremail) src;
        }
        {
          name = "fast-syntax-highlighting";
          inherit (pkgs.pkgsrcs.zsh-fast-syntax-highlighting) src;
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
        nix = "noglob nix";
        rg = "noglob rg";
      };
    }
  ];

  home.file."${dotDir}/.p10k.zsh".source = ./p10k.zsh;
  home.packages = with pkgs; [
    meslo-lgs-nf
  ];
}
