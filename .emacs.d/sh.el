(defun tkj-shunit-disable-all-tests()
  (interactive)
  (save-excursion
    (goto-char 0)
    (while (search-forward "test_" nil t)
      (replace-match "not_test_" nil t))))

(defun tkj-shunit-enable-all-tests()
  (interactive)
  (save-excursion
    (goto-char 0)
    (while (search-forward "not_test_" nil t)
      (replace-match "test_" nil t))))
