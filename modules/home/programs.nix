{ lib, config, pkgs, ... }:

let
  inherit (lib) mkProfile optionals;
in
mkProfile "tools" {
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
    python311
    ranger
    # for emacs too
    ripgrep
    rm-improved
    sd # sed
    tokei # loc
    unzip
    zenith # top
    zip
    watchexec
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
  programs.direnv.nix-direnv.enable = true;
  programs.htop.enable = true;
  programs.home-manager.enable = true;
  programs.jq.enable = true;
  programs.lesspipe.enable = true;

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      filter_mode = "directory";
      style = "compact";
      inline_height = 30;
      show_preview = true;
    };
  };

  programs.readline.enable = true;
  programs.zoxide.enable = true;
  programs.skim.enable = true;

  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
    serverAliveInterval = 300;
  };

  _.persist = {
    directories = [
      ".local/share/direnv"
      ".local/share/zoxide"
    ];
    files = [ ".ssh/known_hosts" ];
  };
}
