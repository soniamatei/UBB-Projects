%4. Write a program to generate the list of all subsets of sum S with the elements of a list (S - given).
%Eg: [1,2,3,4,5,6,10] si S=10 => [[1,2,3,4], [1,4,5], [2,3,5], [4,6], [10]] (not necessary in this order)

list_sum([], C, S) :- C =:= S.
list_sum([H|T], C, S):-
    C1 is H + C,
   list_sum(T, C1, S).
   

partitions_in_two([], [], []).
partitions_in_two([H|X], [H|Y], C) :-
   partitions_in_two(X, Y, C).
partitions_in_two([H|X], Y, [H|C]) :-
   partitions_in_two(X, Y, C).

all_subsets(L, S, FL) :-
    partitions_in_two(L, FL, _),
    list_sum(FL, 0, S).

main(L, S, FL) :- findall(FS, all_subsets(L, S, FS), FL).

test :-
    main([1,2,3,4,5,6,10], 10, [[1, 2, 3, 4], [1, 3, 6], [1, 4, 5], [2, 3, 5], [4, 6], [10]]).