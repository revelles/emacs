;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                          ;;
;;           Francisco Revelles' .emacs file                                ;;
;;                                                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialise the emacs packages in case any of them overrides
;; built-in Emacs packages.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)

;;;
(require 'gnutls)
(add-to-list 'gnutls-trustfiles "/usr/local/etc/openssl/cert.pem")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emacs package management
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq package-archives '(("melpa" . "http://melpa.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         )
      )

;; Add ELPA packages to the loadpp path
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

;;;
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(let ((default-directory "~/.emacs.d/elpa"))
  (normal-top-level-add-subdirs-to-load-path))

;; Ensure use-package is installed and loaded
(condition-case nil
    (require 'use-package)
  (file-error
   (require 'package)
   (package-initialize)
   (package-refresh-contents)
   (package-install 'use-package)
   (require 'use-package)))

;; Let use-package install all packages mentioned if they're not
;; already installed.
(setq use-package-always-ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Put all Emacs customize variables & faces in its own file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(when (memq window-system '(mac ns x))
;;  (exec-path-from-shell-initialize))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Edit text areas in Chrome browsers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (locate-library "edit-server")
  (require 'edit-server)
  (setq edit-server-new-frame nil)
  (edit-server-start))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Minibuffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Enhanced M-x
(use-package counsel
  :bind
  (("M-x" . counsel-M-x)))

;; IDO
(use-package ido
  :init
  (setq ido-everywhere nil
        ido-enable-flex-matching t
        ido-create-new-buffer 'always
        ido-file-extensions-order '(".java" ".js" ".el" ".xml")
        ido-use-filename-at-point 'guess
        ido-use-faces t)

  :config
  (ido-mode 'buffer)

  :bind ("C-x b" . ido-switch-buffer)
  )

;; Improved flex matching
(use-package flx-ido)

;; Vertical completion menu
(use-package ido-vertical-mode
  :init
  (setq ido-vertical-indicator ">>"
        ido-vertical-show-count nil
        ido-vertical-define-keys 'C-n-C-p-up-and-down)
  :config
  (ido-vertical-mode)
  (ido-vertical-mode nil))

;; If not using ido-vertical-mode, make the minibuff stay still,
;; i.e. never change height, set this to nil.
;; (setq resize-mini-windows 'grow-only)

;; IDO support pretty much everwhere, including eclim-java-implement
(use-package ido-completing-read+
  :config
  (ido-ubiquitous-mode))

;; Sub word support
(add-hook 'minibuffer-setup-hook 'subword-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mode line settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun mode-line-simple()
  (interactive)
  (setq-default mode-line-format '("%b %* (%l,%c)")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Show paren mode, built-in from Emacs 24.x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(show-paren-mode t)
(setq show-paren-style 'expression)

(use-package paren)
(set-face-background 'show-paren-match (face-background 'default))
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setting the general load path for Emacs. This load path is for
;; packages that only have one .el file and hence reside in a
;; directory with other smaller modes.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq load-path
      (append (list (expand-file-name "/usr/local/emacs/")
                    "/usr/share/emacs/site-lisp/w3m"
                   ;; "/usr/share/emacs/site-lisp/mu4e"
                    "/usr/share/emacs/site-lisp/global"
                    "/usr/local/src/varnish/varnish-tools/emacs")
              load-path))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; saves the buffer/split configuration, makes it un/re-doable.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(winner-mode 1)
(global-set-key (kbd "<C-left>") 'winner-undo)
(global-set-key (kbd "<C-right>") 'winner-redo)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shortcuts in all modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key "\M- " 'hippie-expand)
(global-set-key "\M-r" 'join-line)
;; minimising Emacs way too many times without wanting to.
(global-unset-key "\C-z")
;; don't write backslashed to indicate continuous lines
(set-display-table-slot standard-display-table 'wrap ?\ )
;; Treat 'y' or <CR> as yes, 'n' as no.
(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "<f1>") 'magit-status)
(global-set-key (kbd "<XF86MyComputer>") 'magit-status)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emacs open grep and find
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key "\C-\M-f" 'find-file-at-point)
(global-set-key "\C-cn" 'find-dired)
(global-set-key "\C-cN" 'grep-find)

(use-package grep)
(setq grep-find-ignored-directories
      (append
       (list
        ".git"
        ".hg"
        ".idea"
        ".project"
        ".settings"
        ".svn"
        "bootstrap*"
        "pyenv"
        "target"
        )
       grep-find-ignored-directories))

(setq grep-find-ignored-files
      (append
       (list
        "*.blob"
        "*.gz"
        "*.jar"
        "*.xd"
        "TAGS"
        "dependency-reduced-pom.xml"
        "projectile.cache"
        "workbench.xmi"
        )
       grep-find-ignored-files))

(setq grep-find-command
      "find ~/src/content-engine -name \"*.java\" | xargs grep -n -i -e ")

(use-package ag
  :init
  (setq ag-arguments (list "--word-regexp" "--smart-case"))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Prefer UTF 8, but don't override current encoding if specified
;; (unless you specify a write hook).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(prefer-coding-system 'utf-8-unix)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; White space
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq tab-width 2)
(setq-default indent-tabs-mode nil)

;; ws-butler cleans up whitespace only on the lines you've edited,
;; keeping messy colleagues happy ;-) Important that it doesn't clean
;; the whitespace on currrent line, otherwise, eclim leaves messy
;; code behind.
(use-package ws-butler
  :init
  (setq ws-butler-keep-whitespace-before-point nil)
  :config
  (ws-butler-global-mode))

(defun tkj-indent-and-fix-whitespace()
  (interactive)
  (delete-trailing-whitespace)
  (untabify (point-min) (point-max))
  (indent-region (point-min) (point-max)))
(global-set-key "\C-\M-\\" 'tkj-indent-and-fix-whitespace)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Spell checking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ispell
  :init
  (setq ispell-program-name "aspell"
        ispell-list-command "list"
        ispell-dictionary "british"
        flyspell-auto-correct-binding (kbd "<S-f12>")))

(use-package flycheck)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tag lookup/auto completion based on GNU Global
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ggtags)
(use-package ggtags)
(setq xref-prompt-for-identifier nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pure text settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'text-mode-hook
          '(lambda ()
             (flyspell-mode
        )))
(defun insert-left-arrow()
 (interactive)
  (insert "←"))
(defun insert-right-arrow()
  (interactive)
  (insert "→"))
(defun insert-up-arrow()
  (interactive)
  (insert "↑"))
(defun insert-down-arrow()
  (interactive)
  (insert "↓"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shortcuts available in all modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Making the Mac cmd or Windows key useful, simply letting it act as
;; as its Alt cousin when pressed in combination with my most used
;; combinations (yes, I have re-mapped it in xmodmap, but when
;; changing keymaps too often, it goes totally astray and I sometimes
;; just must give in to the mightyness of the Super key).
(global-set-key [ (super backspace) ] 'backward-kill-word)
(global-set-key [ (super b) ] 'backward-word)
(global-set-key [ (super c) ] 'capitalize-word)
(global-set-key [ (super f) ] 'forward-word)
(global-set-key [ (super l) ] 'downcase-word)
(global-set-key [ (super u) ] 'upcase-word)
(global-set-key [ (super v) ] 'scroll-down)
(global-set-key [ (super w) ] 'kill-ring-save)
(global-set-key [ (super x) ] 'execute-extended-command)

;;(global-unset-key "\C-x\C-c") ;; quitting too often without wanting to
;;(global-set-key "\C-x\C-c" 'compile) ;; imenu
(global-set-key (kbd "<C-S-f10>") 'recompile)
(global-set-key (kbd "<C-tab>") 'completion-at-point)

;; newline and indent (like other editors, even vi, do).
(global-set-key  "\C-m" 'newline-and-indent)

(define-key query-replace-map [return] 'act)
(define-key query-replace-map [?\C-m] 'act)

;; Make Emacs wrap long lines visually, but not actually (i.e. no
;; extra line breaks are inserted.
(global-visual-line-mode 1)

;; Automatically reload files was modified by external program
(global-set-key  [ (f5) ] 'revert-buffer)
(global-auto-revert-mode 1)
(setq revert-without-query (list "\\.png$" "\\.svg$")
      auto-revert-verbose nil)

;; Give visual hint where the cursor is when switching buffers.
(use-package beacon
  :config
  (beacon-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Compile buffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package compile
  :init
  (setq compilation-ask-about-save nil
        compilation-scroll-output 'next-error
        ;; Don't stop on info or warnings.
        compilation-skip-threshold 2)
  )

;; Taken from https://emacs.stackexchange.com/questions/31493/print-elapsed-time-in-compilation-buffer/56130#56130
(make-variable-buffer-local 'my-compilation-start-time)

(add-hook 'compilation-start-hook #'my-compilation-start-hook)
(defun my-compilation-start-hook (proc)
  (setq my-compilation-start-time (current-time)))

(add-hook 'compilation-finish-functions #'my-compilation-finish-function)
(defun my-compilation-finish-function (buf why)
  (let* ((elapsed  (time-subtract nil my-compilation-start-time))
         (msg (format "Compilation took: %s" (format-time-string "%T.%N" elapsed t))))
    (save-excursion (goto-char (point-max)) (insert msg))
    (message "Compilation %s: %s" (string-trim-right why) msg)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Editing VC log messages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'log-edit-hook (lambda () (flyspell-mode 1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Multiple, real time replace
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c C->") 'mc/mark-all-like-this-dwim)
(global-set-key (kbd "C-c C-'") 'mc/mark-all-like-this-in-defun)

(use-package expand-region
  :bind
  ("C-=" . 'er/expand-region))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ivy, counsel and swiper. Mostly minibuffer and navigation
;; enhancements. Using smex for last recently used sorting.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package smex)

(use-package ivy
  :init
  (setq ivy-re-builders-alist '((t . ivy--regex-fuzzy))
        ivy-height 20
        ivy-initial-inputs-alist nil)
  )

(use-package ivy-posframe
  :init
  (setq ivy-posframe-display-functions-alist
        '((complete-symbol . ivy-posframe-display-at-point)
          (counsel-M-x     . ivy-posframe-display-at-frame-center)
          (t               . ivy-posframe-display-at-frame-center)))
  (ivy-posframe-mode 0))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind
  ("C-."   . 'counsel-imenu)
  ("C-c '" . 'counsel-git-grep)
  ("C-c ," . 'counsel-imenu)
  ("C-h f" . 'counsel-describe-function)
  ("C-h v" . 'counsel-describe-variable)
  ("C-x b" . 'counsel-switch-buffer)
  )
(global-set-key (kbd "C-s") 'isearch-forward)
(global-set-key (kbd "C-'") 'swiper-isearch-thing-at-point)

(use-package counsel-projectile
  :bind
  ("C-c p f" . 'counsel-projectile-find-file)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Buffers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make C-x C-b maximise the buffer list window, this saves two
;; additional shortcuts from the normal behaviour.
(use-package helm
  :init
  (defun list-buffers()
    (interactive)
    (let ((helm-full-frame t))
      (helm-mini)))

  :bind
  ("C-x C-b" . 'list-buffers))

(defun close-all-buffers ()
   (interactive)
  (mapc 'kill-buffer (buffer-list)))

;; buffer names and mini buffer
(use-package uniquify
  :ensure nil
  :init
  (setq uniquify-buffer-name-style 'forward
        uniquify-separator ":"
        uniquify-strip-common-suffix nil
        read-file-name-completion-ignore-case t))

;; Auto scroll the compilation window
(setq compilation-scroll-output t)

;; Scroll up and down while keeping the cursor where it is.
(defun help/scroll-up-one-line ()
  (interactive)
  (scroll-down 1))
(defun help/scroll-down-one-line ()
  (interactive)
  (scroll-up 1))
(global-set-key (kbd "M-p") 'help/scroll-down-one-line)
(global-set-key (kbd "M-n") 'help/scroll-up-one-line)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mail & news
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(require 'mu4e)

;; Create org notes with links to Email messages
;;(require 'org-mu4e)
;;(define-key mu4e-headers-mode-map (kbd "C-c c") 'org-mu4e-store-and-capture)
;;(define-key mu4e-view-mode-map    (kbd "C-c c") 'org-mu4e-store-and-capture)

;; Bookmarks
;;(add-to-list 'mu4e-bookmarks
;;             (make-mu4e-bookmark
;;              :name  "Flagged messages (🌟 in GMail)"
;;              :query "flag:flagged"
;;              :key ?f))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Name and email
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(setq user-full-name "Torstein Krause Johansen"
;;      user-mail-address "torstein@escenic.com")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mail (and news), common to both Gnus and VM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq gnus-agent-directory "~/mail/agent"
;;       gnus-article-save-directory "~/mail"
;;       gnus-cache-directory "~/mail/cache"
;;       gnus-directory "~/mail"
;;       gnus-dribble-directory "~/mail/dribble"
;;       gnus-local-organization "Escenic"
;;       mail-default-directory "~/mail"
;;       mail-from-style 'angles
;;       mail-interactive nil
;;       mail-self-blind t
;;       message-directory "~/mail"
;;       )

;;(setq mu4e-maildir "~/mail"
  ;;    mu4e-attachment-dir  "~/tmp"
    ;;  mu4e-get-mail-command "offlineimap"
      ;;mu4e-debug nil
      ;;mu4e-use-fancy-chars t
      ;; don't save messages to Sent Messages, Gmail/IMAP will take
      ;; care of this
      ;;mu4e-sent-messages-behavior 'trash

      ;;mu4e-view-show-images nil

      ;; Easier to read HTML email in dark themes
;;shr-color-visible-luminance-min 80

  ;;    mu4e-compose-signature t

      ;; See C-h v mu4e-header-info for more
    ;;  mu4e-headers-fields
     ;; '( (:date          .  12)
      ;;   (:maildir       .  20)
       ;;  (:from          .  22)
;;        '' (:subject       .  nil))

      ;; common SMTP settings for all accounts
;;      message-send-mail-function 'smtpmail-send-it

      ;; Make GPG work with emacs daemon (by default, Emacs will
      ;; attempt and fail to connect to the GPG agent and then fail
      ;; the GPG alltogether.
  ;;    epa-pinentry-mode 'loopback)

;; Navigate links in rich text email by Tab/Shift + Tab
;;(add-hook 'mu4e-view-mode-hook

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reading & writing files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/files.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto complete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package company
  :init
  (setq company-idle-delay 0.0
        company-global-modes '(not org-mode slack-mode
                                   )
        company-minimum-prefix-length 1))
(global-company-mode 1)
(global-set-key (kbd "<C-return>") 'company-complete)
(use-package company-emoji)
(add-to-list 'company-backends 'company-emoji)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSS mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/css.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; YAML
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package yaml-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Associate different modes with different file types.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq auto-mode-alist
      (append
       '(
         (".env" . conf-mode)
         ("ChangeLog" . change-log-mode)
         ("Dockerfile" . dockerfile-mode)
         ("Pipfile" . conf-mode)
         ("\\.awk\\'" . awk-mode)
         ("\\.bashrc\\'" . sh-mode)
         ("\\.bib\\'" . bibtex-mode)
         ("\\.blockdiag\\'" . perl-mode)
         ("\\.c\\'" . c-mode)
         ("\\.cgi\\'" . python-mode)
         ("\\.conf\\'" . conf-mode)
         ("\\.config\\'" . conf-mode)
         ("\\.cpp\\'" . c++-mode)
         ("\\.css\\'" . css-mode)
         ("\\.diff\\'" . diff-mode)
         ("\\.dtd\\'" . sgml-mode)
         ("\\.ebk\\'" . nxml-mode)
         ("\\.el\\'"  . emacs-lisp-mode)
         ("\\.emacs\\'" . emacs-lisp-mode)
         ("\\.es$" . c++-mode)
         ("\\.feature\\'"  . feature-mode)
         ("\\.htm\\'" . html-mode)
         ("\\.html\\'" . web-mode)
         ("\\.idl\\'" . c++-mode)
         ("\\.ini\\'" . conf-mode)
         ("\\.j2$" . web-mode)
         ("\\.java$" . java-mode)
         ("\\.jbk\\'" . nxml-mode)
         ("\\.js$" . js2-mode)
         ("\\.json$" . json-mode)
         ("\\.jsp$" . nxml-mode) ;; nxml-mode
         ("\\.jspf$" . nxml-mode) ;; nxml-mode
         ("\\.less\\'" . javascript-mode)
         ("\\.magik$" . python-mode)
         ("\\.md$" . markdown-mode)
         ("\\.odl\\'" . c++-mode)
         ("\\.org\\'" . org-mode)
         ("\\.patch\\'" . diff-mode)
         ("\\.pdf\\'" . doc-view-mode)
         ("\\.php\\'" . php-mode)
         ("\\.phtml\\'" . php-mode)
         ("\\.pl\\'" . perl-mode)
         ("\\.pp\\'" . ruby-mode)
         ("\\.properties.template\\'" . conf-mode)
         ("\\.properties\\'" . conf-mode)
         ("\\.puppet\\'" . puppet-mode)
         ("\\.py$" . python-mode)
         ("\\.py\\'" . python-mode)
         ("\\.sed\\'" . sh-mode)
         ("\\.service\\'" . ini-mode)
         ("\\.sh\\'" . sh-mode)
         ("\\.shtml\\'" . nxml-mode)
         ("\\.sl\\'" . json-mode)
         ("\\.sql\\'" . sql-mode)
         ("\\.target$" . nxml-mode)
         ("\\.tex\\'" . latex-mode)
         ("\\.text\\'" . text-mode)
         ("\\.tld.*\\'" . nxml-mode)
         ("\\.toml\\'" . conf-mode)
         ("\\.txt\\'" . text-mode)
         ("\\.vcl\\'" . java-mode)
         ("\\.vm\\'" . emacs-lisp-mode)
         ("\\.wfcfg\\'" . perl-mode)
         ("\\.wsdd\\'" . nxml-mode)
         ("\\.xml$" . nxml-mode) ;; psgml-mode, nxml-mode
         ("\\.xsd$" . nxml-mode) ;; xsl-mode
         ("\\.xsl$" . nxml-mode) ;; xsl-mode
         ("\\.yaml\\'" . yaml-mode)
         ("\\.yml\\'" . yaml-mode)
         ("\\Makefile$" . makefile-mode)
         ("\\config\\'" . conf-mode)
         ("\\makefile$" . makefile-mode)
         ("config" . conf-mode)
         ("control" . conf-mode)
         ("github.*\\.txt$" . markdown-mode)
         ("pom.xml" . nxml-mode)
         ("p4-diff-buffer" . diff-mode)
         )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Perl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq perl-indent-level 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hippe expansion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'hippie-exp "hippie-exp" t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Markdown
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package emojify
  :config
  (setq emojify-user-emojis
        '(
          (":face_with_monocle:" . (("name" . "Face with monocle") ("unicode" . "🧐") ("style" . "ascii")))
          (":facepalm:" . (("name" . "Facepalm") ("unicode" . "🤦") ("style" . "ascii")))
          (":home_office:" . (("name" . "Home office") ("unicode" . "⌂") ("style" . "ascii")))
          (":partyhat:" . (("name" . "Party hat") ("unicode" . "🎉") ("style" . "ascii")))
          (":simple_smile:" . (("name" . "Simple smile") ("unicode" . "🙂") ("style" . "ascii")))
          (":tux_devil:" . (("name" . "Tux devil") ("unicode" . "👿") ("style" . "ascii")))
          (":waving-from-afar-left:" . (("name" . "Waving from afar left") ("unicode" . "👋") ("style" . "ascii")))
          (":waving-from-afar-right:" . (("name" . "Waving from afar right") ("unicode" . "👋") ("style" . "ascii")))
          ))
  ;; If emojify is already loaded refresh emoji data
  (when (featurep 'emojify)
    (emojify-set-emoji-data))
  )
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown")
 ;; )


;;(use-package markdown-mode
  :config
  (add-hook 'markdown-mode-hook 'flyspell-mode)
  (add-hook 'markdown-mode-hook 'emojify-mode)
  (add-hook 'markdown-mode-hook 'visual-fill-column-mode)
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Yasnippets
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package yasnippet
  :init
  (setq yas/root-directory '("~/.emacs.d/snippets"))
  :config
  (autoload 'yas/expand "yasnippet" t)
  (autoload 'yas/load-directory "yasnippet" t)
  (mapc 'yas/load-directory yas/root-directory)
  (yas-global-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; awk
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'awk-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 2)
            (setq c-basic-offset 2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; java
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "~/.emacs.d/java.el")

(defun insert-serial-version-uuid()
  (interactive)
  (insert "private static final long serialversionuid = 1l;"))

(defun default-code-style-hook()
  (setq c-basic-offset 2
        c-label-offset 0
        tab-width 2
        indent-tabs-mode nil
        compile-command "mvn -q -o -f ~/src/content-engine/engine/engine-core/pom.xml test -dtrimstacktrace=false"
        require-final-newline nil))
(add-hook 'java-mode-hook 'default-code-style-hook)

(use-package flycheck
  :init
  (add-to-list 'display-buffer-alist
               `(,(rx bos "*flycheck errors*" eos)
                 (display-buffer-reuse-window
                  display-buffer-in-side-window)
                 (side            . bottom)
                 (reusable-frames . visible)
                 (window-height   . 0.15))))

;;(use-package idle-highlight)

(defun my-java-mode-hook ()
  (auto-fill-mode)
  (flycheck-mode)
  (git-gutter+-mode)
  (gtags-mode)
  (idle-highlight)
  (subword-mode)
  (yas-minor-mode)
  (set-fringe-style '(8 . 0))
  (define-key c-mode-base-map (kbd "C-M-j") 'insert-serial-version-uuid)
  (define-key c-mode-base-map (kbd "C-m") 'c-context-line-break)
  (define-key c-mode-base-map (kbd "S-<f7>") 'gtags-find-tag-from-here)

  ;; fix indentation for anonymous classes
  (c-set-offset 'substatement-open 0)
  (if (assoc 'inexpr-class c-offsets-alist)
      (c-set-offset 'inexpr-class 0))

  ;; indent arguments on the next line as indented body.
  (c-set-offset 'arglist-intro '++))
(add-hook 'java-mode-hook 'my-java-mode-hook)

(use-package projectile :ensure t)
(use-package yasnippet :ensure t)
(use-package lsp-mode :ensure t
  :bind (("\C-\M-b" . lsp-find-implementation)
         ("M-M" . lsp-execute-code-action))
  :config
  (setq lsp-inhibit-message t
        lsp-eldoc-render-all nil
        lsp-enable-file-watchers nil
        lsp-enable-symbol-highlighting nil
        lsp-headerline-breadcrumb-enable nil
        lsp-highlight-symbol-at-point nil
        lsp-modeline-code-actions-enable nil
        lsp-modeline-diagnostics-enable nil
        )

  ;; performance tweaks, see
  ;; https://github.com/emacs-lsp/lsp-mode#performance
  (setq gc-cons-threshold 100000000)
  (setq read-process-output-max (* 1024 1024)) ;; 1mb
  (setq lsp-idle-delay 0.500)
  )

(use-package hydra :ensure t)
(use-package company-lsp :ensure t)
(use-package lsp-ui
  :ensure t
  :config
  (setq lsp-prefer-flymake nil
        lsp-ui-doc-delay 5.0
        lsp-ui-sideline-enable nil
        lsp-ui-sideline-show-symbol nil))

(use-package lsp-java
  :ensure t
  :init
  (setq lsp-java-vmargs
        (list
         "-noverify"
         "-xmx3g"
         "-xx:+useg1gc"
         "-xx:+usestringdeduplication"
         "-javaagent:/home/franciscorevelles/.m2/repository/org/projectlombok/lombok/1.18.4/lombok-1.18.4.jar"
         )

        ;; don't organise imports on save
        lsp-java-save-action-organize-imports nil

        ;; fetch less results from the eclipse server
        lsp-java-completion-max-results 20

        ;; currently (2019-04-24), dap-mode works best with oracle
        ;; jdk, see https://github.com/emacs-lsp/dap-mode/issues/31
        ;;
        ;; lsp-java-java-path "~/.emacs.d/oracle-jdk-12.0.1/bin/java"
        ;; lsp-java-java-path "/usr/lib/jvm/java-11-openjdk-amd64/bin/java"
        ;; lsp-java-java-path "/library/java/javavirtualmachines/jdk-15.0.1.jdk/contents/home/bin/java/"
        lsp-java-java-path "/library/java/javavirtualmachines/jdk1.8.0_241.jdk/Contents/Home/bin/java"
        )
(setq lsp-java-configuration-runtimes '[(:name "JavaSE-8"
                                                 :path "/library/java/javavirtualmachines/jdk1.8.0_241.jdk/Contents/Home/bin/java"
                                                 :default t)])



  :config
  (add-hook 'java-mode-hook #'lsp))

(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t)
  (dap-tooltip-mode 1)
  (tooltip-mode 1)
  (dap-register-debug-template
   "localhost:5005"
   (list :type "java"
         :request "attach"
         :hostname "localhost"
         :port 5005))
  (dap-register-debug-template
   "lxd"
   (list :type "java"
         :request "attach"
         :hostname "10.152.112.168"
         :port 5005))
  )

(use-package dap-java
  :ensure nil
  :after (lsp-java)

  ;; the :bind here makes use-package fail to lead the dap-java block!
  ;; :bind
  ;; (("c-c r" . dap-java-run-test-class)

  ;;  ("c-c d" . dap-java-debug-test-method)
  ;;  ("c-c r" . dap-java-run-test-method)
  ;;  )

  :config
  (global-set-key (kbd "<f7>") 'dap-step-in)
  (global-set-key (kbd "<f8>") 'dap-next)
  (global-set-key (kbd "<f9>") 'dap-continue)
  )

(use-package treemacs
  :init
  (add-hook 'treemacs-mode-hook
            (lambda () (treemacs-resize-icons 15))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; clipboard. copy from terminal emacs to the x clipboard.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package xclip
  :ensure t
  :config
  (xclip-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; compilation mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; convert shell escapes to  color
(add-hook 'compilation-filter-hook
          (lambda () (ansi-color-apply-on-region (point-min) (point-max))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sql
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'sql-interactive-mode-hook
          '(lambda ()
             (company-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; web browser
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq browse-url-generic-program "/home/franciscorevelles/bin/chrome"
      browse-url-browser-function 'browse-url-generic)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; emacs behavior
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq warning-suppress-types (quote ((undo discard-info))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; for some reason, being on different networks (as experienced in
;; dhaka), the p4 integration made all file operation extremely slow,
;; hence the explicity loading here).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun load-p4()
  (interactive)
  (load "$home/.emacs.d/p4.el")
  (p4-opened))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; vc related settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package vc
  :ensure nil
  :config
  (setq
   ;; ignore white space when running annotate to see who
   ;; introduced actual code changes.
   vc-git-annotate-switches '("-w")
   ;; follow symlinks when opening files.
   vc-follow-symlinks t))

(use-package git-gutter+
  :config
  (setq git-gutter+-disabled-modes '(org-mode))
  ;; move between local changes
  (global-set-key (kbd "M-<up>") 'git-gutter+-previous-hunk)
  (global-set-key (kbd "M-<down>") 'git-gutter+-next-hunk))

;; customise the magit log view
(use-package magit
  :config
  (setq magit-log-arguments '("-n256" "--graph" "--decorate" "--color")
        ;; show diffs per word, looks nicer!
        magit-diff-refine-hunk t

        ;; easy switching between all repositories i'm working on
        magit-repository-directories
        '(
          ("~/src/build")
          ("~/src/build-tools")
          ("~/src/content-engine")
          ("~/src/ece-scripts")
          ("~/src/skybert-net")
          ("~/src/sse-proxy")
          ("~/src/user-manager")
          )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; xml and html
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/xml.el")
(use-package web-mode
  :config

  (setq web-mode-code-indent-offset 2
        web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-engines-alist
        '(("jinja"    . "\\.yaml\\'")
          ("jinja"    . "\\.html\\'")
          ("jinja"  . "\\.j2\\.")))

  (add-hook 'web-mode-hook
            (lambda ()
              (yas-minor-mode)
              (set (make-local-variable 'company-backends) '(company-web-html))
              (company-mode t))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; javascript mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq js2-basic-offset 2
      js2-indent-on-enter-key t
      js2-enter-indents-newline t
      js-indent-level 2
      )

(use-package tern
  :init
  (setq tern-explicit-port 35129

       ;; npm install tern
        tern-command '("~/node_modules/.bin/tern")))

;; (use-package company-tern
;;  :ensure t
;;  :config
;;  (add-to-list 'company-backends 'company-tern))

(use-package js2-mode
  :init
  (add-hook 'js2-mode-hook 'tern-mode)

  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; unfill
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun unfill-region ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-region (region-beginning) (region-end) nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto insert file templates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/auto-insert.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; tidy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tidy-buffer ()
  "run tidy html parser on current buffer."
  (interactive)
  (if (get-buffer "tidy-errs") (kill-buffer "tidy-errs"))
  (shell-command-on-region (point-min) (point-max)
                           "tidy -f /tmp/tidy-errs -q -wrap 72" t)
  (find-file-other-window "/tmp/tidy-errs")
  (other-window 1)
  (delete-file "/tmp/tidy-errs")
  (message "buffer tidy-ed"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; diff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq ediff-window-setup-function 'ediff-setup-windows-plain
      ediff-split-window-function 'split-window-horizontally ;; !work
      ediff-diff-options "-w"
      smerge-command-prefix "\c-cv")
;; restore window/buffers when you're finishd ediff-ing.
(add-hook 'ediff-after-quit-hook-internal 'winner-undo)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org-compat :ensure nil)
(use-package org-list :ensure nil)
(use-package org-element :ensure nil)
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package org
  :init
  (setq remember-annotation-functions '(org-remember-annotation))
  (setq remember-handler-functions '(org-remember-handler))
  (add-hook 'remember-mode-hook 'org-remember-apply-template)

  (setq org-agenda-tag-filter-preset '("-noreport")
        org-clock-persist 'history
        org-clock-mode-line-total 'today
        org-clock-out-remove-zero-time-clocks t
        org-return-follows-link t
        org-hide-emphasis-markers t
        org-reveal-theme "blood" ;; serif
        org-reveal-root "http://skybert.net/reveal.js"
        org-todo-keywords '((sequence "todo(t)" "started(s)" "waiting(w)" "pr(p)" "|" "merged(m)" "done(d)" "cancelled(c)" "delegated(g)"))
        org-agenda-files (list (concat "~/doc/scribbles/" (format-time-string "%y")))
        org-blank-before-new-entry '((heading . always) (plain-list-item . auto))
        org-capture-templates
        (quote (("t" "todo" entry (file "~/doc/scribbles/2020/work.org")
                 "** todo %?\n  scheduled: %t\n%a\n")
                ("r" "review" entry (file "~/doc/scribbles/2020/work.org")
                 "** todo %? review :noreport:\n  scheduled: %t\n%a\n")
                ("a" "adm" entry (file "~/doc/scribbles/2020/adm.org")
                 "** todo %? \n  scheduled: %t\n%a\n")
                ("i" "idea" entry (file "~/doc/ideas.org")
                 "** todo %?\n  scheduled: %t\n%a\n")))
        )

  ;; list style
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  (org-clock-persistence-insinuate)

  :bind
  (("\C-ca" . org-agenda)
   ("\C-ct" . org-capture))
  )

;; using org-present for presenting .org slides
(eval-after-load "org-present"
  '(progn
     (add-hook 'org-present-mode-hook
               (lambda ()
                 (org-present-big)
                 (org-display-inline-images)
                 (org-present-hide-cursor)
                 (org-present-read-only)))
     (add-hook 'org-present-mode-quit-hook
               (lambda ()
                 (org-present-small)
                 (org-remove-inline-images)
                 (org-present-show-cursor)
                 (org-present-read-write)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; date & time
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/time.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; various packages & settings to get smart file name completion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package projectile
  :bind
  (("C-c p f" . projectile-find-file))
  :init
  (setq projectile-enable-caching t
        projectile-globally-ignored-file-suffixes
        '(
          "blob"
          "class"
          "classpath"
          "gz"
          "iml"
          "ipr"
          "jar"
          "pyc"
          "tkj"
          "war"
          "xd"
          "zip"
          )
        projectile-globally-ignored-files '("tags" "*~")
        projectile-tags-command "/usr/bin/ctags -re -f \"%s\" %s"
        projectile-mode-line '(:eval (format " [%s]" (projectile-project-name)))
        )
  :config
  (projectile-global-mode)

  (setq projectile-globally-ignored-directories
        (append (list
                 ".pytest_cache"
                 "__pycache__"
                 "build"
                 "elpa"
                 "node_modules"
                 "output"
                 "reveal.js"
                 "semanticdb"
                 "target"
                 "venv"
                 )
                projectile-globally-ignored-directories))
  )

;; show search hits of strings in current buffer
;; http://oremacs.com/2015/01/26/occur-dwim/
(defun occur-dwim ()
  "call `occur' with a sane default."
  (interactive)
  (push (if (region-active-p)
            (buffer-substring-no-properties
             (region-beginning)
             (region-end))
          (let ((sym (thing-at-point 'symbol)))
            (when (stringp sym)
              (regexp-quote sym))))
        regexp-history)
  (call-interactively 'occur))
(global-set-key (kbd "M-S o") 'occur-dwim)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; imenu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package imenu-list
  :ensure t
  :config
  (setq imenu-list-focus-after-activation t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; chat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package erc-colorize)
;; (use-package erc-image)
;; (use-package erc-tweet)
;; (use-package erc
;;   :init
;;   (require 'erc-log)
;;   (require 'erc-autoaway)
;;   (require 'erc-replace)

;;   (setq erc-default-server "irc.freenode.net"
;;         erc-default-nicks '("skybert")
;;         erc-log-channels-directory "~/.erc/logs"
;;         erc-log-write-after-send t
;;         erc-log-write-after-insert t
;;         erc-autoaway-idle-seconds 600

;;         ;; logging and timestamps on the left
;;         erc-enable-logging t
;;         erc-save-buffer-on-part t
;;         erc-timestamp-only-if-changed-flag nil
;;         erc-timestamp-format "%y-%m-%d %h:%m "
;;         erc-fill-prefix "      "
;;         erc-insert-timestamp-function 'erc-insert-timestamp-left

;;         erc-track-exclude-types '("join" "part" "quit" "nick" "mode")
;;         erc-hide-list '("join" "part" "quit" "mode")
;;         erc-replace-alist
;;         '(
;;           (":+1:" . "👍")
;;           (":laughing:" . "😂")
;;           (":slightly_smiling_face:" . "😃")
;;           (":smiley:" . "😃")
;;           (":wink:" . "😉")
;;           ))
;;   )

;; (use-package alert)

;; ;; slack settings, slack-register-team and slack-start called from
;; ;; ~/.emacs.d/custom.el which is not checked in 😉
;; (use-package slack
;;   :init
;;   (setq slack-enable-emoji t
;;         slack-buffer-emojify t
;;         slack-typing-visibility 'buffer
;;         slack-prefer-current-team t
;;         slack-thread-also-send-to-room nil
;;         slack-buffer-create-on-notify t
;;         slack-display-team-name nil
;;         lui-prompt-string "skybert> "
;;         )

;;   ;;; bring up the mentions menu with `@', and insert a
;;   ;;; space afterwards.
;;   (define-key slack-mode-map "@"
;;     (defun endless/slack-message-embed-mention ()
;;       (interactive)
;;       (call-interactively #'slack-message-embed-mention)
;;       (insert " ")))
;;   (define-key slack-mode-map ":"
;;     (defun endless/slack-message-embed-emoji ()
;;       (interactive)
;;       (call-interactively #'slack-insert-emoji)
;;       (insert " ")))

;;   (add-hook 'slack-mode-hook 'flyspell-mode)

;;   (alert-define-style
;;    'slack-alert-style :title "tkj notifier style"
;;    :notifier
;;    (lambda (info)
;;      ;; the message text is :message
;;      (plist-get info :message)
;;      ;; the :title of the alert
;;      (plist-get info :title)
;;      ;; the :category of the alert
;;      (plist-get info :category)
;;      ;; the major-mode this alert relates to
;;      (plist-get info :mode)
;;      ;; the buffer the alert relates to
;;      (plist-get info :buffer)
;;      ;; severity of the alert.  it is one of:
;;      ;;   `urgent'
;;      ;;   `high'
;;      ;;   `moderate'
;;      ;;   `normal'
;;      ;;   `low'
;;      ;;   `trivial'
;;      (plist-get info :severity)
;;      ;; whether this alert should persist, or fade away
;;      (plist-get info :persistent)
;;      ;; data which was passed to `alert'.  can be
;;      ;; anything.
;;      (plist-get info :data)

;;      (save-excursion
;;        (set-buffer (get-buffer-create "*slack-messages*"))
;;        (goto-char (point-max))
;;        (insert
;;         (concat
;;          (format-time-string "%y-%m-%d %h:%m:%s")
;;          " 📺 " (plist-get info :title)
;;          (if (plist-get info :message)
;;              (concat " 📰 " (plist-get info :message)))
;;          "\n"))
;;        (write-region nil nil "~/.slack-messages.log" t)
;;        )

;;      ;; removers are optional.  their job is to remove
;;      ;; the visual or auditory effect of the alert.
;;      :remover
;;      (lambda (info)
;;        ;; it is the same property list that was passed to
;;        ;; the notifier function.
;;        )))

;;   (setq alert-default-style 'slack-alert-style)

;;   :bind
;;   ("c-c c-i" . 'slack-insert-emoji)
;;   ("c-c c-e" . 'slack-message-edit)
;;   ("c-c c-l" . 'slack-select-rooms)
;;   ("c-c c-r" . 'slack-message-add-reaction)
;;   ("c-c c-s" . 'slack-all-threads)
;;   ("c-c c-t" . 'slack-thread-show-or-create)
;;  ;; ("c-c c-u" . 'slack-select-unread-rooms)
;;   )

;; ;; shorten slack buffer names to #room. since this isn't configurable,
;; ;; overrride the function itself.
;; (cl-defmethod slack-buffer-name ((this slack-message-buffer))
;;   (slack-if-let* ((team (slack-buffer-team this))
;;                   (room (slack-buffer-room this))
;;                   (room-name (slack-room-name room team)))
;;       (concat "#" room-name)))
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; python
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package python
  :config
  (setq python-indent 4)
  )

(add-hook 'python-mode-hook 'flycheck-mode)
(add-hook 'python-mode-hook 'yas-minor-mode)
(add-hook 'python-mode-hook 'eldoc-mode)

(use-package lsp-python-ms
  :hook (python-mode . (lambda ()
                         (require 'lsp-python-ms)
                         (lsp)))
  :init
  (setq lsp-python-ms-executable (executable-find "python-language-server")))

(use-package dap-python
  :ensure nil
  :init
  (setq dap-python-executable  (executable-find "python")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; debugger
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package realgud
  :config
  (setq realgud-safe-mode nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; shell
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun spawn-shell (name)
  "create a new shell buffer
taken from http://stackoverflow.com/a/4116113/446256"

  (interactive "mname of shell buffer to create: ")
  (pop-to-buffer (get-buffer-create (generate-new-buffer-name name)))
  (shell (current-buffer)))

(defun my-shell-mode-hook ()
  (process-send-string (get-buffer-process (current-buffer))
                       "export pager=cat\n")
  (process-send-string (get-buffer-process (current-buffer))
                       "uprompt\n\n\n"))(
  add-hook 'shell-mode-hook 'my-shell-mode-hook)

(setq-default explicit-shell-file-name "/bin/bash")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; bash settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq sh-basic-offset 2
      sh-indentation 2)

;; snippets, please
(add-hook 'sh-mode-hook 'yas-minor-mode)

;; on the fly syntax checking
(add-hook 'sh-mode-hook 'flycheck-mode)

;; show git changes in the gutter
(add-hook 'sh-mode-hook 'git-gutter+-mode)

;; allow functions on the form <word>.<rest>(). without my change,
;; allowing punctuation characters in the function name,, only
;; <rest>() is allowed.
(setq sh-imenu-generic-expression
      (quote
       ((sh
         (nil "^\\s-*function\\s-+\\([[:alpha:]_][[:alnum:]\\s._]*\\)\\s-*\\(?:()\\)?" 1)
         (nil "^\\s-*\\([[:alpha:]_][[:alnum:]\\s._]*\\)\\s-*()" 1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; interpret shell escapes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun display-ansi-colors ()
  (interactive)
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region (point-min) (point-max))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; appearance
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(menu-bar-mode 0)

(defun load-graphical-settings()
  (interactive)
  ;; themes
  (add-to-list 'custom-theme-load-path "$home/.emacs.d/themes")
  (use-package sweet-theme)
  (load-theme 'sweet t)

  (if (eq system-type 'gnu/linux)
      (progn
        ;; favourite fonts: source code pro, terminus
        (set-face-attribute 'default nil
                            :family "source code pro"
                            :height 100
                            :weight 'normal
                            :width 'normal)))
  (set-cursor-color "red")
  (set-scroll-bar-mode nil)
  (setq-default cursor-type 'box)
  (tool-bar-mode 0)
  (set-fringe-style 0))

(when window-system
  (load-graphical-settings))

;; turn off unwanted clutter from the modeline
(use-package diminish
  :init
  (diminish 'abbrev-mode)
  (diminish 'auto-fill-mode)
  (diminish 'company-mode)
  (diminish 'eldoc-mode)
  (diminish 'flycheck-mode)
  (diminish 'git-gutter+-mode)
  (diminish 'gtags-mode)
  (diminish 'java-mode)
  (diminish 'projectile-mode)
  (diminish 'visual-line-mode)
  (diminish 'winner-mode)
  (diminish 'ws-butler-global-mode)
  (diminish 'ws-butler-mode)
  (diminish 'yas-minor-mode)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; appearance settings regardless of window system
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq frame-background-mode nil
      column-number-mode t
      frame-title-format (concat invocation-name "@" (system-name) " {%f}")
      inhibit-startup-screen t
      initial-scratch-message "# hi torstein, what do you want to do today?\n\n"
      initial-major-mode 'markdown-mode
      ;; no visible or audible bells, please
      visible-bell nil
      ring-bell-function (lambda nil (message "")))

;; nice window divider in tty emacs
(defun my-change-window-divider ()
  (let ((display-table (or buffer-display-table standard-display-table)))
    (set-display-table-slot display-table 5 ?│)
    (set-window-display-table (selected-window) display-table)))
(add-hook 'window-configuration-change-hook 'my-change-window-divider)

(defun presentation-mode()
  (interactive)
  (when window-system
    (progn
      (use-package one-themes)
      (load-theme 'one-light t)
      (set-face-attribute 'default nil
                          :family "source code pro"
                          :height 140
                          :weight 'normal
                          :width 'normal))))

(defun left-margin-focus()
  (interactive)
  (set-window-margins nil 10))

(defun left-margin-zero()
  (interactive)
  (set-window-margins nil 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; automatically expand these words and characters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-default 'abbrev-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; open files into this emacs instance from anywhere using
;; 'emacsclient <file>'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; is this causing '<key> undefined' errors? (server-start)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
