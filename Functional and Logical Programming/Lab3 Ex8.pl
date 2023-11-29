% Determine the successor of a number represented as digits in a list.
% [1 9 3 5 9 9] --> [1 9 3 6 0 0]

%(i, i, o)
one_front(L, 0, L) :- !.
one_front(L, 1, [1|L]) :- !.

%(i, o, o)
add_one([], 1, []) :- !.
add_one([H|T], R, [H1|FL]) :- 
    add_one(T, R1, FL),
    R is (H + R1) // 10,
    H1 is (H + R1) mod 10.

%(i, o) (i, i)
main_a(L, FL) :- 
    add_one(L, R, IL), 
    one_front(IL, R, FL).

% For a heterogeneous list, formed from integer numbers and list of numbers, determine the successor of a
% sublist considered as a number.
% [1, [2, 3], 4, 5, [6, 7, 9], 10, 11, [1, 2, 0], 6] => [1, [2, 4], 4, 5, [6, 8, 0], 10, 11, [1, 2, 1], 6]

%(i, o), (i, i)
check_and_modify([], []) :- !.
check_and_modify([H|T], [H|FL]) :- 
    \+ is_list(H), !,
    check_and_modify(T, FL).
check_and_modify([H|T], [H1|FL]) :- 
    is_list(H),
    check_and_modify(T, FL),
    main_a(H, H1).

test_a :-
    main_a([], [1]),
    main_a([1,9,3,5,9,9], [1,9,3,6,0,0]),
     main_a([9,9,9,9,9,9], [1,0,0,0,0,0,0]).

test_b :-
    check_and_modify([1, [2, 3], 4, 5, [6, 7, 9], 10, 11, [1, 2, 0], 6], [1, [2, 4], 4, 5, [6, 8, 0], 10, 11, [1, 2, 1], 6]),
    \+ check_and_modify([1, [2, 3], 4, 5, [6, 7, 9], 10, 11, [1, 2, 0], 6], [2, [2, 4], 4, 5, [6, 8, 0], 10, 11, [1, 2, 1], 7]),
    check_and_modify([], []),
    \+ check_and_modify([1, [2, 3], 4, 5, [6, 7, 9], 10, 11, [1, 2, 0], 6], [1, [2, 0], 4, 5, [6, 0, 0], 10, 11, [1, 2, 3], 6]).
    
%c reverse, reverse +1
reverse([], R, R) :- !.
reverse([H|T], FL, R) :- 
    reverse(T, [H|FL], R).

reverse_plus_one([], R, 0, R) :- !.
reverse_plus_one([], FL, 1, R) :-
    reverse_plus_one([], [1|FL], 0, R), !.
reverse_plus_one([H|T], FL, C, R) :- 
    C1 is (H + C) // 10, !,
    H1 is (H + C) mod 10,
    reverse_plus_one(T, [H1|FL], C1, R).

reverse_main(L, FL) :-
    reverse(L, [], R),
    reverse_plus_one(R, [], 1, FL).  

test_c :-
    reverse_main([], [1]),
    \+ reverse_main([], []),
    reverse_main([1,9,3,5,9,9], [1,9,3,6,0,0]),
    \+ reverse_main([9,9,9,9,9,9], [9,9,9,9,9,9]),
    \+ reverse_main([1,0,0,0,0,0,0], [9,9,9,9,9,9]).

%daca este un model matematic mai usor decat implementarea, la test se poate prezenta modelul matematic mai usor nu 
% trebuie scris fix dupa cod schema matematica
%daca se da o lista goala pentru a aduna 1 la un element de preferat sa se returneze o lista goala