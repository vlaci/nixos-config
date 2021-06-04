;;; /nix/store/0s16xdxx9xwcm0g8w7zzxp7p3rnwmwsq-straight-emacs-env/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq doom-theme 'doom-nord
      markdown-header-scaling t
      markdown-hide-markup t
      lsp-keymap-prefix "s-a"
      Info-directory-list nil
      flycheck-flake8rc ".flake8")

(after! ivy-posframe
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-top-center))))

(defun load-theme--disable-old-theme(_theme &rest _args)
  "Disable current theme before loading new one."
  (mapcar #'disable-theme custom-enabled-themes))
(advice-add 'load-theme :before #'load-theme--disable-old-theme)


(after! org-mode
  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate))

(after! treemacs
  (treemacs-tag-follow-mode))

(map! :g "C-x t" #'treemacs-select-window)
