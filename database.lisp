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
  (let ((slug (generate-slug)))
    (when (get-session slug)
      (new-slug))
    slug))

;; Generates a 5-letters slug using random characters
(defun generate-slug ()
  (let* ((chars (coerce "abcdefghijklmnopqrstuvwxyzZBCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" 'list))
         (chars-count (length chars))
         (iterations 5))
    (format nil "~{~a~}" (loop for i from 0 to iterations
                            collect (nth
                                     (random chars-count)
                                     chars)))))

;; Inserts new lines with the session id
(defun create-lines (sid lines)
  (dolist (line lines)
    (create-line sid line)))

(postmodern:defprepared-with-names create-line (sid line)
  ("INSERT INTO line (sid, line) VALUES($1, $2)" sid line) :none)

;; Gets all the lines for a single slug
(postmodern:defprepared-with-names get-lines (slug)
  ("SELECT l.line
    FROM line l
    LEFT JOIN session s
    ON l.sid = s.id
    WHERE s.slug = $1" slug) :plists)

;; Gets one session
(postmodern:defprepared-with-names get-session (slug)
  ("SELECT slug
    FROM session
    WHERE slug = $1" slug) :single)
