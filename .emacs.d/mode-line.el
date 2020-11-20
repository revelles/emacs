;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Remove uninteresting information from the mode line
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package diminish
  :config
  (diminish 'abbrev-mode)
  (diminish 'auto-fill-function)
  (diminish 'auto-revert-mode)
  (diminish 'command-log-mode)
  (diminish 'company-mode)
  (diminish 'company-search-mode)
  (diminish 'compilation-minor-mode)
  (diminish 'eclim-mode)
  (diminish 'flyspell-mode)
  (diminish 'git-gutter+-mode)
  (diminish 'projectile-mode)
  (diminish 'slack-mode)
  (diminish 'slack-message-buffer-mode)
  (diminish 'slack-thread-mode)
  (diminish 'slack-thread-message-buffer-mode)
  (diminish 'undo-tree-mode)
  (diminish 'visual-line-mode)
  (diminish 'ws-butler-mode)
  (diminish 'yas-minor-mode)
  )

;; Set minimal, but good looking header line (instead of mode line)
(set-face-attribute
 'header-line nil
 :height 100
 :underline "black"
 :foreground "#1e8967"
 :background "black"
 :box `(:line-width 3 :color "black" :style nil))
(defun mode-line-render (left right)
  "Return a string of `window-width' length containing left, and
   right aligned respectively."
  (let* ((available-width (- (window-total-width) (length left) )))
    (format (format "%%s %%%ds" available-width) left right)))
(setq-default
 header-line-format
 '(:eval
   (mode-line-render
    (format-mode-line
     (list
      (propertize "%b" 'face `(:weight regular :color "red"))
      '(:eval
        (if (and buffer-file-name (buffer-modified-p))
            (propertize " (modified)"
                        'face `(:weight light :foreground "#b33c49"))))))
    (format-mode-line
     (propertize "%3l:%2c "
                 'face `(:weight light :foreground "#ff0000"))))))

;; No mode line, only a line of colour
(setq-default mode-line-format   "")
(set-face-attribute
 'mode-line nil
 :height 0.1
 :underline "black"
 :background "#87af5f"
 :foreground "white"
 :box nil)
(set-face-attribute
 'mode-line-inactive nil
 :height 0.1
 :background "#3a3f4b"
 :foreground "white"
 :box '(:line-width 1 :color "#3a3f4b")
 :overline nil
 :underline nil)
