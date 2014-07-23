(in-package #:jsconsole)

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
            (new-line (@ this value)))))
      (dolist (line base)
        (new-line line))
      (defun new-line (newline)
        (var val)
        (var tmp)
        (var hidden-tmp)
        (try (progn
               (setf val (eval newline))
               (setf (@ window $_) val))
             (:catch (error)
               (setf val (concatenate 'string (@ error constructor name) ": " (@ error message)))))
        (setf tmp (chain line (clone-node t)))
        (setf (@ tmp text-content) val)
        (setf hidden-tmp (chain hidden-line (clone-node t)))
        (setf (@ hidden-tmp value) newline)
        (chain output (append-child tmp))
        (chain submit-form (append-child hidden-tmp))
        (setf (@ input value) "")))))