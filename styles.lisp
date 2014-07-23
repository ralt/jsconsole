(in-package #:jsconsole)

(hunchentoot:define-easy-handler (style :uri "/style.css") ()
  (setf (hunchentoot:content-type*) "text/css")
  (cl-css:css '(("body" :margin 0 :padding 0))))
