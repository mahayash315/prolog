% rep11: 第11回 演習課題レポート
% 2014年07月03日      by 24115113 名前: 林 政行
%
% 第10回演習において、C言語で実装した N-queens 問題を解くプログラムを
% Prolog で実装する。
%
% -----------------------------------------------------------------------------
% 問: 制約充足問題のプログラミング
%      - N-queens問題のprologプログラムの性能評価実験
%
% [述語の説明]
%   - conc(L1,L2,L3):
%       L1 と L2 を結合したリストが L3 という関係
%   - sublist(List,Begin,End,SubList):
%       リスト List の Begin - End 間の要素から成るサブリスト SubList という関係
%   - swapData(L1,P1,P2,L2):
%       リスト L の P1, P2 番目の要素をスワップしたリストが L2 という関係
%   - getValue(List,Index,Value):
%       リスト List の Index 番目の要素 Value を取り出す手続き
%   - getMin(List,MinIndex):
%       リスト List の最初の最小値の添字 MinIndex を取り出す手続き
%   - getMinRandom(List,MinIndex):
%       リスト List の最小値の添字をランダムに取り出し MinIndex とする手続き
%   - getIndexOf(List,Value,Index):
%       リスト List の要素の内、Value である最初の要素の添字 Index を取り出す手続き
%   - getIndexesOf(List,Value,Indexes,N):
%       リスト List の要素の内、Value である要素の添字すべてを取り出す手続き。取り出された総数が N。
%   - initQueen(N,L):
%       N-queen の初期位置をランダムに設定する
%   - getConf(Pos,Diff,PosList,Count):
%       盤面リスト PosList の先頭を盤面の左端と見て、Diff 列だけ離れた列の Pos 行目にあるクイーンの、コンフリクト数 Count を数える
%   - getAttacked(PosList,ConfList):
%       盤面リスト PosList を盤面として、各列のクイーンの衝突している数をカウントし、 ConfList にそれぞれ入れる
%   - checkAttacked(ConfList):
%       衝突が生じているクイーンがあるかどうか調べ、あれば false, なければ true を返す
%   - selectMoveQueen(N,AttackedList,Queen):
%       衝突リスト AttackedList から、衝突が生じているクイーンをランダムに選び、Queen とする。無ければ Queen = 0 となる。
%       N はクイーンの総数。
%   - calcCandidates(N,PosList,ConfList,Queen):
%       盤面リスト PosList を用いて、Queen 列目のクイーンについて、そのクイーンが同列の 1〜N 行目に移動した際の衝突数をそれぞれ ConfList に入れる
%       N はクイーンの総数。
%   - changeQueen(PosList,ConfList,Queen,ChangedPosList):
%       クイーン移動先候補の衝突リスト ConfList を用いて、盤面リスト PosList から Queen 列目のクイーンを、衝突数が最小となるような同列の行に移動し、
%       その盤面を ChangedPosList とする。
%   - solveLoop(N,PosList,AttackedList,MaxTrial,Solution):
%       近似アルゴリズムにより制約充足問題を解くためのループを実行する。最大ループ回数 MaxTrial 以下のループで最適解 Solution が得られた場合は
%       true を返し、それ以外の場合は false を返す。引数として各クイーンの衝突リスト AttackedList を受け取る
%   - solution(N,Solution):
%       N-queens 問題を解き、解 Solution が得られた場合は true, 得られなかった場合は false を返す。
%
% /* 以下に回答を示す */

% conc
conc([],L,L).
conc([X|L1],L2,[X|L3]) :- conc(L1,L2,L3).

% sublist
sublist([],_,_,[]) :- !.
sublist(_,_,0,[]) :- !.
sublist(_,N1,N2,[]) :- N2 < N1, !.
sublist([X|L],N1,N2,[X|S]) :-
    N1 =< N2, N1 =< 1, 1 =< N2, !,
    NN1 is N1 - 1, NN2 is N2 - 1,
    sublist(L,NN1,NN2,S).
