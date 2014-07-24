(in-package #:jsconsole)

(setf ps:*js-string-delimiter* #\")

(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 4321))

(unless postmodern:*database*
  (setf postmodern:*database*
        (postmodern:connect "jsconsole"
                            "jsconsole"
                            "password"
                            "localhost" :pooled-p t))))
