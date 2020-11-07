{ lib, pkgs, ... }:

lib.mkProfile "tools" {
  home.packages = with pkgs; [
    atool
    diskus
    du-dust
    fd
    hexyl
    hyperfine  # benchmark
    mc
    python3
    procs  # ps on steroids
    ranger
    # for emacs too
    ripgrep
    sd  # sed
    tokei  # loc
    unzip
    ytop  # top
    zenith  # top
    zip
  ];

  programs.bash.enable = true;
  programs.bat.enable = true;
  programs.broot.enable = true;
  programs.direnv.enable = true;
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = false;
  programs.htop.enable = true;
  programs.home-manager.enable = true;
  programs.jq.enable = true;
  #programs.keychain.enable = true;
  programs.lesspipe.enable = true;

  programs.mcfly.enable = true;
  programs.pazi.enable = true;
  #programs.mcfly.enableZshIntegration = false;
  #programs.zsh.initExtra = lib.mkAfter ''
  #  source ${pkgs.mcfly}/share/mcfly/mcfly.zsh
  #'';

  services.lorri.enable = true;
}
