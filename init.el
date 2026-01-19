;; https://gist.github.com/DavideDunne/878e67a82513b4d9600f16c30cf9b1ec
;; https://gist.github.com/DavideDunne/01266ea9f3cd65d75e436c40fb285677
;; https://gist.github.com/DavideDunne/2e02b9edba1dcdc8b22e6babf000a61e

;; Remove icons on top, I will preserve the file, edit, options... button on top of screen
(tool-bar-mode -1)

;; Enable tab-bar-mode
(tab-bar-mode 1)

;; point (cursor) is a line instead of a square
(setq-default cursor-type 'bar)

;; Stop creating backup files
(setq make-backup-files nil)

;; when you have a region and you write something in buffer, delete region
(delete-selection-mode 1)

;; Don't make beep sound
(set-message-beep 'silent)

;; Show line numbers
(global-display-line-numbers-mode 1)
;; show column
(column-number-mode)

;; Set frame (OS Window) full screen when Emacs initializes
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; M-+ M-- for zoom in and out
(global-set-key (kbd "M-+") 'text-scale-increase)
(global-set-key (kbd "M--") 'text-scale-decrease)
(global-set-key (kbd "M-_") 'text-scale-decrease)
;; C-+ for text-scale-adjust (zoom control)
(global-set-key (kbd "C-+") 'text-scale-adjust)

;; switch keybind for save without and with question
(global-set-key (kbd "C-x s") 'save-buffer)
(global-set-key (kbd "C-x C-s") 'save-some-buffers)

;; Set different font sizes for the org-mode bullets
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-level-1 ((t (:inherit outline-1 :height 1.7))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.5))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
 '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.0)))))

;; Jump line if line is too long in org-mode
(add-hook 'org-mode-hook #'(lambda () (setq fill-column 70)))
(add-hook 'org-mode-hook 'turn-on-auto-fill)

;; Where should org-agenda be getting it's schedules and tags from
(setq org-agenda-files (directory-files-recursively "~/.emacs.d/org-mode" "\\.org$"))

;; Don't make insert enable overwrite
(define-key global-map [(insertchar)] nil)

;; press RET in order to follow links in org-mode
(setq org-return-follows-link  t) 

;; Add Melpa Stable repository for package management
;; https://melpa.org/#/getting-started
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; disable auto-save
;; https://emacs.stackexchange.com/questions/76305/how-to-disable-the-generation-of-auto-save-files-e-g-file-org-file-org-ay
(auto-save-mode -1)

;; make sure all packages are updated
;; obtained from tutorial by Uncle Dave https://youtu.be/mBPQI71XaXU?si=-SWZLDxG8z2b4LNG
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Disable emacs main menu
;; https://youtu.be/4ZAKItc16OE?si=vrWHSbUqSKNcsUk5
(setq inhibit-startup-message t)

;; Enable ido-mode, better file suggestion when C-x C-f
;; Obtained from Uncle Dave tutorial https://youtu.be/JWMxvY2dFYA?si=P5VLijIeK09U5NDB
(setq ido-enable-flex-matching t)
(setq ido-create-new-buffer 'always)
(setq ido-everywhere t)
(ido-mode 1)
(use-package ido-vertical-mode
  :ensure t
  :init	(ido-vertical-mode 1))
(setq ido-vertical-define-keys 'C-n-and-C-p-only)
(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)
(global-set-key (kbd "C-x b") 'ibuffer)
(setq ibuffer-expert t)

;; When looking for a file look in C-x C-f, it will start in home directory
;; https://stackoverflow.com/questions/6464003/emacs-find-file-default-path
(setq default-directory "~/")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(modus-vivendi-tinted))
 '(package-selected-packages nil))


;; C-c e to visit init.el
;; C-c r to load init.el
(defun config-visit()
  (interactive)
  "open init.el file"
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "C-c e") 'config-visit)
(defun config-reload()
  (interactive)
  "reload Emacs"
  (org-babel-load-file (expand-file-name "~/.emacs.d/init.el")))
(global-set-key (kbd "C-c r") 'config-reload)

;; Seems like dashboard package needs this to work
;; been getting error: "QuitError muted by safe_call: (dashboard-resize-on-hook #<frame *dashboard* 0x13490b740>) signaled (file-missing "Cannot open load file" "No such file or directory" "projectile")"
(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-s-p" . projectile-command-map)))

;; A custom dashboard as startup screen
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))
(setq dashboard-items '((recents   . 10)
                        (bookmarks . 5)
                        (projects  . 5)
                        (agenda    . 10)
                        (registers . 5)))
(setq dashboard-week-agenda t)

;; Improve org-mode bullets, don't show asterisks
(use-package org-bullets 
:ensure t 
:hook((org-mode) . org-bullets-mode))

;; auto-completion
(use-package company
  :ensure t
  :init
  (add-hook ' after-init-hook 'global-company-mode))

;; press RET in order to follow links in org-mode
(setq org-return-follows-link  t)

;; Better window management
(use-package switch-window :ensure t)
(global-set-key (kbd "C-x o") 'switch-window)
(global-set-key (kbd "C-x 1") 'switch-window-then-maximize)
(global-set-key (kbd "C-x 2") 'switch-window-then-split-below)
(global-set-key (kbd "C-x 3") 'switch-window-then-split-right)
(global-set-key (kbd "C-x 0") 'switch-window-then-delete)
(global-set-key (kbd "C-x 4 d") 'switch-window-then-dired)
(global-set-key (kbd "C-x 4 f") 'switch-window-then-find-file)
(global-set-key (kbd "C-x 4 m") 'switch-window-then-compose-mail)
(global-set-key (kbd "C-x 4 r") 'switch-window-then-find-file-read-only)
(global-set-key (kbd "C-x 4 C-f") 'switch-window-then-find-file)
(global-set-key (kbd "C-x 4 C-o") 'switch-window-then-display-buffer)
(global-set-key (kbd "C-x 4 0") 'switch-window-then-kill-buffer)

;; Add RSS to Emacs
(use-package elfeed
  :ensure t
  :init (elfeed-update))
(global-set-key (kbd "C-x w") 'elfeed)
(setq elfeed-feeds
      '(("https://www.informador.mx/rss/jalisco.xml" Informador News)
	("https://www.informador.mx/rss/mexico.xml" Informador News)
	("http://www.npr.org/rss/rss.php?id=1001" NPR News)
	("https://stallman.org/rss/rss.xml" Stallman Blog)
	("https://protesilaos.com/master.xml" Protesilaos Blog)
	("https://hnrss.org/frontpage" HN News)
	("https://notxor.nueva-actitud.org/rss.xml" Noxtor Blog)
	("https://en.wikipedia.org/w/api.php?action=featuredfeed&feed=featured&feedformat=atom" Wikipedia)
	("https://planet.emacslife.com/atom.xml" PlanetEmacs Blog)
	("https://www.theguardian.com/international/rss" Guardian News)
	("https://udgtv.com/feed" UDGTV News)
	("https://ciudadolinka.com/feed/" CiudadOlinka News)
	("https://www.zonadocs.mx/feed/" ZonaDocs News)
	("https://archive.org/services/collection-rss.php?collection=hifidelity_potpourri" archive_hifidelity_potpourri Fun)
	("https://archive.org/services/collection-rss.php?collection=comics_inbox" archive_comics_inbox Fun)
	("https://archive.org/services/collection-rss.php?collection=manga_library" archive_manga_library Fun)
	("https://archive.org/services/collection-rss.php?collection=television_inbox" archive_television_inbox Fun)
	("https://archive.org/services/collection-rss.php?collection=anime" archive_anime Fun)
	("sinembargo.mx/feed" SinEmbargo News)
	("https://udgtv.com/podcast/guadalajara/cosa-publica-2-0/feed/19" udgtv_cosapublica Podcast)
	("https://udgtv.com/podcast/guadalajara/multiverso/feed/233" udgtv_multiverso Podcast)
	("https://udgtv.com/podcast/guadalajara/la-corte-del-rey-carmesi/feed/6566" udgtv_progrock Podcast)
	("https://udgtv.com/podcast/guadalajara/el-despenadero/feed/265" udgtv_metal Podcast)
	("https://udgtv.com/podcast/guadalajara/esto-no-es-jazz/feed/22582" udgtv_jazz Podcast)
	))

;; Open links from EWW
(defun my/open-link-in-eww ()
  "Open the link at point in EWW."
  (interactive)
  (let ((url (or (thing-at-point 'url)
                 (get-text-property (point) 'shr-url)
                 (get-text-property (point) 'help-echo))))
    (if url
        (eww url)
      (message "No URL found at point."))))

;; Open link in EWW with Reading mode enabled
(defun my/open-link-in-eww-reading-mode ()
  "Open the URL at point in EWW with reading mode enabled."
  (interactive)
  (let ((url (or (thing-at-point 'url)
                 (get-text-property (point) 'shr-url)
                 (get-text-property (point) 'help-echo))))
    (if url
        (progn
          (eww url)
          ;; Enable reading mode after EWW loads the page
          (add-hook 'eww-after-render-hook #'eww-readable nil 'local))
      (message "No URL found at point."))))
;; Global keybinding: M-RET opens link in EWW with reading mode
(global-set-key (kbd "M-RET") 'my/open-link-in-eww-reading-mode)

;; Use org-journal
(use-package org-journal
  :ensure t
  :defer t
  :init
  ;; Change default prefix key; needs to be set before loading org-journal
  (setq org-journal-prefix-key "C-c j ")
  :config
  (setq org-journal-dir "~/.emacs.d/org-mode/journal"
	;; Date format with day of the week, day of month, month name, year (Thursday, 04 July 2024)
        org-journal-date-format "%A, %d %B %Y"
	;; file format with number of week, day of month, month name, year (Ex. W27-01-Jul-2024.org)
	org-journal-file-format "W%W-%d-%b-%Y.org"
	;; will create a new org file each week
	org-journal-file-type 'weekly))
(global-set-key (kbd "C-c j n") 'org-journal-new-entry)
(global-set-key (kbd "C-c j t") 'org-journal-open-current-journal-file)

;; Set org-mode tags that I will use in most of my notes
(setq org-tag-alist '(("work" . ?w) ("hobby" . ?h) ("study" . ?s)))

(defun org-link-copy (&optional arg)
  "Extract URL from org-mode link and add it to kill ring."
  (interactive "P")
  (let* ((link (org-element-lineage (org-element-context) '(link) t))
          (type (org-element-property :type link))
          (url (org-element-property :path link))
          (url (concat type ":" url)))
    (kill-new url)
    (message (concat "Copied URL: " url))))
(global-set-key (kbd "C-c p") 'org-link-copy)

;; Set the frame (OS window) max size
(defun my/set-full-frame ()
  "make frame cover all screen"
  (interactive)
  (set-frame-parameter nil 'fullscreen 'maximized)
  (message "frame maximized"))
(global-set-key (kbd "C-c f") 'my/set-full-frame)

;; Setup yasnippet for creating templates
;; https://youtu.be/W-bRZlseNm0?si=KQpbbfsXnDsIQ_Wm
(use-package yasnippet
  :ensure t
  :config
  (setq yas-snippet-dir "~/.emacs.d/snippets")
  (yas-global-mode 1))

;; Remove indentation in org-mode src code blocks
;; https://stackoverflow.com/a/9768225
(setq org-edit-src-content-indentation 0)

;; Use Denote, a note taking system
(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :bind
  (("C-c n n" . denote)
   ("C-c n r" . denote-rename-file)
   ("C-c n l" . denote-link)
   ("C-c n b" . denote-backlinks)
   ("C-c n d" . denote-dired)
   ("C-c n g" . denote-grep))
  :config
  (setq denote-directory (expand-file-name "~/.emacs.d/org-mode/denote"))
  (denote-rename-buffer-mode 1))

;; https://youtu.be/QNzNR-K2biI?si=q6bGyYEiKiHmYizN
;; M-x org-speed-command-help
(setq org-use-speed-commands t)

;; https://www.youtube.com/live/IspAZtNTslY?si=Lyf5RHvpSc9fC14s&t=846
;; nice colors for lisp parenthesis
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; enable which-key, started to get included in Emacs 30
;; completion for Emacs keys
(which-key-mode)

(use-package magit
  :ensure t)

;; add file vertical file tree bar in left
;; part of making Emacs into an IDE
;; C-c C-p in treemacs
;; https://youtu.be/Bu7nF9hPSts?si=Vbk4YvG669AmG3h_
(use-package treemacs
  :ensure t
  :bind (:map global-map
	      ("C-c t" . treemacs-select-window)))

;; bring vs-code sticky header feature
(use-package org-sticky-header
  :ensure t
  :hook ((org-mode) . org-sticky-header-mode)
  :config
  (setq org-sticky-header-full-path 'full)
  (setq org-sticky-header-outline-path-separator " > "))

;; custom org-agenda views
(setq org-agenda-custom-commands
      '(("m" "Monthly Agenda"
         ((agenda "" ((org-agenda-span 'month)))))
	("3" "3 month agenda"
	 ((agenda "" ((org-agenda-span 90)))))
	("d" "Daily agenda"
	 ((agenda "" ((org-agenda-span 1)))))))

;; The way we display each element in org-agenda
(setq org-agenda-prefix-format
      '((dashboard-agenda . " %i %-12:c %s ")
	(agenda . " %?-12t% s") ; Default: " %i %-12:c%?-12t% s"
	(todo . " %i %-12:c")
	(tags . " %i %-12:c")
	(search . " %i %-12:c")))

;; Open files in OS default instead of directly on Emacs
(eval-after-load 'org
  '(progn
     (add-to-list 'org-file-apps '("\\.xls?x?\\'" . default))
     (add-to-list 'org-file-apps '("\\.mp[34]\\'" . default))))

;; like control-n in vs code
;; create buffer not linked to a file
(defun temporary-empty-buffer (buffer-name)
  "Opens a new empty buffer."
  (interactive "sBuffer name: ")
  (switch-to-buffer (generate-new-buffer (format "*Temporary buffer* - %s" buffer-name)))
  (funcall initial-major-mode)
  (text-mode)
  (put 'buffer-offer-save 'permanent-local t)
  (setq buffer-offer-save t))
(defun org-temporary-empty-buffer (buffer-name)
  "Opens a new empty buffer."
  (interactive "sBuffer name: ")
  (switch-to-buffer (generate-new-buffer (format "*Org temporary buffer* - %s" buffer-name)))
  (funcall initial-major-mode)
  (org-mode)
  (put 'buffer-offer-save 'permanent-local t)
  (setq buffer-offer-save t))
