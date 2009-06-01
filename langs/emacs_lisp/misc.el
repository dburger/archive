;; miscellaneous simple functions demonstrating various Emacs Lisp techniques
;; Copyright (C) 2003  David J. Burger, dburger@hawaii.edu

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; Demonstrates how to add another regular expression to the
;; compilation-error-regexp-alist.  This example would allow emacs to locate
;; ant generated errors without having to do an ant -emacs when invoking.
(eval-after-load "compile"
  '(add-to-list 'compilation-error-regexp-alist
		'(".*\\(/[^\n]*\\):\\([0-9]+\\):" 1 2)))

(defun yes-or-no-p (prompt)
  "Redefines yes-or-no-p to work with y or n.  This is unecessary as Emacs has
a built in y-or-n-p function that can be used with setf on yes-or-no-p.
PROMPT is the prompt to display to the user
Returns either t or nil"
  (let ((answer nil))
    (while (not (or (equal answer "y")
		    (equal answer "n")))
      (setq answer (read-from-minibuffer (concat prompt " (y or n?) "))))
    (equal answer "y")))

(defun fill-buffer ()
  "Fills the current buffer."
  (interactive)
  (save-restriction
    (save-excursion
      (widen)
      (fill-region (point-min) (point-max)))))

(defun unfill-region (beg end)
  "Removes carriage returns from the region.
BEG is the beginning of the region.
END is the end of the region."
  (interactive "r")
  (save-excursion
    (while (< beg end)
      (goto-char beg)
      (if (= (char-after) 10)
	  (progn
	    (delete-char 1)
	    (insert " ")
	    (setq end (1- end)))
	(incf beg)))))

(defun wc ()
  "Produces word count information for current buffer.
Returns (lines words chars) and messages the values."
  (interactive)
  (wc-buffer (current-buffer)))

(defun wc-buffer (buffer)
  "Produces the word count information for buffer.
BUFFER is the buffer to do the word count for.
Returns (lines words chars) and messages the values."
  (interactive "bEnter buffer: ")
  (if (not buffer)
      (setq buffer (current-buffer)))
  (save-excursion
    (set-buffer buffer)
    (save-restriction
      (widen)
      (wc-region (point-min) (point-max)))))

(defun wc-file (filename)
  "Produces the word count information for file.
FILENAME is the file to do the word count for.
Returns (lines words chars) and messages the values, or nil if file-error."
  (interactive "fEnter filename: ")
  (with-temp-buffer
    (if (condition-case nil (insert-file-contents filename) (file-error nil))
	(wc-region (point-min) (point-max)))))

(defun wc-region (beg end)
  "Produces the word count information for the selected region.
BEG is the beginning of the region.
END is the end of the region.
Returns (lines words chars) and messages the values."
  (interactive "r")
  (save-excursion
    (let ((counts nil))
      (goto-char beg)
      (push ((lambda ()
	       (let ((count 0))
		 (while (and (condition-case nil (not (forward-char))
			       (error nil))
			     (incf count)
			     (< (point) end)))
		 count)))
	    counts)
      (goto-char beg)
      (push ((lambda ()
	       (let ((count 0))
		 (while (and (forward-word 1)
			     (incf count)
			     (< (point) end)))
		 count)))
	    counts)
      (goto-char beg)
      (push ((lambda ()
	       (let ((count 0))
		 (while (and (= (forward-line 1) 0)
			     (incf count)
			     (< (point) end)))
		 count)))
	    counts)
      (message "%s" counts)
      counts)))

(defun google-link-word ()
  "Creates a hyperlink for googling the current word.
Returns the new point."
  (interactive)
  (let ((beg)
	(end))
    (forward-word 1)
    (setq end (point))
    (backward-word 1)
    (setq beg (point))
    (google-link-region beg end)))

(defun google-link-region (beg end)
  "Creates a hyperlink for googling the words in the region.
Returns the new point."
  (interactive "*r")
  (let* ((text (buffer-substring beg end))
	 (query-text (replace-regexp-in-string "[ ]+" "+" text))
	 (link (format "<a href=\"http://www.google.com/search?q=%s\">" query-text)))
    (goto-char beg)
    (insert link)
    (goto-char (+ end (length link)))
    (insert "</a>")
    (point)))
