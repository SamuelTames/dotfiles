;; Work in Progress!
;; putting together a config as an alternative to doom/spacemacs
;;
;; https://huytd.github.io/emacs-from-scratch.html
;; http://aaronbedra.com/emacs.d/#user-info
;; https://sam217pa.github.io/2016/09/02/how-to-build-your-own-spacemacs/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Packaging 

;; Loading repositiories 
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

;; Byte compilation of files 
(setq load-prefer-newer t)
(setq auto-compile-on-load-mode t)
(setq auto-compile-on-save-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI/UX

;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
(setq border-width 10)
(setq inhibit-splash-screen t)
(setq initial-scratch-message nil)
(setq initial-major-mode 'org-mode)
(add-to-list 'default-frame-alist '(height . 80))
(add-to-list 'default-frame-alist '(width . 100))
(add-to-list 'default-frame-alist '(font . "Ubuntu Mono-16"))

;; Text handling
(delete-selection-mode t)
(transient-mark-mode t)
(setq select-enable-clipboard t)

;; Responsiveness + Alerts + 
(setq echo-keystrokes 0.1)
(setq use-dialog-box nil)

;; Confirmation prompt
;(setq visible-bell t)
(defalias 'yes-or-no-p 'y-or-n-p)

;; Indentation
(setq tab-width 4)
(setq indent-tabs-mode nil)

;; Vim mode
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))
(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; Theme
(use-package doom-themes
    :config
    (doom-themes-visual-bell-config)
    (doom-themes-org-config)
    (doom-themes-treemacs-config))
(use-package cherry-blossom-theme
  :ensure t
  :config
  (load-theme 'cherry-blossom t))

;; Modeline
(use-package doom-modeline
      :ensure t
      :defer t
      :hook (after-init . doom-modeline-init))

;; Icons
;; M-x all-the-icons-install-fonts
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Additional Packages

;; Projectile
(use-package projectile
  :ensure t
  :init
  (setq projectile-require-project-root nil
	projectile-completion-system 'ivy)
  :config
  (projectile-mode 1))

;; Ivy
(use-package ivy
  :ensure t
  :diminish (ivy-mode . "")             ; does not display ivy in the modeline
  :init
  (ivy-mode 1)                          ; enable ivy globally at startup
  :config
  (setq ivy-use-virtual-buffers t)       ; extend searching to bookmarks and
  (setq ivy-height 30)                   ; set height of the ivy window
  (setq ivy-count-format "(%d/%d) ")     ; count format, from the ivy help page
  (setq ivy-display-style 'fancy)
  (setq ivy-format-function 'ivy-format-function-line) ; Make highlight extend all the way to the right
  ;; TODO testing out the fuzzy search
  (setq ivy-re-builders-alist
      '((counsel-M-x . ivy--regex-fuzzy) ; Only counsel-M-x use flx fuzzy search
        (t . ivy--regex-plus)))
  (setq ivy-initial-inputs-alist nil))

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

;; Language Server
(use-package lsp-mode :commands lsp)
(use-package lsp-ui :commands lsp-ui-mode)
(use-package company-lsp :commands company-lsp)

;; C language server support
(use-package ccls
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))
(setq ccls-executable "~/.bin/ccls")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom keybinding

(use-package which-key
  :ensure t
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode 1))

(use-package general
  :ensure t
  :config (general-define-key
  :states '(normal visual insert emacs)
  :prefix "SPC"
  :non-normal-prefix "M-SPC"
  ;; Buffers
  "h" '(switch-to-prev-buffer :which-key "previous buffer")
  "l" '(switch-to-next-buffer :which-key "next buffer")
  "q" '(kill-this-buffer :which-key "kill buffer")
;  "s" '(save-buffer :which-key "save buffer")
  ;; Files
  "t" '(treemacs :which-key "treemacs")
  "f" '(find-file :which-key "find file")
  ;; Window
  "wl"  '(windmove-right :which-key "move right")
  "wh"  '(windmove-left :which-key "move left")
  "wk"  '(windmove-up :which-key "move up")
  "wj"  '(windmove-down :which-key "move bottom")
  "wq"  '(delete-window :which-key "delete window")
  "w\\" '(split-window-right :which-key "split right")
  "w-"  '(split-window-below :which-key "split bottom")
  ;; Others
  "z"  '(ansi-term :which-key "open terminal")
))
