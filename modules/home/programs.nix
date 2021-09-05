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

  xdg.configFile."ripgreprc".text = ''
    --smart-case
    --no-heading
  '';

  home.sessionVariables."RIPGREP_CONFIG_PATH" = "${config.xdg.configHome}/ripgreprc";

  programs.bash.enable = true;
  programs.bat.enable = true;
  programs.broot.enable = true;
  programs.direnv.enable = true;
  programs.htop.enable = true;
  programs.home-manager.enable = true;
  programs.jq.enable = true;
  programs.lesspipe.enable = true;

  programs.mcfly.enable = true;
  programs.mcfly.enableZshIntegration = true;

  programs.pazi.enable = true;

  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "600";
  };

  services.lorri.enable = true;
}
