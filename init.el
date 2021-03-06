;;;; ========== Auto Generated ==========
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("05c3bc4eb1219953a4f182e10de1f7466d28987f48d647c01f1f0037ff35ab9a" "d9046dcd38624dbe0eb84605e77d165e24fdfca3a40c3b13f504728bab0bf99d" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(ido-mode 1)

(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(global-set-key "\C-x\C-m" 'execute-extended-command)

(require 'package)
(add-to-list
 'package-archives
 '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
;(package-refresh-contents)
(defvar my-packages
  '(nyan-mode
    nyan-prompt
    rainbow-delimiters
    cider
    paredit
    clj-refactor
    fsharp-mode
    ac-cider))

;; On OS X, an Emacs instance started from the graphical user
;; interface will have a different environment than a shell in a
;; terminal window, because OS X does not run a shell during the
;; login. Obviously this will lead to unexpected results when
;; calling external utilities like make from Emacs.
;; This library works around this problem by copying important
;; environment variables from the user's shell.
;; https://github.com/purcell/exec-path-from-shell
(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; ========== Initialize Stuff ==========

;; Todo: Add conditional so I don't run this shit on nox servers
(nyan-mode)
(nyan-start-animation)
;(nyan-start-music)
(add-hook 'eshell-load-hook 'nyan-prompt-enable)

(require 'fsharp-mode)
(if (eq system-type 'darwin)
    (progn (setq inferior-fsharp-program "/usr/local/bin/fsharpi --readline-")
           (setq fsharp-compiler "/usr/local/bin/fsharpc")))

(add-hook 'fsharp-mode-hook
 (lambda ()
   (define-key fsharp-mode-map (kbd "M-RET") 'fsharp-eval-region)
   (define-key fsharp-mode-map (kbd "M-SPC") 'fsharp-ac/complete-at-point)))

;; To create the hook for specific modes, see the following
;(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

;; Load Path
;(add-to-list 'load-path "~/.emacs.d/somefolder")

;; ========== Misc ==========
;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)
;; Go straight to scratch buffer on startup
(setq inhibit-startup-message t)

;; ========== Editing ==========
(setq-default indent-tabs-mode nil)
;; Highlight matching parens
(show-paren-mode 1)
;; Go to last cursor position when file was open
(setq save-place-file "~/.emacs.d/saveplace")
(require 'saveplace)
(setq-default save-place t)

;; Color Themes
;; Read http://batsov.com/articles/2012/02/19/color-theming-in-emacs-reloaded/
;; for a great explanation of emacs color themes.
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Custom-Themes.html
;; for a more technical explanation.
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(add-to-list 'load-path "~/.emacs.d/themes")
;(load-theme 'tomorrow-night-bright t)
(load-theme 'monokai t)

(setq c-default-style "linux"
      c-basic-offset 4)

;; Line Numbers
(global-linum-mode)
;; Un-indenting
(global-set-key (kbd "<backtab>") 'un-indent-by-removing-4-spaces)
(defun un-indent-by-removing-4-spaces ()
  "remove 4 spaces from beginning of of line"
  (interactive)
  (save-excursion
    (save-match-data
      (beginning-of-line)
      ;; get rid of tabs at beginning of line
      (when (looking-at "^\\s-+")
        (untabify (match-beginning 0) (match-end 0)))
      (when (looking-at "^    ")
        (replace-match "")))))

;; Add Homebrew Binaries to path
;(setenv "PATH" (concat (getenv "PATH") ":/sw/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))

;; Rust Stuff/Autocomplete
; (add-hook 'rust-mode-hook
;           '(lambda ()
;              (racer-activate)
;              (local-set-key (kbd "M-.") #'racer-find-definition)
;              (local-set-key (kbd "TAB") #'racer-complete-or-indent)))

;; scroll one line at a time (less "jumpy" than defaults)
(defun set-smooth-scrolling (amt)
  (setq mouse-wheel-scroll-amount '(amt ((shift) . amt))) ;; one line at a time
  (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
  (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
  (setq scroll-step amt)) ;; keyboard scroll one line at a time
;; Todo: The parameter doesn't seem to do anything
(set-smooth-scrolling 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hooks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ENABLE Rainbow Delimiters in all programming related modes
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
;; Enable paredit for Clojure
(add-hook 'clojure-mode-hook 'enable-paredit-mode)
(add-hook 'cider-repl-mode-hook 'enable-paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)

;; Clojure Autocomplete
(require 'ac-cider)
(add-hook 'cider-mode-hook 'ac-flyspell-workaround)
(add-hook 'cider-mode-hook 'ac-cider-setup)
(add-hook 'cider-repl-mode-hook 'ac-cider-setup)
(add-hook 'cider-repl-mode-hook 'auto-complete-mode)
(add-hook 'clojure-mode-hook 'auto-complete-mode)
(eval-after-load "auto-complete"
  '(progn
     (add-to-list 'ac-modes 'cider-mode)
     (add-to-list 'ac-modes 'cider-repl-mode)
     (add-to-list 'ac-modes 'clojure-mode)))
(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions '(auto-complete)))

(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'cider-mode-hook 'set-auto-complete-as-completion-at-point-function)
;; End Clj AC

(provide 'init)
;;; init.el ends here