sublist([_|L],N1,N2,S) :-
    NN1 is N1 - 1, NN2 is N2 - 1,
    sublist(L,NN1,NN2,S).

sublist([],_,[]) :- !.
sublist([X|L],N1,[X|S]) :-
    N1 =< 1, !,
    NN1 is N1 - 1,
    sublist(L,NN1,S).
sublist([_|L],N1,S) :-
    NN1 is N1 - 1,
    sublist(L,NN1,S).

% swapPos(L1,P1,P2,L2)
swapData(L1,P1,P2,L2) :-
    P1 < P2, !,
    getValue(L1,P1,V1),
    getValue(L1,P2,V2),
    sublist(L1,1,P1-1,S1),
    sublist(L1,P1+1,P2-1,S2),
    sublist(L1,P2+1,S3),
    conc(S1,[V2|S2],Tmp1),
    conc(Tmp1,[V1|S3],L2).
swapData(L1,P1,P2,L2) :- P1 > P2, swapData(L1,P2,P1,L2).
swapData(L1,P1,P2,L1) :- P1 =:= P2.

% getValue(List, Index, Value)
getValue([V|_],1,V) :- !.
getValue([_|L],Index,V) :-
    1 < Index,
    NextIndex is Index-1,
    getValue(L,NextIndex,V).

% getMin
getMin([X],Index,X,Index) :- !.
getMin([X|L],MinIndex,MinValue,Index) :- !,
    NextIndex is Index + 1,
    getMin(L,MinIndex1,MinValue1,NextIndex),
    (X =<  MinValue1, MinIndex = Index, MinValue = X;
     MinValue1 < X, MinIndex = MinIndex1, MinValue = MinValue1), !.
getMin(List,MinIndex) :- getMin(List,MinIndex,_,1).

% getMinRandom
getMinRandom(L,Index) :-
    getMin(L,_,MinValue,1),
    getIndexesOf(L,MinValue,Indexes,N),
    N1 is N + 1, random(1,N1,R),
    getValue(Indexes,R,Index).

% getIndexOf
getIndexOf([],_,0,_) :- !.
getIndexOf([X1|_],X,Found,Found) :- X =:= X1 , !.
getIndexOf([X1|L],X,Found,Index) :-
    X =\= X1, !,
    NextIndex is Index + 1,
    getIndexOf(L,X,Found,NextIndex).
getIndexOf(List,Value,Index) :- getIndexOf(List,Value,Index,1).

% getIndexesOf
getIndexesOf([],_,[],_,0) :- !.
getIndexesOf([X1|L],X,Indexes,Index,N) :-
    X1 =\= X, !,
    NextIndex is Index + 1,
    getIndexesOf(L,X,Indexes,NextIndex,N).
getIndexesOf([X|L],X,[Index|Rest],Index,N) :-
    NextIndex is Index + 1,
    getIndexesOf(L,X,Rest,NextIndex,N1),
    N is N1 + 1.
getIndexesOf(L,X,Indexes,N) :- getIndexesOf(L,X,Indexes,1,N).

% initQueen
initQueen(N,L) :- randseq(N,N,L).

% getConf
getConf(_,_,[],0) :- !.
getConf(Pos,Diff,[Pos1|PosRest],Count) :-
    Diff =\= 0,
    (Pos =:= Pos1; Pos + Diff =:= Pos1; Pos - Diff =:= Pos1), !,
    NextDiff is Diff+1,
    getConf(Pos,NextDiff,PosRest,Count1),
    Count is Count1 + 1.
getConf(Pos,Diff,[Pos1|PosRest],Count) :-
    (Diff =:= 0; Pos + Diff =\= Pos1, Pos - Diff =\= Pos1), !,
    NextDiff is Diff+1,
    getConf(Pos,NextDiff,PosRest,Count).

