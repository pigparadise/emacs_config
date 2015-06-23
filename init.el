;; -------- basic load path --------
(add-to-list 'load-path "/usr/share/emacs/site-lisp")
(add-to-list 'load-path "~/.emacs.d/")

;; -------- 插件管理 --------
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(require 'el-get)
(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get/recipes")

;; my packages
(setq my-packages
      (append
       '(popup fuzzy auto-complete auto-complete-clang 
	       color-theme
	       php-mode lua-mode jinja2-mode protobuf-mode js2-mode
	       )
       (mapcar 'el-get-as-symbol (mapcar 'el-get-source-name el-get-sources))))

(el-get 'sync my-packages)

;; -------- GUI --------
;; 行列号显示模式
(column-number-mode t)

;; 禁用启动信息
;;(setq inhibit-startup-message t)

;; 去掉菜单栏
(menu-bar-mode nil)

;; 去掉工具栏
(tool-bar-mode nil)

;; 去掉滚动栏
(scroll-bar-mode nil)

;; 显示匹配的括号
(show-paren-mode t)

;; shell程序
(setq shell-file-name "/bin/bash")

;; 防止页面滚动时跳动, 在靠近屏幕边沿n行时就开始滚动，方便看上下文
(setq scroll-margin 7 scroll-conservatively 10000)


;; -------- code viewer --------
(require 'xcscope)
;; (add-hook 'c-mode-common-hook
;; '(lambda ()
;; (require 'xcscope)))

;; font
;; (set-default-font "Courier 10 Pitch-11")
;; (set-default-font "Monaco-11")

;; color theme
(load "~/.emacs.d/color-theme-molokai.el")
(color-theme-molokai)


;; 空格,tab等不可见符号
(require 'whitespace)
(setq whitespace-space 'underline)
(setq whitespace-display-mappings
  '(
    (space-mark   ?\     [? ]) ;; use space not dot
    (space-mark   ?\xA0  [?\u00A4]     [?_])
    (space-mark   ?\x8A0 [?\x8A4]      [?_])
    (space-mark   ?\x920 [?\x924]      [?_])
    (space-mark   ?\xE20 [?\xE24]      [?_])
    (space-mark   ?\xF20 [?\xF24]      [?_])
    (newline-mark ?\n    [?$ ?\n])
    (tab-mark     ?\t    [?\u00BB ?\t] [?\\ ?\t])
  )
)

;; Tab缩进
(setq-default indent-tabs-mode nil) ;;用空格代替tab
(setq default-tab-width 2); 每次按tab缩进的空格数ggggg
(setq tab-width 2)
(setq tab-stop-list (number-sequence 2 200 2)) ;每次tab的跳转停留


;; -------- 语法高亮 --------
;; php-mode
(require 'php-mode)
(add-to-list 'auto-mode-alist
             '("\\.php[34]?\\'\\|\\.phtml\\'" . php-mode))
;; jinja-mode
(require 'jinja2-mode)
(add-to-list 'auto-mode-alist '("\\.pat$\\|\\.jinja$" . jinja2-mode))

;; jinja-mode
(add-to-list 'auto-mode-alist '("\\.ejs$" . html-mode))

;; protobuf-mode
(require 'protobuf-mode)
(add-to-list 'auto-mode-alist '("\\.proto$" . protobuf-mode))

(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; lua-mode
(require 'lua-mode)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))


;; -------- 代码补全 --------
;; autocomplete
(add-to-list 'load-path "~/.emacs.d/el-get/auto-complete")
(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/el-get/auto-complete/dict")
(ac-config-default)

(add-to-list 'load-path "~/.emacs.d/el-get/auto-complete-clang")
(require 'auto-complete-clang)

(setq ac-quick-help-delay 1)
;; (setq ac-auto-start nil)
;; (ac-set-trigger-key "TAB")
;; (define-key ac-mode-map  [(control tab)] 'auto-complete)
;; (define-key ac-mode-map  "\C-a" 'auto-complete)
(defun my-ac-config ()
  (setq ac-clang-flags  
        (mapcar(lambda (item)(concat "-I" item))
               (split-string    ;; echo "" | g++ -v -x c++ -E -
                "
 /usr/include/c++/4.6
 /usr/include/c++/4.6/x86_64-linux-gnu/.
 /usr/include/c++/4.6/backward
 /usr/lib/gcc/x86_64-linux-gnu/4.6/include
 /usr/local/include
 /usr/lib/gcc/x86_64-linux-gnu/4.6/include-fixed
 /usr/include/x86_64-linux-gnu
 /usr/include
")))  
  (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))  
  (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)  
  ;; (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)  
  (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)  
  (add-hook 'css-mode-hook 'ac-css-mode-setup)  
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)  
  (global-auto-complete-mode t))
(defun my-ac-cc-mode-setup ()
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
;; ac-source-gtags
(my-ac-config)


;; -------- 一些emacs自动生成的设置, 比如开启功能等 --------
;; GUI设置后自动生成的
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
)
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  '(whitespace-space
    ((((class color) (background dark)) (:background "none" :foreground "none"))
     (((class color) (background light)) (:background "none" :foreground "none"))
     (t (:inverse-video t))
    )
   )
)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
