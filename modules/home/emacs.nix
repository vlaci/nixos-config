{ lib, config, ...}:

let
in lib.mkProfile "emacs" {
  emacsVlaci = {
    enable = true;
    settings = {
      org-journal-dir = "~/devel/git/github.com/vlaci/notes/org/journal";
      org-roam-directory = "~/devel/git/github.com/vlaci/notes/org/roam";
      projectile-project-search-path = [
        { elisp = ''("~/devel/git" . 2)''; }
      ];
    };
  };
}
