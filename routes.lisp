(in-package #:jsconsole)

(defmacro cat (&body body)
  `(concatenate 'string ,@body))

(hunchentoot:define-easy-handler (home :uri "/") ()
  (page "Your JS console"
    (cl-who:str (form))))

(hunchentoot:define-easy-handler (save :uri "/save"
                                       :default-request-type :post)
    ((lines :parameter-type 'list))
  (hunchentoot:redirect (cat "/fetch?q=" (new-session lines))))

(hunchentoot:define-easy-handler (fetch :uri "/fetch") ()
  (fetch-page
      "Saved jsconsole"
      (loop for pline in (get-lines (hunchentoot:parameter "q"))
           collect (getf pline :line))
    (cl-who:str (form))))

(defun form ()
  (cl-who:with-html-output-to-string (*standard-output* nil)
    (:output :id "output")
    (:input :id "input")
    (:form :id "submit" :action "/save" :method "POST"
           (:input :type "submit" :value "Save"))))
