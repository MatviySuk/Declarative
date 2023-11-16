% Опис за статтю
man(matviy).
man(max).
man(volodya).
man(andriy).
man(vasyl).
man(volodya_f).
woman(lesya).
woman(olya).
woman(nadia).
woman(ira_k).
woman(ira_b).

% Опис одружених
married(andriy, lesya).
married(vasyl, nadia).
married(volodya_f, olya).

% Опис батьків
parent(andriy, matviy).
parent(lesya, matviy).

parent(andriy, max).
parent(lesya, max).

parent(andriy, volodya).
parent(lesya, volodya).

parent(vasyl, andriy).
parent(nadia, andriy).

parent(vasyl, ira_k).
parent(nadia, ira_k).

parent(volodya_f, lesya).
parent(olya, lesya).

parent(volodya_f, ira_b).
parent(olya, ira_b).

 
sibling(X, Y) :- parent(Z, X), parent(Z, Y), X \= Y. 
sister(X, Y) :- woman(X), sibling(X, Y).
brother(X, Y) :- man(X), sibling(X, Y).
aunt(X, Y) :- sister(X, Z), parent(Z, Y).
mother_in_law(X, Z) :- (married(X, Y); married(Y, X)), parent(Z, Y), woman(Z).
grand_father(X, Y) :- parent(Z, X), parent(Y, Z), man(Y).
grand_mother(X, Y) :- parent(Z, X), parent(Y, Z), woman(Y).
daughter_in_law(X, Y) :- woman(Y), married(Z, Y), parent(X, Z).
grandmother_or_daughter_in_law(X, Y) :- woman(Y), (grand_mother(X, Y); daughter_in_law(X, Y)).
sibling_in_law(X, Y) :- sibling(X, Z), (married(Z, Y);  married(Y, Z)).

% Написати програму для визначення індексу початку 
% найдовшої послідовності повторення одного 
% символу в введеному списку символів.
find_longest_sequence_index([], -1).
find_longest_sequence_index([X|Xs], MaxIndex) :- 
    longest_sequence_helper(Xs, X, 0, 1, 0, 1, 0, MaxIndex).

longest_sequence_helper([], _, CurrentIndex, CurrentLength, _, MaxLength, _, CurrentIndex) :- 
    CurrentLength > MaxLength.

longest_sequence_helper([], _, _, CurrentLength, MaxIndex, MaxLength, _, MaxIndex) :- 
    CurrentLength =< MaxLength.

longest_sequence_helper([X|Xs], Elem, CurrentIndex, CurrentLength, MaxIndex, MaxLength, Index, Result) :- 
    X = Elem,
    NewIndex is Index + 1,
    NewLength is CurrentLength + 1,
    longest_sequence_helper(Xs, X, CurrentIndex, NewLength, MaxIndex, MaxLength, NewIndex, Result).

longest_sequence_helper([X|Xs], Elem, CurrentIndex, CurrentLength, _, MaxLength, Index, Result) :- 
    X \= Elem,
    CurrentLength > MaxLength,
    NewIndex is Index + 1,
    longest_sequence_helper(Xs, X, NewIndex, 1, CurrentIndex, CurrentLength, NewIndex, Result).

longest_sequence_helper([X|Xs], Elem, _, CurrentLength, MaxIndex, MaxLength, Index, Result) :- 
    X \= Elem,
    CurrentLength =< MaxLength,
    NewIndex is Index + 1,
    longest_sequence_helper(Xs, X, NewIndex, 1, MaxIndex, MaxLength, NewIndex, Result).
