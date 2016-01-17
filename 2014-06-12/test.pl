member(X,[X|_]).
member(X,[_|Rest]) :- member(X,Rest).

conc([],L,L).
conc([X|L1],L2,[X|L3]) :- conc(L1,L2,L3).

countVars([],[],0).
countVars([X|Rest], [X|KnownVars], N) :-
    var(X), 
    countVars(Rest, KnownVars, N1),
    not( member(X,KnownVars) ),
    N is N1 + 1.
countVars([X|Rest], KnownVars, N) :-
    var(X), 
    countVars(Rest, KnownVars, N1),
    member(X,KnownVars),
    N is N1.
countVars([X|Rest], KnownVars, N) :-
    nonvar(X),
    atomic(X),
    countVars(Rest, KnownVars, N1),
    N is N1.
countVars([X|Rest], KnownVars, N) :-
    nonvar(X),
    not(atomic(X)),
    X =.. [_|Args],
    countVars(Args, Vars1, N1),
    countVars(Rest, Vars2, N2),
    conc(Vars1,Vars2,KnownVars),
    N is N1 + N2.
