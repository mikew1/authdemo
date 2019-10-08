;;;; defmodule.lisp

(restas:define-module #:authdemo
  (:use #:cl))

(in-package #:authdemo)

(defparameter *template-directory*
  (merge-pathnames #P"templates/" authdemo-config:*base-directory*))

(defparameter *static-directory*
  (merge-pathnames #P"static/" authdemo-config:*base-directory*))


