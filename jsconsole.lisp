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

(hunchentoot:define-easy-handler (style :uri "/style.css") ()
  (setf (hunchentoot:content-type*) "text/css")
  (cl-css:css '(("body" :margin 0 :padding 0))))

(hunchentoot:define-easy-handler (script :uri "/script.js") ()
  (setf (hunchentoot:content-type*) "text/javascript")
  (ps
    (let ((input (chain document (get-element-by-id "input")))
          (output (chain document (get-element-by-id "output")))
          (line (chain document (create-element "div")))
          (hidden-line (chain document (create-element "input")))
          (submit-form (chain document (get-element-by-id "submit"))))
      (setf (@ hidden-line name) "lines")
      (setf (@ hidden-line type) "hidden")
      (setf (@ console log)
            (lambda (l)
              (setf (@ output "innerHTML") (concatenate 'string (@ output "innerHTML") l "<br>"))
              undefined))
      (chain input
         (add-event-listener
          "keyup"
          (lambda (e)
            (unless (= (@ e key-code) 13)
              return)
            (var val)
            (var tmp)
            (var hidden-tmp)
            (try (progn
                   (setf val (eval (@ this value)))
                   (setf (@ window $_) val))
              (:catch (error)
                (setf val (concatenate 'string (@ error constructor name) ": " (@ error message)))))
            (setf tmp (chain line (clone-node t)))
            (setf (@ tmp text-content) val)
            (setf hidden-tmp (chain hidden-line (clone-node t)))
            (setf (@ hidden-tmp value) (@ this value))
            (chain output (append-child tmp))
            (chain submit-form (append-child hidden-tmp))
            (setf (@ input value) "")))))))


(hunchentoot:define-easy-handler (home :uri "/") ()
  (page "Your JS console"
    (:output :id "output")
    (:input :id "input")
    (:form :id "submit" :action "/save" :method "POST"
           (:input :type "submit" :value "Save"))))

(hunchentoot:define-easy-handler (save :uri "/save"
                                       :default-request-type :post)
    ((lines :parameter-type 'list))
  (new-session lines))

(hunchentoot:define-easy-handler (fetch :uri "/f") ()
  (format nil "~A" (get-lines (hunchentoot:parameter "q"))))

(setf ps:*js-string-delimiter* #\")

(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port 4321))
(postmodern:connect-toplevel "jsconsole" "jsconsole" "password" "localhost")
