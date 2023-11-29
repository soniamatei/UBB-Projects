;15. Write a function that reverses a list together with all its sublists elements, at any level.
;se face cu reduce
(defun return_value (x)
	(cond 
   		((listp x) (reverse_all x))
      	(t x)
	)
)

(defun reverse_list (li)
	(cond
   		((NULL li) ())
   		(t (append (reverse_list (cdr li)) (list (car li))))
   	)
)

(defun reverse_all (li)
	(cond
   		((NULL li) ())
      	(t (reverse_list (mapcar #'return_value li)))
  	)
)

(defun test ()
	(assert
   		(and
	       	(equal (reverse_all '(1 (1 (1 (1 2) 2) 2) 3)) '(3 (2 (2 (2 1) 1) 1) 1))
			(equal (reverse_all '(1 2 3)) '(3 2 1))
			(equal (reverse_all '()) '())
       	)
    )
)

(defun my_print (li)
	(cond
   		((atom li) (list li))
     	(t (mapcan #'my_print (reverse_list li)))
   	)
)

(print (my_print '(1 (1 (1 (1 2) 2) 2) 3)))