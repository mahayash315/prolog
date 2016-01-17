%
% relation definitions
%
husband(X) :- family(X,_,_).

wife(X) :- family(_,X,_).

child(X) :- family(_, _, Children), member(X,Children).

member(X, [X|_]).
member(X, [_|L]) :- member(X,L).

exists(Person) :-
    husband(Person);
    wife(Person);
    child(Person).

dateofbirth(person(_,_,Date,_), Date).

salary(person(_,_,_,works(_,S)), S).
salary(person(_,_,_,unemployed),0).

total([], 0).
total([Person|List],Sum) :-
    salary(Person, S),
    total(List,Rest),
    Sum is S + Rest.

%
% family database
%
family(
    person(tom, fox, date(7,may,1950), works(bbc,15200)),
    person(ann, fox, date(9,may,1951), unemployed),
    [ person(pat, fox, date(5,may,1973), unemployed),
      person(jim, fox, date(5,may,1973), unemployed) ] ).
family(
    person(tom, armstrong, date(7,may,1950), works(bbc,15200)),
    person(ann, armstrong, date(9,may,1951), unemployed),
    [] ).
family(
    person(benjamin, jackson, date(7,may,1950), works(bbc,15200)),
    person(alice, jackson, date(9,may,1951), unemployed),
    [ person(peter, parker, date(5,may,1974), work(abc,11100))] ).



%
% problems
%

% (4.2)
twins(person(X,Surname,Birthdate,_),person(Y,Surname,Birthdate,_)) :- X \== Y.


accepts(S, []) :-
    final(S).
accepts(S, [X | Rest]) :-
    trans(S, X, S1),
    accepts(S1, Rest).
accepts(S, String) :-
    slient(S, S1),
    accepts(S1, String).

accepts(S, [], Remaining_moves) :-
    0 < Remaining_moves,
    final(S).
accepts(S, [X | Rest], Remaining_moves) :-
    0 < Remaining_moves,
    Next_remaining_moves is Remaining_moves - 1,
    trans(S, X, S1),
    accepts(S1, Rest, Next_remaining_moves).
accepts(S, String, Remaining_moves) :-
    0 < Remaining_moves,
    Next_remaining_moves is Remaining_moves - 1,
    slient(S, S1),
    accepts(S1, String, Next_remaining_moves).
