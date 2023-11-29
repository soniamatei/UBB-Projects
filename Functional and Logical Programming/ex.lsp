;ex1
; (defun F (L1 L2)
; 	(
;   		(lambda (x) 
;     		((append x L2)
;       			(cond
;            			((null L1) (cdr L2))
;               		(t (list x (car L2)))
;            		)
;     		)
;       	)
;     (F (car L1) L2)
;     )
; )

; (defun g (l)
; 	(mapcon #'list l)
; )
; (print (g '(1 2)))
; (print (apply #'append (mapcon #'g '(1 2))))

;I.4
; f([], []).
; f([H|T], [H|L]) :- f(T, L).
; f([H|T], L) :- H mod 2 =:= 0, f(T, L).

;II
; insert([], E, [E]).
; insert([H|T], E, [E,H|T]).
; insert([H|T], E, [H|L]) :- insert(T, E, L).

; verify([_]) :- !.
; verify([H1, H2|T]) :-
;     H1 - H2 > 0,
;     H1 - H2 =< 3,
;     verify([H2|T]).
; verify([H1, H2|T]) :-
;     H2 - H1 > 0,
;     H2 - H1 =< 3,
;     verify([H2|T]).

; perm([], []).
; perm([H|L], LF) :-
;     perm(L, R),
;     insert(R, H, LF),
;     verify(LF).

; main(L, LF) :-
;     findall(LS, perm(L, LS), LF).


;III

; (defun remove_div_3 (x)
; 	(cond
;      	((listp x)
;        		(print x) 
;        		(cond
;            		((null x) x)
;              	(t (list (mapcan #'remove_div_3 x)))
;            	)
       		
;         )
;       	((numberp x) 
;         	(print "nb")
;          	(cond
;             	((not (equal (mod x 3) 0)) (list x))
;             )
;         )
;        	(t (list x))
;    	)
; )

; (print (mapcan #'remove_div_3 '(1 (2 A (3 A)) (6))))

;ex2
(defun g (l)
	(list (car l) (car l))
)
; (defun main ()
;   	((lambda (x) 
;   		(setq q 'g)
; 		(setq p q)
;   		(funcall p x)
;     )'(A B C))
; )
; (print (main))

(defun path (tr node)
	(cond
   		((null tr) tr)
     	((and (equal tr node) (atom tr)) (list tr))
      	((listp tr) (mapcan (lambda (e)  (cons (car tr)(path e node))) tr))
       	(t nil)
    )
)
(print (mapcan (lambda (e) (path e 'e)) '(a (b (g)) (c (d (e)) (f)))))


(print (and t '(a d e e)))