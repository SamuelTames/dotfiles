;; https://huytd.github.io/emacs-from-scratch.html
;; http://aaronbedra.com/emacs.d/#user-info
;; https://sam217pa.github.io/2016/09/02/how-to-build-your-own-spacemacs/

;; Package configs
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; byte compile configuration
(byte-recompile-directory (expand-file-name "~/.emacs.d") 0)
(setq load-prefer-newer t)
;;(setq auto-compile-on-load-mode t)

;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
(setq border-width 10)
(setq inhibit-splash-screen t)
(setq initial-scratch-message nil)
(setq initial-major-mode 'org-mode)

;; Text handling
(delete-selection-mode t)
(transient-mark-mode t)
(setq select-enable-clipboard t)

;; Responsiveness + alert
(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)

;; Indentation
(setq tab-width 2
      indent-tabs-mode nil)

;; Font Config
(add-to-list 'default-frame-alist '(font . "Ubuntu Mono-16"))
(add-to-list 'default-frame-alist '(height . 24))
(add-to-list 'default-frame-alist '(width . 80))

;; Vim mode
(use-package evil
  :ensure t
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; Theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-dracula t))

;;(use-package base16-theme
;;  :ensure t
;;  :config
;;  (load-theme 'base16-grayscale-light t))


;; Modeline
(use-package doom-modeline
      :ensure t
      :defer t
      :hook (after-init . doom-modeline-init))

;; Icons
(use-package all-the-icons :ensure t)

;; Line Numbers 
(setq-default display-line-numbers 'visual)
(setq display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
(setq display-line-numbers-widen t)

;; Show matching parens
(setq show-paren-delay 0)
(show-paren-mode 1)

;; Disable backup files
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files


;; Projectile
(use-package projectile
  :ensure t
  :init
  (setq projectile-require-project-root nil)
  :config
  (projectile-mode 1))

;; Ivy
(use-package ivy :ensure t
  :diminish (ivy-mode . "")             ; does not display ivy in the modeline
  :init
  (ivy-mode 1)                          ; enable ivy globally at startup
  :bind (:map ivy-minibuffer-map        ; bind in the ivy buffer
       ("RET" . ivy-alt-done)
       ("s-<"   . ivy-avy)
       ("s->"   . ivy-dispatching-done)
       ("s-+"   . ivy-call)
       ("s-!"   . ivy-immediate-done)
       ("s-["   . ivy-previous-history-element)
       ("s-]"   . ivy-next-history-element))
  :config
  (setq ivy-use-virtual-buffers t)       ; extend searching to bookmarks and
  (setq ivy-height 20)                   ; set height of the ivy window
  (setq ivy-count-format "(%d/%d) ")     ; count format, from the ivy help page
  (setq ivy-display-style 'fancy)
  (setq ivy-format-function 'ivy-format-function-line) ; Make highlight extend all the way to the right
  ;; TODO testing out the fuzzy search
  (setq ivy-re-builders-alist
      '((counsel-M-x . ivy--regex-fuzzy) ; Only counsel-M-x use flx fuzzy search
        (t . ivy--regex-plus)))
  (setq ivy-initial-inputs-alist nil))

;; Which Key
(use-package which-key
  :ensure t
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode 1))

;; Custom keybinding
(use-package general
  :ensure t
  :config (general-define-key
  :states '(normal visual insert emacs)
  :prefix "SPC"
  :non-normal-prefix "M-SPC"
  ;; Buffers
  "h" '(switch-to-prev-buffer :which-key "previous buffer")
  "l" '(switch-to-next-buffer :which-key "next buffer")
  ;; Window
  "wl"  '(windmove-right :which-key "move right")
  "wh"  '(windmove-left :which-key "move left")
  "wk"  '(windmove-up :which-key "move up")
  "wj"  '(windmove-down :which-key "move bottom")
  "w/"  '(split-window-right :which-key "split right")
  "w-"  '(split-window-below :which-key "split bottom")
  "wq"  '(delete-window :which-key "delete window")
  ;; Others
  "at"  '(ansi-term :which-key "open terminal")

))

;; Treemacs
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config (provide 'init-treemacs))
(use-package treemacs-evil
  :after treemacs evil
  :ensure t)
(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)
(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

