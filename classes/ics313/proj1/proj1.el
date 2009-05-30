;;;;;;;;;;;;;;;;;;;;;;;;;;; -*- Mode: Emacs-Lisp -*- ;;;;;;;;;;;;;;;;;;;;;;;;;;
;; proj1.el -- 
;; Author          : David J. Burger
;; Created On      : Thu Mar  6 21:03:40 2003
;; Last Modified By: David J. Burger
;; Last Modified On: Fri Mar 21 15:35:16 2003
;; RCS: $Id$
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Copyright (c) 2003 David J. Burger
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; This program is a simple cross referencer.  To use it, call:
;; djb-xref-file filename
;; This can be done interactively.  This function will process the file,
;; creating a table of the users custom functions in the file.  Information
;; associated with each function will be the file that it was defined in, and
;; a list of functions that invoke the function.  The corresponding data can
;; be queried from the database with the functions:
;;
;; djb-xref-who-calls 'function
;;
;; and
;;
;; djb-xref-where-defined 'function
;;
;; In addition, a string that represents the contents of the entire database
;; can be retrieved via:
;;
;; djb-xref-print-db
;;
;; *NOTE*:
;; One special feature of my program is that it automatically figures out what
;; functions will result from defstruct expansions and adds them to a list of
;; macro expansions while removing existing calls to such functions from the
;; hash table if they are already there.  This prevents the macro expanded
;; functions from defstructs such as make-djb-xref-symbol from being
;; interpretted as calls to custom user functions.
(require 'cl)

(defvar djb-xref-table (make-hash-table)
  "Holds the hash table used in xref processing.")

(defstruct djb-xref-info "Data type for storing information about the custom functions.
Will be hashed into djb-xref-table with the function symbol as the key"
  filename called-by)

(defvar djb-xref-filename nil
  "Holds the name of the file currently being processed for xref.")

(defvar djb-xref-current-defun nil
  "Holds the name of the defun currently being processed for xref.")

(defvar djb-xref-standard-forms
  '(require and when incf boundp equal or symbolp listp >= every first second
    third cdddr not interactive setq make-hash-table save-excursion set-buffer
    get-buffer-create erase-buffer insert-file-contents goto-char point-min
    while condition-case read current-buffer format message member if clrhash
    with-temp-buffer integerp length stringp file-error error car > cdr nth
    symbol-name nthcdr = < gethash setcar list puthash cons setcdr maphash
    concat endp defvar setf function intern push remhash progn)
  "Holds a list of the functions that are classified as standard functions.
Note that some of these are special forms but for the purposes of our xref
processor they can be treated like the other built in forms...for example
and is a special form but we are only worried about finding a list, that
starts with an and, and contains zero or more forms following the and.")

(defvar djb-xref-macro-expanded-forms nil
  "Holds a list of functions available via macro expansion.
This list will be used to make sure function calls aren't incorrectly
labeled as calls to user functions when they are actually macro expansions.")

(defun djb-xref-file (filename)
  "Processes the file, registering known functions in the function table.
The function table can then be queried so that the file in which a function
is defined, and a list of functions that invoke the function, can be retrieved.
FILENAME is the name of a file to process.
Returns t if successful, otherwise nil if not parse-able or file not exist."
  (interactive "FEnter filename: ")
  (setq djb-xref-filename filename)
  (with-temp-buffer
    (if (condition-case nil (insert-file-contents filename) (file-error nil))
	(or (djb-xref-current-buffer)
	    (progn
	      (setq djb-xref-current-defun nil)
	      (setq djb-xref-macro-expanded-forms nil)
	      (clrhash djb-xref-table))) ;; clrhash returns nil
      nil)))

(defun djb-xref-current-buffer ()
  "The helper function for djb-xref-file.
Does xref processing on the current buffer.
Returns t if successful, otherwise nil if a parsing problem is encountered."
  (let ((parsed t)
	(eof nil))
    (while (and parsed (not eof))
      (condition-case nil (let ((form (read (current-buffer))))
			    (setq parsed (djb-xref-form-p form)))
	(error (setq eof t))))
    parsed))

(defun djb-xref-form-p (form)
  "Determines if form is a valid form, performing xref processing.
FORM is a valid form.
Returns t if form is parse-able according to our grammar, otherwise nil."
  (or (djb-xref-integer-p form)
      (djb-xref-symbol-p form)
      (djb-xref-string-p form)
      (djb-xref-standard-form-p form)
      (djb-xref-special-form-p form)
      (djb-xref-custom-function-p form)))

(defun djb-xref-integer-p (form)
  "Determines if form is an integer.
FORM is a valid form.
Returns t if form is an integer, otherwise nil."
  (integerp form))

(defun djb-xref-symbol-p (form)
  "Determines if form is a symbol.
FORM is a valid form.
Returns t if form is a symbol, otherwise nil."
  (symbolp form))

(defun djb-xref-string-p (form)
  "Determines if form is a string.
FORM is a valid form.
Returns t if form is a string, otherwise nil"
  (stringp form))

(defun djb-xref-standard-form-p (form)
  "Determines if form is a valid standard form, performing xref processing.
FORM is a valid form.
Returns t if form is a standard form, otherwise nil."
  (and (listp form)
       (> (length form) 0)
       (or (member (car form) djb-xref-standard-forms)
	   (member (car form) djb-xref-macro-expanded-forms))
       (every 'djb-xref-form-p (cdr form))))
  
(defun djb-xref-special-form-p (form)
  "Determines if form is a special form, performing xref processing.
FORM is a valid form.
Returns t if form is a special form, otherwise nil."
  (or (djb-xref-defun-p form)
      (djb-xref-let-p form)
      (djb-xref-quote-p form)
      (djb-xref-cond-p form)
      (djb-xref-lambda-p form)
      (djb-xref-defstruct-p form)))

(defun djb-xref-defun-p (form)
  "Determines if form is a valid defun, performing xref processing.
FORM is a valid form.
Returns t if form is a defun, otherwise nil."
  (and (listp form)
       (> (length form) 2) ;; must have defun name args
       (equal (car form) 'defun)
       (djb-xref-symbol-p (nth 1 form))
       (listp (nth 2 form))
       (every 'djb-xref-symbol-p (nth 2 form)) ;; not checking nil
       (setq djb-xref-current-defun (nth 1 form))
       (every 'djb-xref-form-p (nthcdr 3 form))
       (djb-xref-register-function)
       (not (setq djb-xref-current-defun nil)))) ;; clear defun, return t

(defun djb-xref-let-p (form)
  "Determines if form is a valid let, preforming xref processing.
FORM is a valid form.
Returns t if form is a let, otherwise nil."
  (and (listp form)
       (> (length form) 1)
       (equal (car form) 'let)
       (listp (nth 1 form))
       (djb-xref-varlist-p (nth 1 form))
       (every 'djb-xref-form-p (nthcdr 2 form))))

(defun djb-xref-varlist-p (form)
  "Determines if form is a valid varlist, performing xref processing.
A valid varlist is the type of varlist accepted by let.
FORM is a valid form.
Returns t if form is a varlist, otherwise nil."
  (every 'djb-xref-varlist-element-p form))

(defun djb-xref-varlist-element-p (form)
  "Determines if form is a valid varlist element, performing xref processing.
A valid varlist element is a symbol or a (SYMBOL FORM) pair.
FORM is a valid form.
Returns t if form is a varlist element, otherwise nil."
  (or (djb-xref-symbol-p form)
      (and (listp form)
	   (= (length form) 2)
	   (djb-xref-symbol-p (car form))
	   (djb-xref-form-p (nth 1 form)))))

(defun djb-xref-quote-p (form)
  "Determines if form is a valid quote, performing xref processing.
In this project we will not allow unescaping in the quote, so there
is no further xref processing to do on such a form.
FORM is a valid form.
Returns t if form is a quote, otherwise nil."
  (and (listp form)
       (> (length form) 0)
       (equal (car form) 'quote)))

(defun djb-xref-cond-p (form)
  "Determines if form is a valid cond, performing xref processing.
FORM is a valid form.
Returns t if form is a cond, otherwise nil."
  (and (listp form)
       (> (length form) 0)
       (equal (car form) 'cond)
       (every 'djb-xref-form-list-p (cdr form))))

(defun djb-xref-form-list-p (form)
  "Determines if form is a valid form list, performing xref processing.
A valid form list is a list that contains 0 or more valid forms.
FORM is a valid form.
Returns t if form is a valid form list, otherwise nil."
  (and (listp form)
       (every 'djb-xref-form-p form)))

(defun djb-xref-lambda-p (form)
  "Determines if form is a valid lambda, performing xref processing.
FORM is a valid form.
Returns t if form is a lambda, otherwise nil."
  (and (listp form)
       (> (length form) 1) ;; must have lambda args
       (equal (car form) 'lambda)
       (listp (nth 1 form))
       (every 'djb-xref-form-p (nthcdr 2 form))))

(defun djb-xref-defstruct-p (form)
  "Determines if form is a valid defstruct, performing xref processing.
FORM is a valid form.
Returns t if form is a defstruct, otherwise nil."
  (and (listp form)
       (> (length form) 1) ;; defstruct and symbol name
       (equal (car form) 'defstruct)
       (djb-xref-symbol-p (nth 1 form))
       (or (and (djb-xref-string-p (nth 2 form)) ;; comment string
		(djb-xref-add-defstruct-expansions (nth 1 form) (nthcdr 3 form)))
	   (djb-xref-add-defstruct-expansions (nth 1 form) (nthcdr 2 form)))))

(defun djb-xref-add-defstruct-expansions (defstruct-symbol fields)
  "Adds the functions created by macro expansion for defstruct-symbol.
DEFSTRUCT-SYMBOL is a defstruct symbol..
FIELDS is a list of fields for the defstruct.
Returns t."
  (let ((make-symbol (intern (concat "make-" (symbol-name defstruct-symbol))))
	(copy-symbol (intern (concat "copy-" (symbol-name defstruct-symbol))))
	(pred-symbol (intern (concat (symbol-name defstruct-symbol) "-p"))))
    (if (not (member make-symbol djb-xref-macro-expanded-forms))
	(progn
	  (push make-symbol djb-xref-macro-expanded-forms)
	  (push copy-symbol djb-xref-macro-expanded-forms)
	  (push pred-symbol djb-xref-macro-expanded-forms)
	  ;; functions possibly called before defstruct encountered, remove
	  (remhash make-symbol djb-xref-table)
	  (remhash copy-symbol djb-xref-table)
	  (remhash pred-symbol djb-xref-table)))
    (djb-xref-add-defstruct-field-expansions defstruct-symbol fields)))

(defun djb-xref-add-defstruct-field-expansions (defstruct-symbol fields)
  "Adds defstruct field names for accessors created via macro expansion.
DEFSTRUCT-SYMBOL is a defstruct symbol.
FIELDS is a list of fields for the defstruct.
Returns t."
  (cond ((endp fields) t)
        (t (let ((field-symbol (intern (concat (symbol-name defstruct-symbol)
					       "-"
					       (symbol-name (car fields))))))
	     (if (not (member field-symbol djb-xref-macro-expanded-forms))
		 (progn
		   (push field-symbol djb-xref-macro-expanded-forms)
		   ;; possibly called before defstruct encountered, remove it
		   (remhash field-symbol djb-xref-table))))
	   (djb-xref-add-defstruct-field-expansions defstruct-symbol
						    (cdr fields)))))

(defun djb-xref-register-function ()
  "Registers a function in the djb-xref-table.
If the function happens to already exist in the table, it will be assumed
that the current file is the correct one, and the filename will be
overwritten.
Returns t."
  (if djb-xref-current-defun ;; check to be sure there is a defun to register
      (let ((info (gethash djb-xref-current-defun djb-xref-table)))
 	(if info
 	    (setf (djb-xref-info-filename info) djb-xref-filename)
 	  (puthash djb-xref-current-defun
		   (make-djb-xref-info :filename djb-xref-filename
				       :called-by nil)
 		   djb-xref-table))))
  t)

(defun djb-xref-register-call-to-function (function)
  "Adds the current function being parsed to the list of callers of function.
If the current function is already in the list, it will not be added twice.
FUNCTION is the name of the known function being called.
Returns t."
  (if djb-xref-current-defun ;; check to be sure called inside a defun
      (let ((info (gethash function djb-xref-table)))
	(if info
	    (or (member djb-xref-current-defun (djb-xref-info-called-by info))
		(push djb-xref-current-defun (djb-xref-info-called-by info)))
	  (puthash function
		   (make-djb-xref-info :filename nil :called-by (list djb-xref-current-defun)) djb-xref-table))))
  t)

(defun djb-xref-custom-function-p (form)
  "Determines if form is a custom form, performing xref processing.
A custom form is a call to a user defined function.
FORM is a valid form.
Returns t if form is a custom form."
  (and (listp form)
       (> (length form) 0)
       (djb-xref-symbol-p (nth 0 form))
       (every 'djb-xref-form-p (cdr form))
       (djb-xref-register-call-to-function (nth 0 form))))

(defun djb-xref-print-db ()
  "Returns a formatted string that indicates the contents of the xref database.
The string will be in the form:
function  filename  callers
Returns the formatted database string."
  (let ((djb-db-string ""))
    (maphash (function (lambda (key element)
			 (setq djb-db-string
			       (concat djb-db-string
				       (format "%-40s  %-40s  %s\n"
					       key
					       (djb-xref-info-filename element)
					       (djb-xref-info-called-by element))))))
	     djb-xref-table)
    (concat (format "%-40s  %-40s  %s\n" "Function" "Defined in" "Called by")
	    djb-db-string)))

(defun djb-xref-where-defined (function)
  "Returns a string indicating the file where the function was defined.
FUNCTION is a symbol.
Returns corresponding filename or nil if not defined."
  (let ((info (gethash function djb-xref-table)))
    (if info
	(djb-xref-info-filename info))))

(defun djb-xref-who-calls (function)
  "Returns the list of functions that call function.
FUNCTION is a symbol.
Returns corresponding list or nil if not found."
  (let ((info (gethash function djb-xref-table)))
    (if info
	(djb-xref-info-called-by info))))

;; Unit testing functions, uncomment and call to test.
;; Remember that if you save it with these functions uncommented
;; then the defun count for this file will be 27 and not 25.
;;
;;(djb-xref-tester)
;;
;; (defun djb-xref-tester ()
;;   "Unit testing for the xref parser.
;; Returns t if the parser is correct, otherwise nil."
;;   (and (not (clrhash djb-xref-table))
;;        (djb-xref-file "~/ics313/proj1/pmj-parse-example-2.el")
;;        (= 6 (djb-xref-count-hash-entries djb-xref-table))
;;        (equal (djb-xref-where-defined 'pmj-count-occurrences)
;;               "~/ics313/proj1/pmj-parse-example-2.el")
;;        (equal (djb-xref-who-calls 'pmj-count-occurrences)
;; 	      '(pmj-test-count-occurrences))
;;        (not (clrhash djb-xref-table))
;;        (djb-xref-file "~/ics313/proj1/pmj-count-top-level-example.el")
;;        (= 1 (djb-xref-count-hash-entries djb-xref-table))
;;        (equal (djb-xref-where-defined 'pmj-count-top-level-defuns)
;; 	      "~/ics313/proj1/pmj-count-top-level-example.el")
;;        (equal (djb-xref-who-calls 'pmj-count-top-level-defuns)
;; 	      nil)
;;        (not (clrhash djb-xref-table))
;;        (djb-xref-file "~/ics313/proj1/proj1.el")
;;        (= 25 (djb-xref-count-hash-entries djb-xref-table))
;;        (equal (djb-xref-where-defined 'djb-xref-file)
;; 	      "~/ics313/proj1/proj1.el")
;;        (member 'djb-xref-varlist-element-p
;; 	       (djb-xref-who-calls 'djb-xref-form-p))
;;        (member 'djb-xref-current-buffer
;; 	       (djb-xref-who-calls 'djb-xref-form-p))
;;        (equal (djb-xref-who-calls 'djb-xref-print-db)
;; 	      nil)))

;; (defun djb-xref-count-hash-entries (table)
;;   "Counts the number of entries in a hash table.
;; TABLE is a hash table.
;; Returns the number of entries in the hash table."
;;   (let ((count 0))
;;     (maphash #'(lambda (key element)
;; 		 (incf count))
;; 	     table)
;;     count))
