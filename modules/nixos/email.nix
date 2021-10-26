{ lib, config, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config._.email;
in {
  options = {
    _.email.enable = mkEnableOption "email";
    _.email.work.enable = mkEnableOption "work";
  };
  config = mkIf cfg.enable {
    services.davmail = {
      enable = cfg.work.enable;
      url = "https://outlook.office365.com/EWS/Exchange.asmx";
      config.davmail = {
        imapPort = 10143;
        smtpPort = 10025;
        caldavPort = 10080;
        popPort = 10110;
        mode = "O365Modern";
      };
      config.log4j.logger.davmail = "INFO";
    };
  };
}
