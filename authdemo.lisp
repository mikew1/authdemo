;;;; authdemo.lisp

(in-package #:authdemo)

(defvar *authenticate-user-function* nil)                               ; [1]
(defvar *register-user-function* nil)
(defvar *redirect-route* nil)                                           ; [2]
(defvar *html-frame* nil) ; <- to hack: try passing this in linkdemo defmodule,
                          ;             then funcall *html-frame* below instead.

(defun logged-on-p ()                                                   ; [3]
  (hunchentoot:session-value :username))                                ; [4]

(defun log-in (username &optional (redirect-route *redirect-route*))    ; [5]
  (hunchentoot:start-session)
  (setf (hunchentoot:session-value :username) username)
  (redirect redirect-route))

(defun log-out (&optional (redirect-route *redirect-route*))   ; <- default is now *redirect-route*
  (setf (hunchentoot:session-value :username) nil)
  (redirect redirect-route))


(define-route login ("login")                                           ; [6]
  (html-frame
    (list :title "Log in"
          :body (login-form))))

(define-route login/post ("login" :method :post)
  (let ((user (funcall *authenticate-user-function*    ; <- new for this as sep. module [7].
                       (hunchentoot:post-parameter "username")
                       (hunchentoot:post-parameter "password"))))
    (if user
        (html-frame (log-in user))
        (redirect 'login))))


(define-route register ("register")
  (html-frame
    (list :title "register"
          :body (register-form))))

(define-route register/post ("register" :method :post)
  (let ((user (funcall *register-user-function*        ; <- new for this as sep. module [7].
                       (hunchentoot:post-parameter "username")
                       (hunchentoot:post-parameter "password"))))
    (if user
        (html-frame (log-in user))
        (redirect 'register))))

(define-route logout ("logout")
  (html-frame (log-out)))



;; [1] He calls these 'endpoints' in the book, they're not http endpoints,
;;     rather, context variables to be passed to the package, so package endpoints.
;; [2] To keep things simple, when a user logs in, out or registers, we'll redirect
;;     to the same place, specified by *redirect-route*. We could have separate
;;     variables for all 3 operations if we wanted.
;; [3] Could be in util, kept here for simplity for now
;; [4] Always rtns name of user, so can use it in displaying username in
;;     html-frame (layout file).
;; [5] The only thing CHANGED ON MOVE TO SEPARATE MODULE, is redirect-route default
;;     value, from 'home to *redirect-route*.
;; [6] Simply return the login-form.
;; [7] Instead of calling the functions auth-user & register-user as we did when this auth
;;     functionality was within linkdemo, now we funcall on the functions provided as context
;;     to the module. Great. So simple & logical.