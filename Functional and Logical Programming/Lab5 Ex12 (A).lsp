;a) Write a function to return the dot product of two vectors.

(defun lungime (l)
	(cond
   		((atom l) 0)
     	(t (+ 1 (length (cdr l))))
   	)
)

(defun dot_product (lf ls)
	(cond
   		((not (equal (lungime lf) (lungime ls))) NIL)
   		((and (atom lf) (atom ls)) 0)
      	((and (listp lf) (listp ls)) (+ (dot_product (cdr lf) (cdr ls)) (* (car lf) (car ls))))
   	)
)

(defun test_dot_product ()
	(assert
   		(and
	       	(equal (dot_product '(1 2 3) '(1 2 3)) 14)
			(equal (dot_product '(0 0 0) '(1 2 3)) 0)
			(equal (dot_product '(1 2 3 4 5 6 7) '(2 3 4 5 6 7 8)) 168)
			(equal (dot_product '(1 2 3) '(4 5 6 7 8)) NIL)
       	)
    )
)
; (print (equal (dot_product '(1 2 3) '(1 2 3)) 14))
; (print (equal (dot_product '(0 0 0) '(1 2 3)) 0))
; (print (equal (dot_product '(1 2 3 4 5 6 7) '(2 3 4 5 6 7 8)) 168))


;b) Write a function to return the maximum value of all the numerical atoms of a list, at any level.
(defun maximum (lst)
	(cond
   		;last elem atom and list without it atom return elem	
   		((and (atom (car lst)) (null (cdr lst))) (car lst))
     	;if first elem list
     	((listp (car lst))  (set 'maximum_list (maximum (car lst)))
       						;continue with recursion on main list
	    					(set 'maxi (maximum (cdr lst)))
					       	(cond
					           	((>= maxi maximum_list) maxi)
					            ((< maxi maximum_list) maximum_list)
					        )
     	)
      	;if first elem number
     	(t 	(set 'front (car lst))
     		(set 'maxi (maximum (cdr lst)))
	       	(cond
	           	((>= maxi front) maxi)
	            ((< maxi front) front)
	        )
       	)
   	)
)

(defun test_maximum ()
	(assert
   		(and
	       	(equal (maximum '(1 3 88 ((2 444) 666) 555)) 666)
			(equal (maximum '((((444) 666) 555) 1000)) 1000)
			(equal (maximum '(((-4 (-1 -3) -33) -555) -1000)) -1)
       	)
    )
)
; (print (equal (maximum '(1 3 88 ((2 444) 666) 555)) 666))
; (print (equal (maximum '((((444) 666) 555) 1000)) 1000))
; (print (equal (maximum '(((-4 (-1 -3) -33) -555) -1000)) -1))


;c) All permutations to be replaced by: Write a function to compute the result 
;of an arithmetic expression memorised in preorder on a stack.
(defun result_preorder (lst)
  	(cond
     	((NULL lst) lst)
      	(t (set 'stack (result_preorder (cdr lst)))
    		(set 'front (car lst))
    		(cond
      			((numberp front) #|ret with push|#(cons front stack))
       			(t #|ret with push|#(cons #|op|#(funcall front (car stack) (cadr stack)) 
                                  #|pop 2 from stack|#(cddr stack)
                            )
        		)
    		)
        )
    )
   	
)

(defun test_result_preorder ()
	(assert
   		(and
	       	(equal (car (result_preorder '(+ * 2 4 - 5 * 2 2))) 9)
			(equal (car (result_preorder '(+ * 2 4 3))) 11)
			(equal (car (result_preorder '(+ 1 3))) 4)
       	)
    )
)
; (print(equal (car (result_preorder '(+ * 2 4 - 5 * 2 2))) 9))
; (print(equal (car (result_preorder '(+ * 2 4 3))) 11))
; (print(equal (car (result_preorder '(+ 1 3))) 4))

;d) Write a function to return T if a list has an even number of elements on the first level, and NIL on the
;contrary case, without counting the elements of the list.
(defun even_length (lst)
	(cond
   		((atom lst) T)
   		((atom (cdr lst)) NIL)
      	(t (even_length (cddr lst)))
    )
)

(defun test_even_length ()
	(assert
   		(and
	       	(equal (even_length '(1 3 4)) NIL)
			(equal (even_length '()) T)
			(equal (even_length '(1 3 4 5)) T)
       	)
    )
)
; (print (equal (even_length '(1 3 4)) NIL))
; (print (equal (even_length '()) T))
; (print (equal (even_length '(1 3 4 5)) T))

(test_dot_product)
(test_maximum)
(test_result_preorder)
(test_even_length)	