% getAttack
getAttacked(_,[],[],_) :- !.
getAttacked(PosList,[Pos|PosRest],[Conf|ConfRest],Queen) :-
    NextQueen is Queen + 1,
    getAttacked(PosList,PosRest,ConfRest,NextQueen),
    getConf(Pos,1-Queen,PosList,Conf).
getAttacked(PosList,ConfList) :-
    getAttacked(PosList,PosList,ConfList,1).

% checkAttacked
checkAttacked([]).
checkAttacked([0|L]) :- checkAttacked(L).

% selectMoveQueen
selectMoveQueen(_,_,[],0,0) :- !.
selectMoveQueen(N,I,[Attack|AttackRest],Queen,Weight) :-
    Attack =\= 0, !, NextI is I+1,
    selectMoveQueen(N,NextI,AttackRest,Queen1,Weight1),
    N1 is N + 1, random(1,N1,R),
    (Weight1 < R, Weight = R, Queen = I;
     Weight1 >= R, Weight = Weight1, Queen = Queen1), !.
selectMoveQueen(N,I,[Attack|AttackRest],Queen,Weight) :-
    Attack =:= 0, !, NextI is I+1,
    selectMoveQueen(N,NextI,AttackRest,Queen,Weight).
selectMoveQueen(N,AttackedList,Queen) :-
    selectMoveQueen(N,1,AttackedList,Queen,_).

% calcCandidates
calcCandidates(N,_,[],_,N1) :- N1 =:= N + 1, !.
calcCandidates(N,PosList,[Conf|ConfRest],Queen,Pos) :-
    NextPos is Pos + 1,
    calcCandidates(N,PosList,ConfRest,Queen,NextPos),
    getConf(Pos,1-Queen,PosList,Conf).
calcCandidates(N,PosList,ConfList,Queen) :-
    calcCandidates(N,PosList,ConfList,Queen,1).

% changeQueen
changeQueen(PosList,ConfList,Queen,ChangedPosList) :-
    getMinRandom(ConfList,Move),
    getIndexOf(PosList,Move,SwapWith),
    write(' moving to '), write(Move),
    swapData(PosList,Queen,SwapWith,ChangedPosList).

% solveLoop
solveLoop(_,Solution,AttackedList,_,Solution) :- checkAttacked(AttackedList), !.
solveLoop(N,PosList1,AttackedList1,MaxTrial,Solution) :-
    0 < MaxTrial, !,
    write('Remaining Trial '), write(MaxTrial), write('\t'),
    write(PosList1), write(' '), write(AttackedList1),
    % 移動するクイーンを選択
    selectMoveQueen(N,AttackedList1,Queen),
    write(' --> moving '), write(Queen),
    Queen =\= 0,
    % クイーンの移動先候補のコンフリクトを計算
    calcCandidates(N,PosList1,ConfList,Queen),
    write(' : conflicts '), write(ConfList),
    % クイーンを移動
    changeQueen(PosList1,ConfList,Queen,PosList2),
    % 移動後のアタック数を計算
    getAttacked(PosList2,AttackedList2),
    % 次のループへ
    write('\n'),
    RemainingTrial is MaxTrial - 1,
    solveLoop(N,PosList2,AttackedList2,RemainingTrial,Solution).
    

% N-queens を解く
solution(N,S) :-
    initQueen(N,PosList),
    getAttacked(PosList,AttackedList),
    solveLoop(N,PosList,AttackedList,10000,S),
    write('\n'),
    printQueens(N,S),
    write('\n'), !.


printQueens(N,PosList) :- printQueens(N,PosList,1).
printQueens(N,PosList,Row) :-
    Row =< N, !,
    getIndexOf(PosList,Row,ColNum),
    printQueensLine(N,ColNum,1),
    write('\n'),
    NextRow is Row + 1,
    printQueens(N,PosList,NextRow).
printQueens(_,_,_).

