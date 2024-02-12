{ pkgs, lib, ... }:

lib.mkProfile "nushell" {
  programs.nushell = {
    enable = true;
    configFile.source = pkgs.runCommand "config-nu" { } ''
      echo "source ${./config.nu}" > $out
      for f in ${pkgs.nu-scripts}/custom-completions/*/*.nu; do
        if [[ $f == *fish* ]]; then
          continue
        fi
        echo "use $f *" >> $out
      done
    '';
    envFile.source = ./env.nu;
  };
}
