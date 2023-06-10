{ pkgs, lib, ... }:

lib.mkProfile "nushell" {
  programs.nushell = {
    enable = true;
    configFile.text = ''
      source ${./config.nu}
      use ${pkgs.nu-scripts}/custom-completions/bitwarden-cli/bitwarden-cli-completions.nu *
      use ${pkgs.nu-scripts}/custom-completions/btm/btm-completions.nu *
      use ${pkgs.nu-scripts}/custom-completions/cargo/cargo-completions.nu *
      use ${pkgs.nu-scripts}/custom-completions/git/git-completions.nu *
      use ${pkgs.nu-scripts}/custom-completions/just/just-completions.nu *
      use ${pkgs.nu-scripts}/custom-completions/make/make-completions.nu *
      use ${pkgs.nu-scripts}/custom-completions/npm/npm-completions.nu *
      use ${pkgs.nu-scripts}/custom-completions/poetry/poetry-completions.nu *
      use ${pkgs.nu-scripts}/custom-completions/yarn/yarn-completion.nu *
      use ${pkgs.nu-scripts}/custom-completions/zellij/zellij-completions.nu *
    '';
    envFile.source = ./env.nu;
  };
}
