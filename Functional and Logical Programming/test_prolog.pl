%Sa se scrie un predicat care adauga dupa 1-ul, al 2-lea, al 4-lea, al 8-lea ... element al unei
%liste o valoare v data.
   
%(i, i, i, i, i) (i, i, i, i, o)
myadd([], _, _, _, []).
myadd([H|T], E, P, PN, [H, E|FL]) :-
    P =:= PN, !,
    PN_S is PN * 2,
    P_S is P + 1,
    myadd(T, E, P_S, PN_S, FL).
myadd([H|T], E, P, PN, [H|FL]) :-
    P_S is P + 1,
    myadd(T, E, P_S, PN, FL).
   
%(i, i, i) (i, i, o)
main(L, E, FL) :-
     myadd(L, E, 1, 1, FL).

test :-
    main([1, 2, 3], 11, [1, 11, 2, 11, 3]),
	main([1, 2, 3, 4, 5, 6], 11, [1, 11, 2, 11, 3, 4, 11, 5, 6]),
    main([1, 2, 3, 4, 5, 6, 7, 8, 9], 11, [1, 11, 2, 11, 3, 4, 11, 5, 6, 7, 8, 11, 9]),
    main([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], 11, [1,11,2,11,3,4,11,5,6,7,8,11,9,10,11,12,13,14,15,16,11,17]).