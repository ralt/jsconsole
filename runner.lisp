(in-package #:jsconsole)

(setf ps:*js-string-delimiter* #\")

(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 4321))

(unless postmodern:*database*
  (setf postmodern:*database*
        (postmodern:connect *db-dbname*
                            *db-user*
                            *db-password*
                            *db-host*
                            :pooled-p t))))
