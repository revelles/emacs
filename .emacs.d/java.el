;; -*- emacs-lisp -*-

(defun insert-serial-version-uuid()
  (interactive)
  (insert "private static final long serialVersionUID = 1L;"))

(defun default-code-style-hook()
  (setq c-basic-offset 2
        c-label-offset 0
        tab-width 2
        indent-tabs-mode nil
        compile-command "mvn -q -o -f ~/src/content-engine/pom.xml install"
        require-final-newline nil))
(add-hook 'java-mode-hook 'default-code-style-hook)

(use-package idle-highlight)

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

  ;; Fix indentation for anonymous classes
  (c-set-offset 'substatement-open 0)
  (if (assoc 'inexpr-class c-offsets-alist)
      (c-set-offset 'inexpr-class 0))

  ;; Indent arguments on the next line as indented body.
  (c-set-offset 'arglist-intro '++))
(add-hook 'java-mode-hook 'my-java-mode-hook)

(use-package hydra :ensure t)
(use-package company-lsp :ensure t)
;; (use-package treemacs :ensure t)
(use-package lsp-mode
  :ensure t
  :config
  (setq lsp-inhibit-message t
        lsp-eldoc-render-all nil
        lsp-enable-file-watchers nil
        lsp-highlight-symbol-at-point nil))

(use-package lsp-ui
  :ensure t
  :config
  (setq lsp-prefer-flymake nil
        lsp-ui-doc-delay 5.0
        lsp-ui-sideline-enable nil
        lsp-ui-sideline-show-symbol nil))

(use-package lsp-java
  :ensure t
  :after lsp
  :bind (("\C-\M-b" . lsp-find-implementation)
         ("M-RET" . lsp-execute-code-action))

  :config
  (add-hook 'java-mode-hook 'lsp)
  (setq lsp-java-vmargs
        (list
         "-noverify"
         "-Xmx1G"
         "-XX:+UseG1GC"
         "-XX:+UseStringDeduplication"
         "-javaagent:/home/franciscorevelles/.m2/repository/org/projectlombok/lombok/1.18.6/lombok-1.18.6.jar"
         )

        ;; Don't organise imports on save
        lsp-java-save-action-organize-imports nil

        ;; Currently (2019-04-24), dap-mode works best with Oracle
        ;; JDK, see https://github.com/emacs-lsp/dap-mode/issues/31
        lsp-java-java-path "/Library/Java/JavaVirtualMachines/jdk1.8.0_241.jdk/Contents/Home"
        )
  )

(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t)
  (dap-register-debug-template
   "um debug"
   (list :type "java"
         :request "attach"
         :hostName "172.18.0.200"
         :port 5005))
  )

(use-package dap-java
  :ensure nil
  :after (lsp-java)
  :config
  (global-set-key (kbd "<f7>") 'dap-step-in)
  (global-set-key (kbd "<f8>") 'dap-next)
  (global-set-key (kbd "<f9>") 'dap-continue)
  )
;; (use-package lsp-java-treemacs :ensure nil :after (treemacs))
