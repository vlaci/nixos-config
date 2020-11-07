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

;; set font for emoji
(set-fontset-font
 t
 '(#x1f300 . #x1fad0)
 (cond
  ((member "Noto Color Emoji" (font-family-list)) "Noto Color Emoji")
  ((member "Noto Emoji" (font-family-list)) "Noto Emoji")
  ((member "Segoe UI Emoji" (font-family-list)) "Segoe UI Emoji")
  ((member "Symbola" (font-family-list)) "Symbola")
  ((member "Apple Color Emoji" (font-family-list)) "Apple Color Emoji"))
 ;; Apple Color Emoji should be before Symbola, but Richard Stallman disabled it.
 ;; GNU Emacs Removes Color Emoji Support on the Mac
 ;; http://ergoemacs.org/misc/emacs_macos_emoji.html
 ;;
 )
