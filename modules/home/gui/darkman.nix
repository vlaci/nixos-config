{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.darkman;

  yamlFormat = pkgs.formats.yaml { };

  scriptsOptionType = kind:
    mkOption {
      type =
        types.attrsOf (types.oneOf [ types.path types.package types.lines ]);
      default = { };
      example = literalExpression ''
        {
          gtk-theme = '''
            ${pkgs.dconf}/bin/dconf write \
                /org/gnome/desktop/interface/color-scheme "'prefer-${kind}'"
          ''';
          my-python-script = pkgs.writeScript "my-python-script" '''
            #!''${pkgs.python3}/bin/python3

            print('Do something!')
          ''';
        }
      '';
      description = ''
        Scripts to run when switching to "${kind} mode".
        </para><para>
        Multiline strings are interpreted as shell scripts and a shebang is not required.
      '';
    };

  generateScripts = folder:
    mapAttrs' (k: v: {
      name = "${folder}/${k}";
      value = {
        source =
          if builtins.isPath v || isStorePath v || isDerivation v then
            v
          else
            pkgs.writeShellScript (hm.strings.storeFileName k) v;
      };
    });
in
{
  meta.maintainers = [ maintainers.xlambein ];

  options.services.darkman = {
    enable = mkEnableOption
      "darkman, a tool that automatically switches dark-mode on and off based on the time of the day";

    package = mkOption {
      type = types.package;
      default = pkgs.darkman;
      defaultText = literalExpression "pkgs.darkman";
      example = literalExpression "pkgs.darkman";
      description =
        "A package providing the <command>darkman</command> command.";
    };

    settings = mkOption {
      type = types.submodule { freeformType = yamlFormat.type; };
      description = ''
        Settings for the <command>darkman</command> command.  See
        <link xlink:href="https://darkman.whynothugo.nl/#CONFIGURATION"/>
        for details.
      '';
      example = literalExpression ''
        {
          lat = 52.3;
          lng = 4.8;
          usegeoclue = true;
        }
      '';
    };

    darkModeScripts = scriptsOptionType "dark";

    lightModeScripts = scriptsOptionType "light";
  };

  config = mkIf cfg.enable {
    assertions = [
      (hm.assertions.assertPlatform "services.darkman" pkgs platforms.linux)
    ];

    home.packages = [ cfg.package ];

    xdg.configFile."darkman/config.yaml".source = mkIf (cfg.settings != { })
      (yamlFormat.generate "darkman-config.yaml" cfg.settings);

    xdg.dataFile = mkMerge [
      (mkIf (cfg.darkModeScripts != { })
        (generateScripts "dark-mode.d" cfg.darkModeScripts))
      (mkIf (cfg.lightModeScripts != { })
        (generateScripts "light-mode.d" cfg.lightModeScripts))
    ];

    systemd.user.services.darkman = {
      Unit = {
        Description = "Darkman system service";
        Documentation = "man:darkman(1)";
        PartOf = [ "graphical-session.target" ];
        BindsTo = [ "graphical-session.target" ];
      };

      Service = {
        Type = "dbus";
        BusName = "nl.whynothugo.darkman";
        ExecStart = "${cfg.package}/bin/darkman run";
        # Scripts are started with `bash` instead of just `sh`
        Environment = "PATH=${makeBinPath [ pkgs.bash ]}";
        Restart = "on-failure";
        TimeoutStopSec = 15;
        Slice = "background.slice";
      };

      Install.WantedBy = mkDefault [ "graphical-session.target" ];
    };
  };
}
