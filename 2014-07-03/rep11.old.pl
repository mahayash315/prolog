getConfUp(_,_,ConfList,_,[],_,_,ConfList) :- !.
getConfUp(N,PosList,ConfList,Pos,[Pos1|PosRest],I1,I2,Result) :-
    Pos =:= Pos1, !,
    incConf(ConfList,I1,TmpList1),
    incConf(TmpList1,I2,TmpList2),
    NextPos is Pos + 1,
    NextI is I2 + 1,
    getConfUp(N,PosList,TmpList2,NextPos,PosRest,I1,NextI,Result).
getConfUp(N,PosList,ConfList,Pos,[Pos1|PosRest],I1,I2,Result) :-
    Pos =\= Pos1, !,
    NextPos is Pos + 1,
    NextI is I2 + 1,
    getConfUp(N,PosList,ConfList,NextPos,PosRest,I1,NextI,Result).

getConfDown(_,_,ConfList,_,[],_,_,ConfList) :- !.
getConfDown(N,PosList,ConfList,Pos,[Pos1|PosRest],I1,I2,Result) :-
    Pos =:= Pos1, !,
    incConf(ConfList,I1,TmpList1),
    incConf(TmpList1,I2,TmpList2),
    NextPos is Pos - 1,
    NextI is I2 + 1,
    getConfDown(N,PosList,TmpList2,NextPos,PosRest,I1,NextI,Result).
getConfDown(N,PosList,ConfList,Pos,[Pos1|PosRest],I1,I2,Result) :-
    Pos =\= Pos1, !,
    NextPos is Pos - 1,
    NextI is I2 + 1,
    getConfDown(N,PosList,ConfList,NextPos,PosRest,I1,NextI,Result).

% getAttack(PosList, ConfList, LupList, LdownList)
getAttack(N,_,ConfList,[], _) :- !, initConf(N,ConfList).
getAttack(N,PosList, ConfList, [Pos|PosRest], I) :-
    NextI is I + 1,
    getAttack(N,PosList,TmpList1,PosRest, NextI),
    NextPos1 is Pos+1,
    getConfUp(N,PosList,TmpList1,NextPos1,PosRest,I,NextI,TmpList2),
    NextPos2 is Pos-1,
    getConfDown(N,PosList,TmpList2,NextPos2,PosRest,I,NextI,ConfList).
getAttack(N,PosList,ConfList) :- getAttack(N,PosList,ConfList,PosList,1).

