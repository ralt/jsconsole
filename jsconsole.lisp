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

(defmacro fetch-page (title json &body body)
  `(who:with-html-output-to-string (*standard-output* nil :prologue t)
     (:html
      (:head
       (:meta :charset "utf-8")
       (:title ,title)
       (:link :rel "stylesheet" :href "/style.css"))
      (:body
       ,@body
       (:script
        "var base = " (cl-who:str (jsown:to-json ,json)) ";")
       (:script :src "/script.js")))))
