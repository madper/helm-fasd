;;; package --- Fast open frequently-used file/dir via fasd.
;;; Commentary:
;; (require 'helm-fasd)
;; (global-set-key (kbd "C-c e") 'helm-fasd)      ;; Or anyother key.
;; helm-fasd will feedback your opens to fasd's db by default.
;;; Code:
(require 'helm)
(defun get-all-files ()
  "Eeturn all files in the db."
  (split-string (shell-command-to-string  "fasd -sf | sort -hr | awk '{print $2}'" ) "\n"))

(defun get-all-dirs ()
  "Eeturn all files in the db."
  (split-string (shell-command-to-string  "fasd -sd | sort -hr | awk '{print $2}'" ) "\n"))

(setq some-helm-source
      '(((name . "files")
	 (candidates . get-all-files)
	 (action . (lambda (candidate)
		     (start-process "*fasd*" nil "fasd" "--add" candidate)
		     (find-file candidate))))
	((name . "dirs")
	 (candidates . get-all-dirs)
	 (action . (lambda (candidate)
		     (start-process "*fasd*" nil "fasd" "--add" candidate)
		     (find-file candidate))))))

(add-hook 'find-file-hook (lambda ()
			   (start-process "*fasd*" nil "fasd" "--add" (buffer-file-name))))
(defun helm-fasd ()
  "Fasd interface for helm."
  (interactive)
  (helm :sources some-helm-source))

;(global-set-key (kbd "C-c C-d") 'helm-fasd)   ;; go-mode will re-bind C-cC-d to godef-description.
;; (global-set-key (kbd "C-c e") 'helm-fasd)      ;; using C-ce instead
(provide 'helm-fasd)
;;; helm-fasd.el ends here
