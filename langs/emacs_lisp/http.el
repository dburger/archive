;; sure you can test returned http content from the command line like this:
;; curl -u admin:letmein "https://dev.goo.camberhawaii.org/icons.xml?icon_category_id=5597"
;; but emacs goes to 11
;; ah, and if you need to go old school use url-open-stream to start a process
;; and process-send-string GET / HTTP/1.0 to it
(require 'url)

(defun http-callback (status)
  "Default callback keeps the buffer containing returned content alive."
  (switch-to-buffer (current-buffer)))

(defun do-http-get (url &optional callback)
  "Will negotiate an authorization if necessary."
  (let ((callback (or callback #'http-callback))
(url-request-extra-headers `(("Authorization" .
              ,(url-get-authentication url nil nil t)))))
    (url-retrieve url callback)))

(defun http-get (url)
  (interactive "sURL: ")
  (do-http-get url))

(defun do-http-basic-get (url user pass &optional callback)
  (let* ((callback (or callback #'http-callback))
   (auth (concat "Basic " (base64-encode-string (concat user ":" pass))))
   (url-request-extra-headers `(("Authorization" . ,auth))))
    (message auth)
    (url-retrieve url callback)))

(defun http-basic-get (url user pass)
  (interactive "sURL: \nsUser: \nsPass: ")
  (do-http-basic-get url user pass))
