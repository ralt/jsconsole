;;;; jsconsole.asd

(asdf:defsystem #:jsconsole
  :serial t
  :description "JSConsole website to experiment and share your console"
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT License"
  :depends-on ("hunchentoot"
               "cl-who"
               "parenscript"
               "cl-css"
               "postmodern")
  :components ((:file "package")
               (:file "database")
               (:file "jsconsole")))
