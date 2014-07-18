(in-package #:jsconsole)

;; Creates a new session and return its slug
(defun new-session (lines)
  (let ((slug (new-slug)))
    (postmodern:with-transaction ()
      (let ((id (create-session slug)))
        (create-lines id lines))
      slug)))


(postmodern:defprepared-with-names create-session (slug)
  ("INSERT INTO session (slug) VALUES($1) RETURNING id" slug :single))

;; Creates a new slug
(defun new-slug ())

;; Inserts new lines with the session id
(defun create-lines (id lines))