printQueensLine(N,ColNum,I) :-
    I =< N, !,
    (I =:= ColNum, write('*'); I =\= ColNum, write('-')),
    NextI is I+1,
    printQueensLine(N,ColNum,NextI).
printQueensLine(_,_,_).

/*
  (実行例)

(実行例1)

[debug]  ?- solution(8,S).
Remaining Trial 10000	[8,6,5,7,1,3,4,2] [1,1,1,1,0,2,2,0] --> moving 3 : conflicts [1,1,2,1,1,4,3,3] moving to 1
Remaining Trial 9999	[8,6,1,7,5,3,4,2] [1,0,0,1,1,2,2,1] --> moving 8 : conflicts [3,1,3,1,3,2,1,2] moving to 4
Remaining Trial 9998	[8,6,1,7,5,3,2,4] [2,0,0,0,0,2,2,0] --> moving 6 : conflicts [2,3,2,3,2,3,1,1] moving to 8
Remaining Trial 9997	[3,6,1,7,5,8,2,4] [2,0,1,0,0,1,0,0] --> moving 6 : conflicts [2,3,2,3,2,3,1,1] moving to 7
Remaining Trial 9996	[3,6,1,8,5,7,2,4] [1,1,1,2,0,0,0,1] --> moving 2 : conflicts [1,4,2,2,1,1,2,2] moving to 6
Remaining Trial 9995	[3,6,1,8,5,7,2,4] [1,1,1,2,0,0,0,1] --> moving 3 : conflicts [1,1,2,2,3,2,4,1] moving to 8

---*----
------*-
*-------
-------*
----*---
-*------
-----*--
--*-----

S = [3, 6, 8, 1, 5, 7, 2, 4].









(実行例 2)

[debug]  ?- solution(6,S).
Remaining Trial 10000	[3,5,6,2,4,1] [0,2,2,0,1,1] --> moving 2 : conflicts [2,2,1,3,2,1] moving to 3
Remaining Trial 9999	[5,3,6,2,4,1] [1,0,1,1,1,0] --> moving 4 : conflicts [2,1,3,1,4,1] moving to 2
Remaining Trial 9998	[5,3,6,2,4,1] [1,0,1,1,1,0] --> moving 4 : conflicts [2,1,3,1,4,1] moving to 6
Remaining Trial 9997	[5,3,2,6,4,1] [0,1,2,0,1,0] --> moving 3 : conflicts [1,2,2,3,2,2] moving to 1

--*---
-----*
-*----
----*-
*-----
---*--

S = [5, 3, 1, 6, 4, 2].




[debug]  ?- solution(6,S).
Remaining Trial 10000	[2,1,4,3,5,6] [2,2,2,2,1,1] --> moving 4 : conflicts [1,1,2,3,3,2] moving to 2
Remaining Trial 9999	[3,1,4,2,5,6] [0,0,0,0,1,1] --> moving 5 : conflicts [2,2,2,2,1,2] moving to 5
Remaining Trial 9998	[3,1,4,2,5,6] [0,0,0,0,1,1] --> moving 6 : conflicts [2,1,1,3,2,1] moving to 3
Remaining Trial 9997	[6,1,4,2,5,3] [1,0,1,0,0,0] --> moving 3 : conflicts [2,2,3,1,1,2] moving to 4
Remaining Trial 9996	[6,1,4,2,5,3] [1,0,1,0,0,0] --> moving 1 : conflicts [2,3,1,1,2,1] moving to 4
Remaining Trial 9995	[4,1,6,2,5,3] [1,0,2,0,0,1] --> moving 1 : conflicts [2,2,1,1,2,1] moving to 3
Remaining Trial 9994	[3,1,6,2,5,4] [0,0,0,1,1,2] --> moving 4 : conflicts [1,1,2,2,2,4] moving to 1
Remaining Trial 9993	[3,2,6,1,5,4] [1,2,0,0,2,1] --> moving 5 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9992	[3,2,5,1,6,4] [2,1,1,0,0,0] --> moving 3 : conflicts [4,2,2,2,1,1] moving to 5
Remaining Trial 9991	[3,2,5,1,6,4] [2,1,1,0,0,0] --> moving 1 : conflicts [2,2,2,2,1,1] moving to 6
Remaining Trial 9990	[6,2,5,1,3,4] [0,0,1,0,2,1] --> moving 5 : conflicts [1,3,2,1,3,1] moving to 6
Remaining Trial 9989	[3,2,5,1,6,4] [2,1,1,0,0,0] --> moving 2 : conflicts [1,1,3,3,1,2] moving to 1
Remaining Trial 9988	[3,1,5,2,6,4] [1,0,1,1,0,1] --> moving 4 : conflicts [1,1,2,2,2,4] moving to 2
Remaining Trial 9987	[3,1,5,2,6,4] [1,0,1,1,0,1] --> moving 6 : conflicts [1,2,1,1,3,1] moving to 1
Remaining Trial 9986	[3,4,5,2,6,1] [2,3,2,1,0,0] --> moving 1 : conflicts [1,2,2,1,3,2] moving to 4
Remaining Trial 9985	[4,3,5,2,6,1] [1,2,0,0,1,0] --> moving 5 : conflicts [2,2,3,1,1,1] moving to 4
Remaining Trial 9984	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9983	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9982	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9981	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9980	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9979	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9978	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9977	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9976	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9975	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9974	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9973	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9972	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9971	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9970	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9969	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9968	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9967	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9966	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9965	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9964	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9963	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9962	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9961	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9960	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9959	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9958	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9957	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9956	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9955	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9954	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9953	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9952	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9951	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9950	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9949	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9948	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9947	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9946	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9945	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9944	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9943	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9942	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9941	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9940	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9939	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9938	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9937	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9936	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9935	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9934	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9933	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9932	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9931	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9930	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9929	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9928	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9927	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9926	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9925	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9924	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9923	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9922	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9921	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9920	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9919	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9918	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9917	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9916	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9915	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9914	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9913	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9912	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9911	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9910	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9909	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9908	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9907	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9906	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9905	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9904	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9903	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9902	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9901	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9900	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9899	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9898	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9897	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9896	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9895	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9894	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9893	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9892	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9891	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9890	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9889	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9888	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9887	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9886	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9885	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9884	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9883	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9882	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9881	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9880	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9879	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9878	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9877	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9876	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9875	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9874	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9873	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9872	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9871	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9870	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9869	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9868	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9867	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9866	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9865	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9864	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9863	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9862	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9861	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9860	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9859	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9858	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9857	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9856	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9855	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9854	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9853	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9852	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9851	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9850	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9849	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9848	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9847	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9846	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9845	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9844	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9843	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9842	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9841	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9840	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9839	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 9838	[6,3,5,2,4,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9837	[1,3,5,2,4,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
.
.
.
Remaining Trial 25	[1,4,2,5,3,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 24	[6,4,2,5,3,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 23	[6,4,2,5,3,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 22	[1,4,2,5,3,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 21	[6,4,2,5,3,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 20	[1,4,2,5,3,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 19	[1,4,2,5,3,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 18	[1,4,2,5,3,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 17	[6,4,2,5,3,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 16	[6,4,2,5,3,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 15	[1,4,2,5,3,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 14	[1,4,2,5,3,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 13	[6,4,2,5,3,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 12	[1,4,2,5,3,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 11	[1,4,2,5,3,6] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 10	[1,4,2,5,3,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 9	[6,4,2,5,3,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 8	[1,4,2,5,3,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 7	[1,4,2,5,3,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 6	[6,4,2,5,3,1] [1,0,0,0,0,1] --> moving 6 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 5	[6,4,2,5,3,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 4	[6,4,2,5,3,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 3	[6,4,2,5,3,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 6
Remaining Trial 2	[6,4,2,5,3,1] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
Remaining Trial 1	[1,4,2,5,3,6] [1,0,0,0,0,1] --> moving 1 : conflicts [1,2,2,2,2,1] moving to 1
false.





  [説明, 考察, 評価]

  [*] 説明
      上記プログラムは制約充足問題である N-queens 問題を、近似アルゴリズムにより解く Prolog プログラムである。
    プログラムの内容としては、前回の演習の際に C 言語で実装したものと、同じような関数を用意し、
    同様の動作をするようにした。従って前回の C 言語のプログラムと同様の名前の関数も含まれる。
      
      N-queens 問題を解くには solution(N,S) という手続きを用いることで、解 S を求めることができる。
    この手続き solutions(N,S) の流れとしては、始めに initQueens により、各列にクイーンが横方向に衝突しないように
    盤面を初期化し、制約を満たす解を求めるループ solveLoop により、最大のループ回数 10000 回で解を求める処理を行う。
    解が見つかった場合 true, 見つからなかった場合 false を返す。

      また、プログラム中のループ内の処理をわかるように、標準出力に盤面、衝突リスト、移動するクイーンと移動先候補、移動先
    を、ループ毎に表示するようにした。加えて、解が求まった際には解の盤面を表示するようにした。

  [*] 考察
      今回の Prolog プログラムは、前回の演習において C言語 で作成したプログラムを参考にして作ったため、
    Prolog の特徴であるバックトラックの機能をほとんど使わないようなプログラムになってしまった。
    また、途中の盤面や衝突リストを保管したり、それらを利用してクイーンの移動先を求めたりする際にも、
    もう少し賢い書き方、 Prolog 寄りの書き方ができれば、効率よく処理が行えるようなプログラムに
    なったと思うが、前述した通り、あまり Prolog の機能を考慮できなかったため、毎回の関数呼び出しで
    リストを頭から走査する処理を繰り返し何度も行うなど、無駄な処理が多いプログラムとなってしまった。

      実行例を見ると、(実行例1)では 8-queens 問題を解き、 6 回のクイーン移動で制約を満たす解を見つけている。
    8-queens 問題を解く操作は何度を何度か実行してみたところ、クイーンの移動回数にばらつきがあるものの、
    比較的少ない移動回数 (3回 〜 70回程度) で解が求まっていることが確認できた。

      一方で、(実行例2)を見ると、すぐに解を見つける場合もあれば、10000 回のクイーン移動をしても解が求まらない場合も
    あることが分かる。出力結果を見ると、ある程度ループ回数が増えたところで、全クイーンの衝突リストが [1,0,0,0,0,1],
    すなわち 1 列目と 6 列目のクイーンだけがお互いに衝突している状態になり、このとき、移動させるクイーンにどちらを
    選んでも、そのクイーンの居る列における、各行に移動した際の衝突数が [1,2,2,2,2,1] となっており、この中で衝突数が
    最小となる移動先をランダムに選ぶと、今居る場所にクイーンを留まらせるか、唯一の衝突先であるもう一つのクイーンと
    位置を交換するかのどちらかになり、どちらを選んでもその後の衝突数は変わらず、解が見つからないまま無限ループに
    陥ってしまっていることが分かった。

      このような状況を改善するためには、クイーンの移動先を選ぶ際に、衝突数が最小となる行を常に選ぶのではなく、
    ランダムに衝突数が増える方向にも選ぶことを考えたが、それでは解が求まる方向に（すなわち衝突数が最小となる方向に）
    クイーンの移動を進ませることが難しくなり、中々難しい問題だと考えた。

  [*] 評価
      前述した通り、C言語のプログラムを元に今回のプログラムを書いた為、Prolog の持つ利点をほとんど生かせていない。
    従って、プログラムの実行時間を比較しても、C言語で書いたものよりも遅く、効率が悪くなってしまった。なので、
    あまり良いプログラムではない。

*/

