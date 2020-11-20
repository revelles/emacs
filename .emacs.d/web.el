(defun tkj-tidy-up-css()
  (interactive)
  (goto-char 0)
  (replace-string ";" ";
")
  (goto-char 0)
  (replace-string "{" "
{
")
  (goto-char 0)
  (replace-string "}" "
}
")
  (indent-region (point-min) (point-max)))
(global-set-key (kbd "C-x s") 'tkj-tidy-up-css)
