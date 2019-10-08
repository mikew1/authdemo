;;;; template.lisp
(in-package #:authdemo)

(defun login-form ()                                                    ; [1]
  (<:form :action (genurl 'login/post) :method "post"
      "User name:" (<:br)
      (<:input :type "text" :name "username") (<:br)
      "Password:" (<:br)
      (<:input :type "password" :name "password") (<:br)
      (<:input :type "submit" :value "Log in")))

(defun register-form ()
  (<:form :action (genurl 'register/post) :method "post"
      "User name:" (<:br)
      (<:input :type "text" :name "username") (<:br)
      "Password:" (<:br)
      (<:input :type "password" :name "password") (<:br)
      (<:input :type "submit" :value "Register")))


                    ; below copy of the function html-frame from linkdemo parent app
                    ; was intended as temporary addition for debugging (quick way
                    ; to get it to work given current limitations while exploring further)
                    ; however, (:render-method 'html-frame)  wasn't working for us
                    ; (same situation as earlier chapters), so, since our attempt to add that
                    ; to the context for mount-module failed so far, & since some of the
                    ; auth routes here in authdemo.lisp require this function,
                    ; we simply leave this copy of it here, & have removed its
                    ; references to routes which are only available in the parent app
                    ; ('home & 'submit as args to genurl), so those don't error.
                    ;
                    ; Progress steps:
                    ; - find how to correctly pass the below function as context
                    ;   into this module & copy the funcall notation already
                    ;   used in authdemo.lisp for functions passed as context.
                    ;   the holdup there right now is i don't know how to correctly
                    ;   identify the function html-frame in the call to mount-module
                    ;   in linkdemo/defmodule.lisp
                    ;
                    ; Progress step for that:
                    ; - more practice on uninterned symbols, internal/external, packages etc.

(defun html-frame (context)
  (<:html
    (<:head (<:title (getf context :title))
            (<:link :rel "stylesheet" :type "text/css" :href "/static/css/style.css"))
    (<:body
      (<:div
        (<:h1 (getf context :title))
        (<:a :href "/" "Home") " | "
        (if (logged-on-p)
            (list
              (<:a :href "/submit" "Submit a link")
              " | "
              (<:a :href (genurl 'logout)
                   (format nil "Logout ~A"
                           (logged-on-p))))
            (list (<:a :href (genurl 'login) "Log in")
                  " or "
                  (<:a :href (genurl 'register) "Register")))
        (<:hr))
      (getf context :body))))


;; [1] Lovely and compact. Half the LOC of a template lang, & don't need sep. files.