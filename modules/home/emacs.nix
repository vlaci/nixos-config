{ lib, config, ... }:

let
  cfg = config._.emacs;
  inherit (lib) mkEnableOption mkOption types;
in
{
  options = {
    _.emacs.enable = mkEnableOption "emacs";
    accounts.email.accounts = mkOption {
      type = with types; attrsOf (submodule ({ config, ... }:
        {
          options = {
            mu4e.extraConfig = mkOption { type = types.separatedString "\n"; default = ""; };
          };
        }
      ));
    };
  };

  config = {
    emacsVlaci = {
      enable = true;
      settings = rec {
        org-directory = "~/devel/git/github.com/vlaci/notes/org";
        org-default-notes-file = "${org-directory}/notes.org";
        org-agenda-files = [ "quote" "${org-directory}/personal" "${org-directory}/work" ];
        org-roam-directory = org-directory + "/roam";
        magit-repository-directories = [ "quote" [ "cons" "~/devel/git" 3 ] ];
      };
      extraConfig =
        let
          mkContext = name: { address, userName, realName, smtp, mu4e, ... }: ''
            ,(make-mu4e-context
              :name "${name}"
              :enter-func (lambda () (mu4e-message "Entering context =${name}="))
              :leave-func (lambda () (mu4e-clear-caches))
              :match-func (lambda (msg)
                            (when msg
                              (string-match-p "^/${name}" (mu4e-message-field msg :maildir))))
              :vars '(( user-mail-address  . "${address}"  )
                      ( user-full-name	    . "${realName}" )
                      ( mu4e-sent-folder   . "/${name}/Sent" )
                      ( mu4e-drafts-folder . "/${name}/Drafts" )
                      ( mu4e-trash-folder  . "/${name}/Trash" )
                      ( smtpmail-default-smtp-server . "${smtp.host}" )
                      ( smtpmail-smtp-user . "${userName}" )
                      ( smtpmail-smtp-server . "${smtp.host}" )
                      ( smtpmail-stream-type . "${if smtp.tls.enable then "ssl" else "nil"}" )
                      ( smtpmail-smtp-service . ${toString (if smtp.port != null then smtp.port else if smtp.tls.enable then 465 else 25)})
                      ${mu4e.extraConfig}
                      ))
          '';

          contexts = lib.mapAttrsToList mkContext config.accounts.email.accounts;
        in
        ''
          (with-eval-after-load 'mu4e
            (setq mu4e-contexts
              `(
                ${lib.concatStrings contexts}
              )))
        '';
    };
    home.sessionVariables = {
      ALTERNATE_EDITOR = "";
      EDITOR = "emacsclient -t";
      VISUAL = "emacsclient -c -a emacs";
    };
  };
}
