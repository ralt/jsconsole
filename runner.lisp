(in-package #:jsconsole)

(setf ps:*js-string-delimiter* #\")

(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 4321))

(postmodern:connect-toplevel "jsconsole" "jsconsole" "password" "localhost")
