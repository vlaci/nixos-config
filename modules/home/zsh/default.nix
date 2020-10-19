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

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh


      #
      # ks       make the keypad send commands
      # ke       make the keypad send digits
      # vb       emit visual bell
      # mb       start blink
      # md       start bold
      # me       turn off bold, blink and underline
      # so       start standout (reverse video)
      # se       stop standout
      # us       start underline
      # ue       stop underline

      LESS_TERMCAP_md=$(tput bold; tput setaf 4)
      LESS_TERMCAP_me=$(tput sgr0)
      LESS_TERMCAP_mb=$(tput blink)
      LESS_TERMCAP_us=$(tput setaf 2)
      LESS_TERMCAP_ue=$(tput sgr0)
      LESS_TERMCAP_so=$(tput smso)
      LESS_TERMCAP_se=$(tput rmso)
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
        name = "fast-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma";
          repo = "fast-syntax-highlighting";
          rev = "v1.55";
          sha256 = "019hda2pj8lf7px4h1z07b9l6icxx4b2a072jw36lz9bh6jahp32";
        };
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
    };
  };

  home.file."${dotDir}/.p10k.zsh".source = ./p10k.zsh;
}
