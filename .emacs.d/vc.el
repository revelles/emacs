;; VC related changes, also see tkj-p4.el for p4 specific changes

;; Remove the 'Git-' prefix from the modeline when displaying the
;; current branch.
;;
;; This breaks when setting a simple mode line, see
;; 229a7d3ad443a2c4d9b65c7fc045c8d86e397d94
;;
;; (setcdr (assq 'vc-mode mode-line-format)
;;         '((:eval (replace-regexp-in-string "^ Git-" " " vc-mode))))
