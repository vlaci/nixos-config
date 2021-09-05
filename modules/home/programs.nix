{ lib, config, pkgs, ... }:

let
  inherit (lib) mkProfile optionals;
in mkProfile "tools" {
  home.packages = with pkgs; ([
    atool
    bottom # top
    cntr
    diskus
    du-dust
    fd
    hexyl
    hyperfine # benchmark
    mc
    procs # ps on steroids
    python39
    ranger
    # for emacs too
    ripgrep
    sd # sed
    tokei # loc
    unzip
    zenith # top
    zip
  ] ++ optionals config._.gui.enable [
    libreoffice-fresh
  ]);

  programs.bash.enable = true;
  programs.bat.enable = true;
  programs.broot.enable = true;
  programs.direnv.enable = true;
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = false;
  programs.htop.enable = true;
  programs.home-manager.enable = true;
  programs.jq.enable = true;
  programs.lesspipe.enable = true;

  programs.mcfly.enable = true;
  programs.mcfly.enableZshIntegration = true;

  programs.pazi.enable = true;

  services.lorri.enable = true;
}
