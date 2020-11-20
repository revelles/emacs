;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Jira
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org-jira
  :config
  (setq jiralib-url "https://cci-jira.ccieurope.com"
        org-jira-download-dir "~/tmp"
        org-jira-working-dir (concat "~/doc/" (format-time-string "%Y") "/org-jira"))
  )
