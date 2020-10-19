{ config, lib, pkgs, ... }:

let
  dotDir = ".config/zsh";
in {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = false;
    inherit dotDir;
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
      source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh

      export ZSH_PLUGINS_ALIAS_TIPS_TEXT="💡 Alias: "
      alias gst="git status"
    '';
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreSpace = true;
      path = "${dotDir}/.zsh_history";
    };
    plugins = [
      {
        name = "colors";
        src = ./plugins;
      }
      {
        name = "alias-tips";  # Depends: python
        src = pkgs.fetchFromGitHub {
          owner = "djui";
          repo = "alias-tips";
          rev = "40d8e206c6d6e41e039397eb455bedca578d2ef8";
          sha256 = "17cifxi4zbzjh1damrwi2fyhj8x0y2m2qcnwgh4i62m1vysgv9xb";
        };
      }
      {
        name = "calc";
        src = pkgs.fetchFromGitHub {
          owner = "arzzen";
          repo = "calc.plugin.zsh";
          rev = "ea59bc2bfd1d2791de539c31c0c544d4dc16dad6";
          sha256 = "0as30w1na8idrkxifim44ky0521r93r2qm201qnnl6by2qbmbiqv";
        };
      }
      {
        name = "git-prompt-useremail";
        src = pkgs.fetchFromGitHub {
          owner = "mroth";
          repo = "git-prompt-useremail";
          rev = "902541b73a23061e6cbeb889e0a7f179a87d047e";
          sha256 = "1n543rjrjv6kby42pvgvn9n3dwk298pk1wkgajapbalfrlialg4m";
        };
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma";
          repo = "fast-syntax-highlighting";
          rev = "v1.55";
          sha256 = "019hda2pj8lf7px4h1z07b9l6icxx4b2a072jw36lz9bh6jahp32";
        };
      }
    ];
  };

  home.file."${dotDir}/.p10k.zsh".source = ./p10k.zsh;
  home.packages = [ pkgs.nix-zsh-completions ];
}
