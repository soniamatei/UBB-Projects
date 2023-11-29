;14. Determine the list of nodes accesed in postorder in a tree of type (A 2 B C 2 D 0 E 0).

(defun postorder_list (tree lst)
	(cond
   		;if tree empty
   		((NULL tree) (list tree lst))
   		;if node doesn't have children => add to final list and return
   		((equal #|node childs|#(cadr tree) 0) (list (cddr tree) (append lst #|node (in list)|#(list (car tree)))))
     	;else => call for left and right then add to list and return
      	((equal #|node childs|#(cadr tree) 1) 
           	(set 'tree_and_result (postorder_list (cddr tree) lst))
            (list (car tree_and_result) (append (cadr tree_and_result) (list (car tree))))
        )
      	(t 	(set 'tree_and_result_list_left (postorder_list (cddr tree) lst))
           	;take from result the tree and list obtained
           	(set 'tree_and_result_list_right (postorder_list (car tree_and_result_list_left) (cadr tree_and_result_list_left)))
           	(list (car tree_and_result_list_right) (append (cadr tree_and_result_list_right) #|node from initial tree|#(list (car tree))))
    	)
	)
 )

(defun postorder_list_helper (lst)
	(cadr (postorder_list lst ()) )
 )

(defun test_preorder_list ()
	(assert
   		(and
	       	(equal (postorder_list_helper '(A 2 B 2 C 0 D 0 E 0)) '(C D B E A))
			(equal (postorder_list_helper '(A 2 B 2 C 2 E 0 F 0 D 2 G 0 H 0 I 2 J 0 L 1 M 0)) '(E F C G H D B J M L I A))
			(equal (postorder_list_helper '(A 2 B 1 C 2 H 0 G 0 E 1 F 0)) '(H G C B F E A))

       	)
    )
)

; (print (equal (postorder_list_helper '(A 2 B 2 C 0 D 0 E 0)) '(C D B E A)))
; (print (equal (postorder_list_helper '(A 2 B 2 C 2 E 0 F 0 D 2 G 0 H 0 I 2 J 0 L 1 M 0)) '(E F C G H D B J M L I A)))
; (print (equal (postorder_list_helper '(A 2 B 1 C 2 H 0 G 0 E 1 F 0)) '(H G C B F E A)))

(test_preorder_list)