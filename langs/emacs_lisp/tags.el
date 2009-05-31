;; functions used to look for attributes within tags in tag/attribute documents
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
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

;; Note: these functions do not work if the tag/attributes splits across lines,
;;       needs a regular expression fix.

(global-set-key "\C-cb" 'next-hyperlink-backward)
(global-set-key "\C-cf" 'next-hyperlink-forward)
(global-set-key "\C-chr" 'harvest-tag-attributes-region)
(global-set-key "\C-chb" 'harvest-tag-attributes-buffer)
(global-set-key "\C-ctf" 'next-tag-attribute-forward)
(global-set-key "\C-ctb" 'next-tag-attribute-backward)

(defun find-tag-attribute-internal (tag attr end nofail dir)
  "Locates and returns the attribute value for the given tag.
TAG is the tag we are interested in
ATTR is the attribute value we are looking for within tag
END bounds the search region
NOFAIL nil if you want error message
DIR direction and repeat count of the search"
  (let ((regex
	 (format "<%s.*%s\\s-*=\\s-*\\(\"\\|'\\)\\([^'\"]*\\)" tag attr)))
    (and (re-search-forward regex end nofail dir) (match-string 2))))

(defun harvest-tag-attributes-region-internal (tag attr beg end)
  "Harvest all attribute values for tag in the region beg to end.
Places the attributes at the head of the kill-ring separated by newlines
and returns the number of attribute values harvested.
TAG is the tag we are interested in harvesting from
ATTR is the attribute to harvest
BEG is the beginning of the harvest region
END is the end of the harvest region"
  (let (value
        (values "")
        (count 0))
    (save-excursion
      (goto-char beg)
      (while (and (< (point) end)
		  (setq value (find-tag-attribute-internal tag attr end t 1)))
        (setq values (concat values value "\n"))
        (setq count (1+ count))))
    (if (> count 0)
        (kill-new values))
    count))

(defun harvest-tag-attributes-region (beg end)
  "Prompt for, and harvest all attribute values for tag in the region.
Places the attributes at the head of the kill-ring separated by newlines.
BEG is the beginning of the harvest region
END is the end of the harvest region"
  (interactive "r")
  (let  (count
         (tag (read-from-minibuffer "Tag: "))
         (attr (read-from-minibuffer "Attribute: ")))
    (message "Harvesting %s attributes..." attr)
    (setq count (harvest-tag-attributes-region-internal tag attr beg end))
    (message "%d %s attributes harvested." count attr)))

(defun harvest-tag-attributes-buffer ()
  "Prompt for, and harvests all the attributes of the specified tag in the
buffer.  Places the attributes at the head of the kill-ring separated by
newlines.  Will harvest from the entire buffer even if restrictions are in
place."
  (interactive)
  (save-restriction
    (save-excursion
      (let ((tag (read-from-minibuffer "Tag: "))
            (attr (read-from-minibuffer "Attribute: ")))
        ; can't just call the harvest-tag-attributes-region-internal
        ; or the widen will be visible to the user when tag and attr
        ; are asked for
        (widen)
        (let (count
              (beg (point-min))
              (end (point-max)))
          (message "Harvesting %s attributes..." attr)
          (setq count
		(harvest-tag-attributes-region-internal tag attr beg end))
	  (message "%d %s attributes harvested." count attr))))))

(defun next-tag-attribute-forward ()
  "Locates and returns the next attribute value for tag within the buffer going
forward."
  (interactive)
  (let (value
        (tag (read-from-minibuffer "Tag: "))
        (attr (read-from-minibuffer "Attribute: ")))
    (if (setq value (find-tag-attribute-internal tag attr (point-max) t 1))
        (message value)
      (beep)
      (message "Tag %s with attribute %s not found." tag attr))))

(defun next-tag-attribute-backward ()
  "Locates and returns the next attribute value for tag within the buffer going
backward."
  (interactive)
  (let (value
        (repeat -1)
        (tag (read-from-minibuffer "Tag: "))
        (attr (read-from-minibuffer "Attribute: ")))
    (if (eq last-command this-command)
        (setq repeat -2))
    (if (setq value
	      (find-tag-attribute-internal tag attr (point-min) t repeat))
        (message value)
      (beep)
      (message "Tag %s with attribute %s not found." tag attr))))

(defun next-hyperlink-forward ()
  "Locates and returns the next hyperlink URL within the buffer going forward."
  (interactive)
  (let (url)
    (if (setq url (find-tag-attribute-internal "a" "href" (point-max) t 1))
        (message url)
      (beep)
      (message "No hyperlink found."))))

(defun next-hyperlink-backward ()
  "Locates and returns the next hyperlink URL within the buffer going backward.
Note that we check if the last command was this command so that we don't locate
the same hyperlink twice."
  (interactive)
  (let ((dir -1) url)
    (if (eq last-command this-command)
        (setq dir -2))
    (if (setq url (find-tag-attribute-internal "a" "href" (point-min) t dir))
        (progn
          (re-search-forward "href\\s-*=\\s-*\\(\"\\|'\\)" nil nil 1)
          (message url))
      (beep)
      (message "No hyperlink found."))))
