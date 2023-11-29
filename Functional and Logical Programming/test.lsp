;4Y115156
;Definiti o functie care substituie un element E prin elementele unei liste L1 la toate nivelurile unei liste date L.

(defun append_all (l1 l2)
	(cond
   		((null l1) l2)
     	(t (cons (car l1) (append_all (cdr l1) l2)))
   	)
)

(defun subs (l new_elem old_elem)
	(cond
   		((null l) l)
     	((equal (car l) old_elem) (append_all new_elem (subs (cdr l) new_elem old_elem)))
      	((listp (car l)) 
        	(cons (subs (car l) new_elem old_elem) (subs (cdr l) new_elem old_elem))
        )
      	(t (cons (car l) (subs (cdr l) new_elem old_elem)))
   	)
)

(defun tests ()
	(assert
   		(and
       		(equal (subs '(1 (5 (2 7 (2)))) '(3 4) 2) '(1 (5 (3 4 7 (3 4)))))
       		(equal (subs '(1 2 3 4 2) '(3 4) 2) '(1 3 4 3 4 3 4))
       		(equal (subs '(1 (2 (3 4) 2)) '(3 4) 2) '(1 (3 4 (3 4) 3 4)))
       		(equal (subs '(1 6 (5 (4 2)) 2 (2)) '(3 4) 2) '(1 6 (5 (4 3 4)) 3 4 (3 4)))
      	)
   	)
)
(print (tests))