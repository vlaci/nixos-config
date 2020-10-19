{ lib, pkgs, ... }:

lib.mkProfile "tools" {
  home.packages = with pkgs; [
    atool
    diskus
    du-dust
    fd
    hyperfine
    sd
    tokei
    ytop
    zenith
    mc
    ranger
    unzip
    zip
    # for emacs too
    ripgrep
  ];

  programs.bash.enable = true;
  programs.bat.enable = true;
  programs.direnv.enable = true;
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = false;
  programs.htop.enable = true;
  programs.home-manager.enable = true;
  programs.jq.enable = true;
  #programs.keychain.enable = true;
  programs.lesspipe.enable = true;

  programs.mcfly.enable = true;
  #programs.mcfly.enableZshIntegration = false;
  #programs.zsh.initExtra = lib.mkAfter ''
  #  source ${pkgs.mcfly}/share/mcfly/mcfly.zsh
  #'';

  programs.zoxide.enable = true;

  services.lorri.enable = true;
}
