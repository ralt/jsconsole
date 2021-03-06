(in-package #:jsconsole)

(hunchentoot:define-easy-handler (script :uri "/script.js") ()
  (setf (hunchentoot:content-type*) "text/javascript")
  (ps
    (defmacro cat (&body body)
      `(concatenate 'string ,@body))

    (defmacro @@ (&body body)
      `(chain ,@body))

    (let ((input (@@ document (get-element-by-id "input")))
          (output (@@ document (get-element-by-id "output")))
          (line (@@ document (create-element "div")))
          (hidden-line (@@ document (create-element "input")))
          (submit-form (@@ document (get-element-by-id "submit"))))
      (setf (@ hidden-line name) "lines")
      (setf (@ hidden-line type) "hidden")
      (setf (@ console log)
            (lambda (l)
              (setf (@ output "innerHTML") (cat (@ output "innerHTML") l "<br>"))
              undefined))

      (@@ input (add-event-listener
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
               (var ev)
               (setf ev eval)
               (setf val (ev newline))
               (setf (@ window $_) val))
             (:catch (error)
               (setf val (cat (@ error constructor name) ": " (@ error message)))))

        (setf tmp (@@ line (clone-node t)))
        (setf (@ tmp text-content) val)

        (setf hidden-tmp (@@ hidden-line (clone-node t)))
        (setf (@ hidden-tmp value) newline)

        (@@ output (append-child tmp))
        (@@ submit-form (append-child hidden-tmp))

        (setf (@ input value) "")))))
