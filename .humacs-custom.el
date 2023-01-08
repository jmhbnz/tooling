(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (yasnippet-snippets yapfify yaml-mode xterm-color ws-butler writeroom-mode visual-fill-column winum web-mode web-beautify vterm volatile-highlights vi-tilde-fringe uuidgen unfill undo-tree treemacs-projectile treemacs-persp treemacs-magit treemacs-icons-dired treemacs-evil toc-org terminal-here tagedit symon symbol-overlay string-inflection sql-indent spaceline-all-the-icons memoize all-the-icons spaceline powerline smeargle slim-mode shell-pop seeing-is-believing scss-mode sass-mode rvm ruby-tools ruby-test-mode ruby-refactor ruby-hash-syntax rubocopfmt rubocop rspec-mode robe reveal-in-osx-finder restart-emacs rbenv rake rainbow-delimiters pytest pyenv-mode py-isort pug-mode prettier-js popwin pippel pipenv pyvenv pip-requirements persp-mode password-generator paradox ox-twbs ox-gfm ox-epub overseer osx-trash osx-clipboard orgit org-superstar org-re-reveal org-protocol-capture-html org-projectile org-category-capture org-present org-pomodoro alert log4e gntp org-mime org-download org-cliplink org-brain open-junk-file ob-sql-mode ob-go ob-async nodejs-repl nameless mwim multi-term move-text mmm-mode minitest markdown-toc magit-svn magit-gitflow magit macrostep lsp-ui lsp-treemacs treemacs cfrs pfuture posframe lsp-python-ms lorem-ipsum livid-mode skewer-mode live-py-mode link-hint launchctl kubernetes-tramp kubernetes-evil kubernetes magit-popup magit-section json-reformat json-navigator hierarchy js2-refactor multiple-cursors js2-mode js-doc indent-guide importmagic epc ctable concurrent deferred impatient-mode simple-httpd hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation helm-xref helm-themes helm-swoop helm-pydoc helm-purpose window-purpose imenu-list helm-projectile helm-org-rifle helm-org helm-mode-manager helm-make helm-lsp lsp-mode eldoc markdown-mode helm-ls-git helm-gitignore request helm-git-grep helm-flx helm-descbinds helm-css-scss helm-company helm-c-yasnippet helm-ag haml-mode google-translate golden-ratio godoctor go-tag go-rename go-impl go-guru go-gen-test go-fill-struct go-eldoc gnuplot gitignore-templates git-timemachine git-messenger git-link git-commit with-editor gh-md fuzzy flycheck-pos-tip pos-tip flycheck-package package-lint let-alist flycheck-elsa flycheck pkg-info epl flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-textobj-line evil-surround evil-org evil-numbers evil-nerd-commenter evil-matchit evil-lisp-state evil-lion evil-indent-plus evil-iedit-state evil-goggles evil-exchange evil-escape evil-ediff evil-cleverparens smartparens evil-args evil-anzu anzu eshell-z eshell-prompt-extras esh-help emr iedit clang-format projectile paredit list-utils emmet-mode elisp-slime-nav editorconfig nadvice dumb-jump dockerfile-mode docker transient tablist json-mode docker-tramp json-snatcher devdocs define-word cython-mode csv-mode company-web web-completion-data company-terraform terraform-mode hcl-mode company-lua lua-mode company-go go-mode company-anaconda company column-enforce-mode clojure-snippets clean-aindent-mode cider-eval-sexp-fu eval-sexp-fu cider sesman seq spinner queue parseedn clojure-mode map parseclj chruby centered-cursor-mode bundler inf-ruby blacken auto-yasnippet yasnippet auto-highlight-symbol ht auto-compile packed anaconda-mode pythonic f dash s aggressive-indent ace-window ace-link ace-jump-helm-line helm avy helm-core ac-ispell auto-complete popup which-key use-package pcre2el org-plus-contrib hydra lv hybrid-mode font-lock+ evil goto-chg dotenv-mode diminish bind-map bind-key async))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(set-face-background 'default "undefined")
(add-hook 'text-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook 'org-indent-mode)

;; Prevent undo tree files from polluting your git repo
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

;; Fix annoying indentation with shell script src blocks in org-mode
(setq org-edit-src-content-indentation 0)

;; Change indentation of org-mode headline tags to left
(setq org-tags-column 0)
