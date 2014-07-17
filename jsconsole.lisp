;;;; jsconsole.lisp

(in-package #:jsconsole)

;;; "jsconsole" goes here. Hacks and glory await!

(defmacro page (title &body body)
  `(who:with-html-output-to-string (*standard-output* nil :prologue t)
     (:html
      (:head
       (:meta :charset "utf-8")
       (:title ,title)
       (:link :rel "stylesheet" :href "/style.css"))
      (:body
       ,@body
       (:script :src "/script.js")))))

;; Quick, helpful shortcut to `chain`, which does chaining of methods and
;; properties.
;;
;;     (@@ ($ "a") (css "padding" "5px") (text "Hello!"))
;;
;; becomes
;;
;;     $('a').css('padding', '5px').text('Hello!');
;;
;; Taken from https://github.com/fitzgen/tryparenscript.com/blob/892a3bfcebe58dfeaa525bbdc67ace7e5e524518/ps-helpers.lisp#L123
(ps:defmacro+ps @@ (&rest args)
  `(ps:chain ,@args))

(hunchentoot:define-easy-handler (style :uri "/style.css") ()
  (setf (hunchentoot:content-type*) "text/css")
  (cl-css:css '(("body" :margin 0 :padding 0))))

(hunchentoot:define-easy-handler (script :uri "/script.js") ()
  (setf (hunchentoot:content-type*) "text/javascript")
  (ps
    (let ((input (@@ document (get-element-by-id "input")))
          (output (@@ document (get-element-by-id "output"))))
      (setf (@ console log)
            (lambda (l)
              (setf (@ output "innerHTML") (concatenate 'string (@ output "innerHTML") l "<br>"))
              undefined))
      (@@ input
         (add-event-listener
          "keyup"
          (lambda (e)
            (unless (= (@ e key-code) 13)
              return)
            (var val)
            (try (progn
                   (setf val (eval (@ this value)))
                   (setf (@ window $_) val))
              (:catch (error)
                (setf val (concatenate 'string (@ error constructor name) ": " (@ error message)))))
            (setf (@ output "innerHTML") (concatenate 'string (@ output "innerHTML") val "<br>"))
            (setf (@ input value) "")))))))


(hunchentoot:define-easy-handler (home :uri "/") ()
  (page "Your JS console"
    (:output :id "output")
    (:input :id "input")))

(setf ps:*js-string-delimiter* #\")

(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 4321))
