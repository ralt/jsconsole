;;;; package.lisp

(defpackage #:jsconsole
  (:use #:cl #:ps))

(in-package #:jsconsole)

(defvar *db-dbname* "jsconsole")
(defvar *db-user* "jsconsole")
(defvar *db-password* "password")
(defvar *db-host* "localhost")
