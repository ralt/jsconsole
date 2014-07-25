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
     :height "100%"
     :display "flex"
     :flex-direction "column")
    (".header"
     :height "30px"
     :line-height "30px"
     :background "#eee"
     :border-top "1px solid #aaa"
     :border-bottom "1px solid #aaa")
    (".header span"
     :padding "6px 10px"
     :box-shadow "1px 1px 10px #aaa inset")
    (".tools"
     :display "flex"
     :align-items "center")
    (".tools > div"
     :margin "0 5px")
    ("output"
     :display "block")))
