;;; flyspell-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "flyspell" "flyspell.el" (0 0 0 0))
;;; Generated autoloads from flyspell.el

(defvar flyspell-mode-line-string " Fly" "\
*String displayed on the modeline when flyspell is active.
Set this to nil if you don't want a modeline indicator.")

(custom-autoload 'flyspell-mode-line-string "flyspell" t)

(autoload 'flyspell-prog-mode "flyspell" "\
Turn on `flyspell-mode' for comments and strings." t nil)

(defvar flyspell-mode nil)

(defvar flyspell-mode-map (make-sparse-keymap))

(autoload 'flyspell-mode "flyspell" "\
Minor mode performing on-the-fly spelling checking.
Ispell is automatically spawned on background for each entered words.
The default flyspell behavior is to highlight incorrect words.
With no argument, this command toggles Flyspell mode.
With a prefix argument ARG, turn Flyspell minor mode on iff ARG is positive.
  
Bindings:
\\[ispell-word]: correct words (using Ispell).
\\[flyspell-auto-correct-word]: automatically correct word.
\\[flyspell-auto-correct-previous-word]: automatically correct the last misspelled word.
\\[flyspell-correct-word] (or down-mouse-2): popup correct words.

Hooks:
This runs `flyspell-mode-hook' after flyspell is entered.

Remark:
`flyspell-mode' uses `ispell-mode'.  Thus all Ispell options are
valid.  For instance, a personal dictionary can be used by
invoking `ispell-change-dictionary'.

Consider using the `ispell-parser' to check your text.  For instance
consider adding:
\(add-hook 'tex-mode-hook (function (lambda () (setq ispell-parser 'tex))))
in your .emacs file.

\\[flyspell-region] checks all words inside a region.
\\[flyspell-buffer] checks the whole buffer.

\(fn &optional ARG)" t nil)

(if (fboundp 'add-minor-mode) (add-minor-mode 'flyspell-mode 'flyspell-mode-line-string flyspell-mode-map nil 'flyspell-mode) (or (assoc 'flyspell-mode minor-mode-alist) (setq minor-mode-alist (cons '(flyspell-mode flyspell-mode-line-string) minor-mode-alist))) (or (assoc 'flyspell-mode minor-mode-map-alist) (setq minor-mode-map-alist (cons (cons 'flyspell-mode flyspell-mode-map) minor-mode-map-alist))))

(autoload 'flyspell-version "flyspell" "\
The flyspell version" t nil)

(autoload 'flyspell-mode-off "flyspell" "\
Turn Flyspell mode off." nil nil)

(autoload 'flyspell-region "flyspell" "\
Flyspell text between BEG and END.

\(fn BEG END)" t nil)

(autoload 'flyspell-buffer "flyspell" "\
Flyspell whole buffer." t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "flyspell" '("flyspell-" "mail-mode-flyspell-verify" "make-flyspell-overlay" "sgml-mode-flyspell-verify" "tex")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; flyspell-autoloads.el ends here
