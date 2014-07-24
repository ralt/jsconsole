(in-package #:jsconsole)

(hunchentoot:define-easy-handler (style :uri "/style.css") ()
  (setf (hunchentoot:content-type*) "text/css")
  (cl-css:css (css-main)))

(defun css-main ()
  '(("*" :box-sizing "border-box")
    ("body"
     :margin 0
     :padding 0
     :position "absolute"
     :width "100%"
     :height "100%")))
