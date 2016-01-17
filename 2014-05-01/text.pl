%
% member(X, L)
%  X がリスト L に入っているかどうかを返す
%
member(X, [X | _]).

member(X, [_ | Tail]) :-
    member(X, Tail).


%
% conc(L1,L2,L3)
%  リスト L1 と L2 を連結した結果をリスト L3 に入れる
%
conc([],L,L).

conc([X|L1],L2,[X|L3]) :- conc(L1,L2,L3).

%
%
%
len([X], 1).

len([X|L1], 1+N) :- len(L1,N).

