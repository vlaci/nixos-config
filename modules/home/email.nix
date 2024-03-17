{ pkgs, lib, nixosConfig, ... }:

let
  work = nixosConfig._.email.work.enable;
  vlaci = nixosConfig._.secrets.vlaci;
  inherit (lib) mkIf optionalAttrs optionals;
in
lib.mkProfile "email" (mkIf vlaci.available {
  programs.mbsync = {
    enable = true;
  };

  services.mbsync = {
    enable = false;
  };

  programs.msmtp = {
    enable = true;
  };

  programs.mu = {
    enable = true;
  };

  programs.mujmap = {
    enable = true;
  };

  programs.notmuch = {
    enable = true;
  };

  programs.rbw = lib.mkIf nixosConfig._.secrets.vlaci.available {
    enable = true;
    settings = {
      email = nixosConfig._.secrets.vlaci.value.bitwarden.email;
      pinentry = pkgs.pinentry-gnome3;
    };
  };

  accounts.email = {
    accounts = (
      {
        ${vlaci.value.email.default.name} =
          let
            cfg = vlaci.value.email.default;
          in
          rec {
            inherit (cfg) address realName imap smtp;
            userName = cfg.address;
            passwordCommand = "${pkgs.rbw}/bin/rbw get ${cfg.fqdn} ${userName}";
            primary = true;
            mujmap = {
              enable = true;
              settings = {
                inherit (cfg) fqdn;
                password_command = "${passwordCommand} -f mujmap | cut -d' ' -f 2";
              };
            };
            notmuch = {
              enable = true;
            };
            mbsync = {
              enable = false;
              create = "maildir";
              remove = "maildir";
              expunge = "none";
              patterns = [ "*" ];
              extraConfig.local = {
                SubFolders = "Verbatim";
              };
              extraConfig.channel = {
                CopyArrivalDate = "yes";
              };
            };
            msmtp = {
              enable = true;
              extraConfig.auth = "login";
            };
            mu4e.extraConfig = ''
              (mu4e-refile-folder  . "/${cfg.name}/Archive")
              (mu4e-maildir-shortcuts .
              (("/${cfg.name}/Inbox" . ?i)
              ("/${cfg.name}/accounts" . ?a)))
            '';
          };
      }
      // optionalAttrs work {
        ${vlaci.value.email.work.name} =
          let
            cfg = vlaci.value.email.work;
          in
          rec {
            inherit (cfg) address realName;
            userName = cfg.address;
            passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup service mbsync username ${userName}";
            imap = {
              host = "localhost";
              port = nixosConfig.services.davmail.config.davmail.imapPort;
              tls.enable = false;
            };
            smtp = {
              host = "localhost";
              port = nixosConfig.services.davmail.config.davmail.smtpPort;
              tls.enable = false;
            };
            mbsync = {
              enable = true;
              create = "maildir";
              remove = "maildir";
              expunge = "none";
              patterns = [ "*" ]; # "!Conversation History" "!Unsent Messages" ];
              extraConfig.account = {
                "AuthMechs" = "LOGIN";
              };
              extraConfig.local = {
                SubFolders = "Verbatim";
              };
              extraConfig.channel = {
                CopyArrivalDate = "yes";
              };
            };
            msmtp = {
              enable = true;
              extraConfig.auth = "login";
            };
            mu4e.extraConfig = ''
              (smtpmail-stream-type . plain)
              (mu4e-maildir-shortcuts .
              ((:maildir "/${cfg.name}/Inbox" :key ?i)))
            '';
          };
      }
    );
  };
})
