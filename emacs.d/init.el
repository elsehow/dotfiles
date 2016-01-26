; setup packaging
(require 'package)
(setq package-user-dir "~/.emacs.d/elpa/")
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(defvar my-packages '(better-defaults
		      projectile
		      clojure-mode
		      cider
		      evil
          evil-leader
          evil-org
          rainbow-delimiters))
;;(interactive)
;;(package-refresh-contents)
(dolist (p my-packages)
  (unless (package-installed-p p)
        (package-install p)))

; set visual line mode
(setq line-move-visual nil)

;;enable rainbow delimiters in all programming modes
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

; enable mouse
;; Enable mouse support
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] (lambda ()
                              (interactive)
                              (scroll-down 1)))
  (global-set-key [mouse-5] (lambda ()
                              (interactive)
                              (scroll-up 1)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
  )

;; Enable Evil mode as defuault
(setq evil-want-C-i-jump nil)
(require 'evil)
(require 'evil-leader)
(require 'evil-org)
(evil-mode 1)
;; change windows
(eval-after-load "evil"
  '(progn
     (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
     (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
     (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
     (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)))
;; Indents, tab as spaces
(setq-default indent-tabs-mode nil)
(setq default-tab-width 2)
;; Treat wrapped line scrolling as single lines
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
  ;;; esc quits pretty much anything (like pending prompts in the minibuffer)
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
;; Enable smash escape (ie 'jk' and 'kj' quickly to exit insert mode)
(define-key evil-insert-state-map "k" #'cofi/maybe-exit-kj)
(evil-define-command cofi/maybe-exit-kj ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "k")
    (let ((evt (read-event (format "Insert %c to exit insert state" ?j)
                           nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?j))
        (delete-char -1)
        (set-buffer-modified-p modified)
        (push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
                                              (list evt))))))))
(define-key evil-insert-state-map "j" #'cofi/maybe-exit-jk)
(evil-define-command cofi/maybe-exit-jk ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "j")
    (let ((evt (read-event (format "Insert %c to exit insert state" ?k)
               nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?k))
        (delete-char -1)
        (set-buffer-modified-p modified)
        (push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
                                              (list evt))))))))
;; ORG MODE
;; auto-indent an org-mode file
(add-hook 'org-mode-hook
          (lambda()
            (local-set-key (kbd "C-c C-c") 'org-table-align)
            (local-set-key (kbd "C-c C-f") 'org-table-calc-current-TBLFM)
            (org-indent-mode t)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/Notes/fun.org" "~/Notes/spring.org")))
 '(org-startup-truncated nil)
 '(package-selected-packages
   (quote
    (evil-org evil-leader evil cider clojure-mode projectile better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(define-key global-map "\C-ca" 'org-agenda)


; `twf` blogging setup - compiles this-weeks-finds to ~/public_html
(setq org-publish-project-alist
      '(("twf"
         ; directory of blog content
         :base-directory "~/Notes/"
         :html-extension "html"
         :base-extension "org"
         :exclude ".*" 
         :include ("this-weeks-finds.org")
         :publishing-directory "~/Projects/this-weeks-finds/dist/"
         :publishing-function (org-html-publish-to-html)
         :html-preamble nil
         :html-postamble nil
         :html-head-extra
         ; link to rss + css in html head
         "<link rel=\"alternate\" type=\"application/rss+xml\"
                href=\"http://our.coolworld.me/index.xml\"
                title=\"my.coolworld.me RSS feed\">
          <link rel=\"stylesheet\"
                type=\"text/css\"
                href=\"style.css\">")))

; ox rss
(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'ox-rss)
;; `twf-rss` to publish rss feed
(add-to-list 'org-publish-project-alist
             '("twf-rss"
               :base-directory "~/Notes/"
               :base-extension "org"
               :exclude ".*" 
               :include ("this-weeks-finds.org")
               :publishing-directory "~/Projects/this-weeks-finds/dist/"
               :publishing-function (org-rss-publish-to-rss)
               :html-link-home "http://our.coolworld.me/"
               :html-link-use-abs-url t
               :title "our.coolworld.me RSS"
               ; we're only using index.org to generate the rss file
               ))

;; command to generate blog
(global-set-key
 (kbd "C-c twf")
 (lambda ()
   (interactive)
   (org-publish "twf")
   (org-publish "twf-rss")))

