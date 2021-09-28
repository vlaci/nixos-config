{ lib, config, ...}:

let
in lib.mkProfile "emacs" {
  emacsVlaci = {
    enable = true;
    settings = {
      org-directory = "~/devel/git/github.com/vlaci/notes/org";
      projectile-project-search-path = [
        { elisp = ''("~/devel/git" . 2)''; }
      ];
    };
  };
}
