(in-package #:jsconsole)

;; Creates a new session and return its slug
(defun new-session (lines)
  (let ((slug (new-slug)))
    (postmodern:with-transaction ()
      (let ((id (create-session slug)))
        (create-lines id lines))
      slug)))


(postmodern:defprepared-with-names create-session (slug)
  ("INSERT INTO session (slug) VALUES($1) RETURNING id" slug) :single)

;; Creates a new slug
(defun new-slug ()
  (random-password 5))

;; http://www.codecodex.com/wiki/Generate_a_random_password_or_random_string#Common_Lisp
;; To be replaced with something more correct, i.e. that can use caps/lower.
(defun random-password (length)
  (with-output-to-string (stream)
    (let ((*print-base* 36))
      (loop repeat length do (princ (random 36) stream)))))

;; Inserts new lines with the session id
(defun create-lines (sid lines)
  (dolist (line lines)
    (create-line sid line)))

(postmodern:defprepared-with-names create-line (sid line)
  ("INSERT INTO line (sid, line) VALUES($1, $2)" sid line) :none)

;; Gets one session
(postmodern:defprepared-with-names get-lines (sid)
  ("SELECT line FROM line WHERE sid = $1" sid) :lists)
