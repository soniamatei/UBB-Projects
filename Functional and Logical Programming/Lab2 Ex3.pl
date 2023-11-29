%. Remove all occurrence of a maximum value from a list on integer numbers

%(i, o)
maxim([],  0).
maxim([X], X).
maxim([H|T], R) :-
    maxim(T, X),
    (H < X ->  R is X; R is H).
    
% !!
%de preferat sa nu mai folosim if de genu si doar creem mai multe branchuri

%(i, i, o)
remove([], _, []).
remove([H|T], H, FL) :- remove(T, H, FL).
remove([H|T], X, [H|FL]) :- 
    remove(T, X, FL),
    H \= X.
    
%(i, o)
remove_max([], []).
remove_max([_], []).
remove_max(IL, FL) :-
    maxim(IL, X),
    remove(IL, X, FL).

test_point_a :- 
    remove_max([],[]),
    remove_max([3], []),
    remove_max([5, 5, 6, 8, 9, 8], [5, 5, 6, 8, 8]),
    remove_max([-1, -2, -3], [-2, -3]),
    remove_max([-1, 2, 4, -3], [-1, 2, -3]).
   
%. Define a predicate to remove from a list all repetitive elements. 
   
%(i, i)
not_repetitive([], _) :- true.
not_repetitive([H|T], X) :-
    not_repetitive(T, X), 
    H \= X.

%(i, o)
remove_multiple_occur([], []).
remove_multiple_occur([H|T], FL) :-
    \+ not_repetitive(T, H),
    remove(T, H, T2),
    remove_multiple_occur(T2, FL).
remove_multiple_occur([H|T], [H|FL]) :-
    not_repetitive(T, H),
    remove_multiple_occur(T, FL).

test_point_b :-
    remove_multiple_occur([], []),
    remove_multiple_occur([5, 5, 6, 7, 8, 7], [6, 8]),
    remove_multiple_occur([5, 5, 5], []),
    remove_multiple_occur([5, 6, 7], [5, 6, 7]).

%. Define a predicate to remove from a list all single elements.

%(i, i, o)
nr_occur([], _, 0).
nr_occur([H|T], X, R) :-
    H =:= X,
    nr_occur(T, X, R1),
    R is R1 + 1.
nr_occur([H|T], X, R) :-
    H \= X,
    nr_occur(T, X, R).

%(i, o, i)
remove_single_occur([], [], _).
remove_single_occur([H|T], FL, COPY) :-
    nr_occur(COPY, H, NUMBER), NUMBER =:= 1,
    remove_single_occur(T, FL, COPY).
remove_single_occur([H|T], [H|FL], COPY) :-
    nr_occur(COPY, H, NUMBER), NUMBER > 1,
    remove_single_occur(T, FL, COPY).

%(i, o)
main_rso(L, R) :- remove_single_occur(L, R, L).

test_point_c :-
    main_rso([], []),
    main_rso([5, 5, 6, 7, 8, 7], [5, 5, 7, 7]),
    main_rso([5, 5, 5], [5, 5, 5]),
    main_rso([5, 6, 7], []).

