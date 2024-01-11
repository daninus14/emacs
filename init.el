;; -*- mode: elisp -*-

(when (>= emacs-major-version 24)
  (progn
    ;; load emacs 24's package system. Add MELPA repository.
    (require 'package)
    (add-to-list
     'package-archives
     '("melpa" . "https://melpa.org/packages/")
     t))
;  (package-refresh-contents)
  (when (< emacs-major-version 27) (package-initialize)))


;; Any Customize-based settings should live in custom.el, not here.
(setq custom-file "~/.emacs.d/custom.el") ;; Without this emacs will dump generated custom settings in this file. No bueno.
(load custom-file 'noerror)

; https://github.com/benjaminor/kkp
(use-package kkp
  :ensure t
  :config
  ;; (setq kkp-alt-modifier 'alt) ;; use this if you want to map the Alt keyboard modifier to Alt in Emacs (and not to Meta)
  (global-kkp-mode +1))

;; Disable the splash screen (to enable it agin, replace the t with 0)
(setq inhibit-splash-screen t)

;; Enable transient mark mode
(transient-mark-mode 1)

;;;;Org mode configuration
;; Enable Org mode
;; (require 'org)
;; Make Org mode work with files ending in .org
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; The above is the default in recent emacsen
;; https://emacs.stackexchange.com/questions/22179/enable-visual-line-mode-and-org-indent-mode-when-opening-org-files
(with-eval-after-load 'org       
  (setq org-startup-indented t) ; Enable `org-indent-mode' by default
  (add-hook 'org-mode-hook #'visual-line-mode))

(visual-line-mode 1)

(desktop-save-mode 1)


;; https://www.juniordeveloperdiaries.com/emacs-intro/ is the next section

(setq
 use-package-always-ensure t ;; Makes sure to download new packages if they aren't already downloaded
 use-package-verbose t) ;; Package install logging. Packages break, it's nice to know why.

;; Slurp environment variables from the shell.
;; a.k.a. The Most Asked Question On r/emacs
;; (use-package exec-path-from-shell
;;   :config
;;   (exec-path-from-shell-initialize))

;; (use-package doom-themes
;;   :init
;;   (load-theme 'doom-one t))

;;; OS specific config
(defconst *is-a-mac* (eq system-type 'darwin))
(defconst *is-a-linux* (eq system-type 'gnu/linux))


;; Fullscreen by default, as early as possible. This tiny window is not enough
(add-to-list 'default-frame-alist '(fullscreen . maximized))


;; This is to open emacs on a desktop session based on the current directory
(setq desktop-path '("." "~/.emacs.d/" "~"))

(require 'pbcopy)
(turn-on-pbcopy)

(load (expand-file-name "~/.roswell/helper.el"))
(setq inferior-lisp-program "ros -Q run")

(setq slime-contribs '(slime-fancy slime-quicklisp slime-asdf helm-slime slime-quicklisp slime-company))

(load-theme 'solarized-dark t)

;; Make M-x and other mini-buffers sortable, filterable
(use-package ivy
  :init
  (ivy-mode 1)
  (setq ivy-height 15
        ivy-use-virtual-buffers t
        ivy-use-selectable-prompt t))
(use-package counsel
  :after ivy
  :init
  (counsel-mode 1)
  :bind (:map ivy-minibuffer-map))


(use-package company
  :bind (("C-." . company-complete))
  :custom
  (company-require-match nil)            ; Don't require match, so you can still move your cursor as expected.
  (company-tooltip-align-annotations t)  ; Align annotation to the right side.
  (company-idle-delay 0) ;; I always want completion, give it to me asap
  (company-dabbrev-downcase nil "Don't downcase returned candidates.")
  (company-show-numbers t "Numbers are helpful.")
  (company-tooltip-limit 10 "The more the merrier.")
  :config
  (global-company-mode) ;; We want completion everywhere
  
  ;; use numbers 0-9 to select company completion candidates
  (let ((map company-active-map))
    (mapc (lambda (x) (define-key map (format "%d" x)
                        `(lambda () (interactive) (company-complete-number ,x))))
          (number-sequence 0 9))))

;; Flycheck is the newer version of flymake and is needed to make lsp-mode not freak out.
(use-package flycheck
  :config
  (add-hook 'prog-mode-hook 'flycheck-mode) ;; always lint my code
  (add-hook 'after-init-hook #'global-flycheck-mode))

;; Package for interacting with language servers
(use-package lsp-mode
  :commands lsp
  :config
  (setq lsp-prefer-flymake nil ;; Flymake is outdated
        lsp-headerline-breadcrumb-mode nil)) ;; I don't like the symbols on the header a-la-vscode, remove this if you like them.

(use-package which-key :config (which-key-mode t))

;; https://www.juniordeveloperdiaries.com/emacs-intro/ end of this tutorial


(require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; counsel-git to find file in project and counsel-git-grep to find text in project

(global-set-key (kbd "C-c w") 'clipboard-kill-ring-save)

(setq completion-styles '(flex initials))
; (global-set-key (kbd "M-x") 'helm-M-x)

;; for qlot
;; https://github.com/fukamachi/qlot?tab=readme-ov-file#emacs
(setq slime-lisp-implementations
      '((ros ("ros" "run") :coding-system utf-8-unix)
	(sbcl ("sbcl") :coding-system utf-8-unix)
        (qlot ("qlot" "exec" "ros" "run") :coding-system utf-8-unix)))
;	(qlot ("qlot" "exec" "sbcl") :coding-system utf-8-unix)))

(provide 'init)
;;; init.el ends here
