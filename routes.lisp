(in-package #:jsconsole)

(hunchentoot:define-easy-handler (home :uri "/") ()
  (page "Your JS console"
    (:output :id "output")
    (:input :id "input")
    (:form :id "submit" :action "/save" :method "POST"
           (:input :type "submit" :value "Save"))))

(hunchentoot:define-easy-handler (save :uri "/save"
                                       :default-request-type :post)
    ((lines :parameter-type 'list))
  (hunchentoot:redirect (concatenate 'string "/fetch?q=" (new-session lines))))

(hunchentoot:define-easy-handler (fetch :uri "/fetch") ()
  (fetch-page
      "Saved jsconsole"
      (loop for pline in (get-lines (hunchentoot:parameter "q"))
           collect (getf pline :line))
    (:output :id "output")
    (:input :id "input")
    (:form :id "submit" :action "/save" :method "POST"
           (:input :type "submit" :value "Save"))))
