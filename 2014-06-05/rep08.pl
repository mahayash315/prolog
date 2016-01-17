% rep08: 第08回 演習課題レポート
% 2014年06月05日      by 24115113 名前: 林 政行
%
% 教科書の練習 (6.2) を解いてレポートとして提出する。
%
% -----------------------------------------------------------------------------
% (練習 6.2)  (テキスト 153 ページ)
% 問: fを項のファイルとする．
%         findallterm(Term)
%     が，f中の項でTermとマッチする全てのものを端末に表示するように
%     手続きfindalltermを定義せよ．
%     Termがその過程で値の具体化を受けないようにせよ
%     （具体化を受けると，ファイル中の後に出現する項と項とのマッチ
%       が阻止されてしまう）．
%
% [述語の説明]
%   - naf(P):
%       negation as failure, not(P) と同じ
%   - findallterm(Term):
%       項のファイル /home/24115/cjh15113/rep08.txt の中の項で、 Term とマッチするすべての
%       ものを端末に表示する。
%   - read_and_proceed(Term, Count):
%       現入力ストリームから１つ項を読み込み、 proceed へ回す。
%   - proceed(Input, Term, ,Count):
%       ファイルからの入力項 Input と、標準入力からの入力項 Term がマッチする場合、その項を出力し、
%       マッチしない場合出力しない。また、ファイル終端のときはファイルを閉じ、マッチングの結果 (true, fail) を返す。
%
% /* ここから必要なプログラムを書く */

% 必要な定義 naf
naf(P) :- P,!,fail.
naf(_).

% ここからプログラム本体
findallterm(Term) :-
    see('/home/24115/cjh15113/rep08.txt'),
    read_and_proceed(Term, 0).

read_and_proceed(Term, Count) :-
    read(Input),
    proceed(Input, Term, Count).

proceed(end_of_file, _, 0) :- !, seen, fail.
proceed(end_of_file, _, _) :- !, seen.
proceed(Input, Term, Count) :-
    naf(naf(Input = Term)), !,
    Count1 is Count + 1,
    write(Input), nl,
    read_and_proceed(Term, Count1).
proceed(_, Term, Count) :- !,
    read_and_proceed(Term, Count).

/*
  (実行例)

---------------- 例 1: ユニファイ可能なものがある時 ----------------

[debug]  ?- findallterm(male(X)).
male(richard)
male(jeremy)
male(james)
true.

[trace]  ?-  findallterm(male(X)).
   Call: (6) findallterm(male(_G3224)) ? 
   Call: (7) see('/home/24115/cjh15113/rep08.txt') ? 
   Exit: (7) see('/home/24115/cjh15113/rep08.txt') ? 
   Call: (7) read_and_proceed(male(_G3224), 0) ? 
   Call: (8) read(_G3299) ? 
   Exit: (8) read(family(richard, alice, [child1, child2])) ? 
   Call: (8) proceed(family(richard, alice, [child1, child2]), male(_G3224), 0) ? 
   Call: (9) naf(naf(family(richard, alice, [child1, child2])=male(_G3224))) ? 
   Call: (10) naf(family(richard, alice, [child1, child2])=male(_G3224)) ? 
   Call: (11) family(richard, alice, [child1, child2])=male(_G3224) ? 
   Fail: (11) family(richard, alice, [child1, child2])=male(_G3224) ? 
   Redo: (10) naf(family(richard, alice, [child1, child2])=male(_G3224)) ? 
   Exit: (10) naf(family(richard, alice, [child1, child2])=male(_G3224)) ? 
   Call: (10) fail ? 
   Fail: (10) fail ? 
   Fail: (9) naf(naf(family(richard, alice, [child1, child2])=male(_G3224))) ? 
   Redo: (8) proceed(family(richard, alice, [child1, child2]), male(_G3224), 0) ? 
   Call: (9) read_and_proceed(male(_G3224), 0) ? 
   Call: (10) read(_G3309) ? 
   Exit: (10) read(family(jeremy, jimmy, [child])) ? 
   Call: (10) proceed(family(jeremy, jimmy, [child]), male(_G3224), 0) ? 
   Call: (11) naf(naf(family(jeremy, jimmy, [child])=male(_G3224))) ? 
   Call: (12) naf(family(jeremy, jimmy, [child])=male(_G3224)) ? 
   Call: (13) family(jeremy, jimmy, [child])=male(_G3224) ? 
   Fail: (13) family(jeremy, jimmy, [child])=male(_G3224) ? 
   Redo: (12) naf(family(jeremy, jimmy, [child])=male(_G3224)) ? 
   Exit: (12) naf(family(jeremy, jimmy, [child])=male(_G3224)) ? 
   Call: (12) fail ? 
   Fail: (12) fail ? 
   Fail: (11) naf(naf(family(jeremy, jimmy, [child])=male(_G3224))) ? 
   Redo: (10) proceed(family(jeremy, jimmy, [child]), male(_G3224), 0) ? 
   Call: (11) read_and_proceed(male(_G3224), 0) ? 
   Call: (12) read(_G3316) ? 
   Exit: (12) read(family(james, eimy, [])) ? 
   Call: (12) proceed(family(james, eimy, []), male(_G3224), 0) ? 
   Call: (13) naf(naf(family(james, eimy, [])=male(_G3224))) ? 
   Call: (14) naf(family(james, eimy, [])=male(_G3224)) ? 
   Call: (15) family(james, eimy, [])=male(_G3224) ? 
   Fail: (15) family(james, eimy, [])=male(_G3224) ? 
   Redo: (14) naf(family(james, eimy, [])=male(_G3224)) ? 
   Exit: (14) naf(family(james, eimy, [])=male(_G3224)) ? 
   Call: (14) fail ? 
   Fail: (14) fail ? 
   Fail: (13) naf(naf(family(james, eimy, [])=male(_G3224))) ? 
   Redo: (12) proceed(family(james, eimy, []), male(_G3224), 0) ? 
   Call: (13) read_and_proceed(male(_G3224), 0) ? 
   Call: (14) read(_G3320) ? 
   Exit: (14) read(male(richard)) ? 
   Call: (14) proceed(male(richard), male(_G3224), 0) ? 
   Call: (15) naf(naf(male(richard)=male(_G3224))) ? 
   Call: (16) naf(male(richard)=male(_G3224)) ? 
   Call: (17) male(richard)=male(_G3224) ? 
   Exit: (17) male(richard)=male(richard) ? 
   Call: (17) fail ? 
   Fail: (17) fail ? 
   Fail: (16) naf(male(richard)=male(_G3224)) ? 
   Redo: (15) naf(naf(male(richard)=male(_G3224))) ? 
   Exit: (15) naf(naf(male(richard)=male(_G3224))) ? 
   Call: (15) _G3330 is 0+1 ? 
   Exit: (15) 1 is 0+1 ? 
   Call: (15) write(male(richard)) ? 
male(richard)
   Exit: (15) write(male(richard)) ? 
   Call: (15) nl ? 

   Exit: (15) nl ? 
   Call: (15) read_and_proceed(male(_G3224), 1) ? 
   Call: (16) read(_G3330) ? 
   Exit: (16) read(male(jeremy)) ? 
   Call: (16) proceed(male(jeremy), male(_G3224), 1) ? 
   Call: (17) naf(naf(male(jeremy)=male(_G3224))) ? 
   Call: (18) naf(male(jeremy)=male(_G3224)) ? 
   Call: (19) male(jeremy)=male(_G3224) ? 
   Exit: (19) male(jeremy)=male(jeremy) ? 
   Call: (19) fail ? 
   Fail: (19) fail ? 
   Fail: (18) naf(male(jeremy)=male(_G3224)) ? 
   Redo: (17) naf(naf(male(jeremy)=male(_G3224))) ? 
   Exit: (17) naf(naf(male(jeremy)=male(_G3224))) ? 
   Call: (17) _G3340 is 1+1 ? 
   Exit: (17) 2 is 1+1 ? 
   Call: (17) write(male(jeremy)) ? 
male(jeremy)
   Exit: (17) write(male(jeremy)) ? 
   Call: (17) nl ? 

   Exit: (17) nl ? 
   Call: (17) read_and_proceed(male(_G3224), 2) ? 
   Call: (18) read(_G3340) ? 
   Exit: (18) read(male(james)) ? 
   Call: (18) proceed(male(james), male(_G3224), 2) ? 
   Call: (19) naf(naf(male(james)=male(_G3224))) ? 
   Call: (20) naf(male(james)=male(_G3224)) ? 
   Call: (21) male(james)=male(_G3224) ? 
   Exit: (21) male(james)=male(james) ? 
   Call: (21) fail ? 
   Fail: (21) fail ? 
   Fail: (20) naf(male(james)=male(_G3224)) ? 
   Redo: (19) naf(naf(male(james)=male(_G3224))) ? 
   Exit: (19) naf(naf(male(james)=male(_G3224))) ? 
   Call: (19) _G3350 is 2+1 ? 
   Exit: (19) 3 is 2+1 ? 
   Call: (19) write(male(james)) ? 
male(james)
   Exit: (19) write(male(james)) ? 
   Call: (19) nl ? 

   Exit: (19) nl ? 
   Call: (19) read_and_proceed(male(_G3224), 3) ? 
   Call: (20) read(_G3350) ? 
   Exit: (20) read(female(alice)) ? 
   Call: (20) proceed(female(alice), male(_G3224), 3) ? 
   Call: (21) naf(naf(female(alice)=male(_G3224))) ? 
   Call: (22) naf(female(alice)=male(_G3224)) ? 
   Call: (23) female(alice)=male(_G3224) ? 
   Fail: (23) female(alice)=male(_G3224) ? 
   Redo: (22) naf(female(alice)=male(_G3224)) ? 
   Exit: (22) naf(female(alice)=male(_G3224)) ? 
   Call: (22) fail ? 
   Fail: (22) fail ? 
   Fail: (21) naf(naf(female(alice)=male(_G3224))) ? 
   Redo: (20) proceed(female(alice), male(_G3224), 3) ? 
   Call: (21) read_and_proceed(male(_G3224), 3) ? 
   Call: (22) read(_G3352) ? 
   Exit: (22) read(female(jimmy)) ? 
   Call: (22) proceed(female(jimmy), male(_G3224), 3) ? 
   Call: (23) naf(naf(female(jimmy)=male(_G3224))) ? 
   Call: (24) naf(female(jimmy)=male(_G3224)) ? 
   Call: (25) female(jimmy)=male(_G3224) ? 
   Fail: (25) female(jimmy)=male(_G3224) ? 
   Redo: (24) naf(female(jimmy)=male(_G3224)) ? 
   Exit: (24) naf(female(jimmy)=male(_G3224)) ? 
   Call: (24) fail ? 
   Fail: (24) fail ? 
   Fail: (23) naf(naf(female(jimmy)=male(_G3224))) ? 
   Redo: (22) proceed(female(jimmy), male(_G3224), 3) ? 
   Call: (23) read_and_proceed(male(_G3224), 3) ? 
   Call: (24) read(_G3354) ? 
   Exit: (24) read(female(eimy)) ? 
   Call: (24) proceed(female(eimy), male(_G3224), 3) ? 
   Call: (25) naf(naf(female(eimy)=male(_G3224))) ? 
   Call: (26) naf(female(eimy)=male(_G3224)) ? 
   Call: (27) female(eimy)=male(_G3224) ? 
   Fail: (27) female(eimy)=male(_G3224) ? 
   Redo: (26) naf(female(eimy)=male(_G3224)) ? 
   Exit: (26) naf(female(eimy)=male(_G3224)) ? 
   Call: (26) fail ? 
   Fail: (26) fail ? 
   Fail: (25) naf(naf(female(eimy)=male(_G3224))) ? 
   Redo: (24) proceed(female(eimy), male(_G3224), 3) ? 
   Call: (25) read_and_proceed(male(_G3224), 3) ? 
   Call: (26) read(_G3356) ? 
   Exit: (26) read(end_of_file) ? 
   Call: (26) proceed(end_of_file, male(_G3224), 3) ? 
   Call: (27) seen ? 
   Exit: (27) seen ? 
   Exit: (26) proceed(end_of_file, male(_G3224), 3) ? 
   Exit: (25) read_and_proceed(male(_G3224), 3) ? 
   Exit: (24) proceed(female(eimy), male(_G3224), 3) ? 
   Exit: (23) read_and_proceed(male(_G3224), 3) ? 
   Exit: (22) proceed(female(jimmy), male(_G3224), 3) ? 
   Exit: (21) read_and_proceed(male(_G3224), 3) ? 
   Exit: (20) proceed(female(alice), male(_G3224), 3) ? 
   Exit: (19) read_and_proceed(male(_G3224), 3) ? 
   Exit: (18) proceed(male(james), male(_G3224), 2) ? 
   Exit: (17) read_and_proceed(male(_G3224), 2) ? 
   Exit: (16) proceed(male(jeremy), male(_G3224), 1) ? 
   Exit: (15) read_and_proceed(male(_G3224), 1) ? 
   Exit: (14) proceed(male(richard), male(_G3224), 0) ? 
   Exit: (13) read_and_proceed(male(_G3224), 0) ? 
   Exit: (12) proceed(family(james, eimy, []), male(_G3224), 0) ? 
   Exit: (11) read_and_proceed(male(_G3224), 0) ? 
   Exit: (10) proceed(family(jeremy, jimmy, [child]), male(_G3224), 0) ? 
   Exit: (9) read_and_proceed(male(_G3224), 0) ? 
   Exit: (8) proceed(family(richard, alice, [child1, child2]), male(_G3224), 0) ? 
   Exit: (7) read_and_proceed(male(_G3224), 0) ? 
   Exit: (6) findallterm(male(_G3224)) ? 
true.




------------------- 例 2: ユニファイ可能なものが無いとき -------------------

[debug]  ?- findallterm(family(_,_,[_,_,_|_])).
false.

[trace]  ?- findallterm(family(_,_,[_,_,_|_])).
   Call: (6) findallterm(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (7) see('/home/24115/cjh15113/rep08.txt') ? 
   Exit: (7) see('/home/24115/cjh15113/rep08.txt') ? 
   Call: (7) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (8) read(_G3368) ? 
   Exit: (8) read(family(richard, alice, [child1, child2])) ? 
   Call: (8) proceed(family(richard, alice, [child1, child2]), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (9) naf(naf(family(richard, alice, [child1, child2])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Call: (10) naf(family(richard, alice, [child1, child2])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (11) family(richard, alice, [child1, child2])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Fail: (11) family(richard, alice, [child1, child2])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Redo: (10) naf(family(richard, alice, [child1, child2])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Exit: (10) naf(family(richard, alice, [child1, child2])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (10) fail ? 
   Fail: (10) fail ? 
   Fail: (9) naf(naf(family(richard, alice, [child1, child2])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Redo: (8) proceed(family(richard, alice, [child1, child2]), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (9) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (10) read(_G3378) ? 
   Exit: (10) read(family(jeremy, jimmy, [child])) ? 
   Call: (10) proceed(family(jeremy, jimmy, [child]), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (11) naf(naf(family(jeremy, jimmy, [child])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Call: (12) naf(family(jeremy, jimmy, [child])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (13) family(jeremy, jimmy, [child])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Fail: (13) family(jeremy, jimmy, [child])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Redo: (12) naf(family(jeremy, jimmy, [child])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Exit: (12) naf(family(jeremy, jimmy, [child])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (12) fail ? 
   Fail: (12) fail ? 
   Fail: (11) naf(naf(family(jeremy, jimmy, [child])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Redo: (10) proceed(family(jeremy, jimmy, [child]), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (11) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (12) read(_G3385) ? 
   Exit: (12) read(family(james, eimy, [])) ? 
   Call: (12) proceed(family(james, eimy, []), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (13) naf(naf(family(james, eimy, [])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Call: (14) naf(family(james, eimy, [])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (15) family(james, eimy, [])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Fail: (15) family(james, eimy, [])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Redo: (14) naf(family(james, eimy, [])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Exit: (14) naf(family(james, eimy, [])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (14) fail ? 
   Fail: (14) fail ? 
   Fail: (13) naf(naf(family(james, eimy, [])=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Redo: (12) proceed(family(james, eimy, []), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (13) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (14) read(_G3389) ? 
   Exit: (14) read(male(richard)) ? 
   Call: (14) proceed(male(richard), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (15) naf(naf(male(richard)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Call: (16) naf(male(richard)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (17) male(richard)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Fail: (17) male(richard)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Redo: (16) naf(male(richard)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Exit: (16) naf(male(richard)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (16) fail ? 
   Fail: (16) fail ? 
   Fail: (15) naf(naf(male(richard)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Redo: (14) proceed(male(richard), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (15) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (16) read(_G3391) ? 
   Exit: (16) read(male(jeremy)) ? 
   Call: (16) proceed(male(jeremy), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (17) naf(naf(male(jeremy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Call: (18) naf(male(jeremy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (19) male(jeremy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Fail: (19) male(jeremy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Redo: (18) naf(male(jeremy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Exit: (18) naf(male(jeremy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (18) fail ? 
   Fail: (18) fail ? 
   Fail: (17) naf(naf(male(jeremy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Redo: (16) proceed(male(jeremy), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (17) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (18) read(_G3393) ? 
   Exit: (18) read(male(james)) ? 
   Call: (18) proceed(male(james), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (19) naf(naf(male(james)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Call: (20) naf(male(james)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (21) male(james)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Fail: (21) male(james)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Redo: (20) naf(male(james)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Exit: (20) naf(male(james)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (20) fail ? 
   Fail: (20) fail ? 
   Fail: (19) naf(naf(male(james)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Redo: (18) proceed(male(james), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (19) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (20) read(_G3395) ? 
   Exit: (20) read(female(alice)) ? 
   Call: (20) proceed(female(alice), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (21) naf(naf(female(alice)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Call: (22) naf(female(alice)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (23) female(alice)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Fail: (23) female(alice)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Redo: (22) naf(female(alice)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Exit: (22) naf(female(alice)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (22) fail ? 
   Fail: (22) fail ? 
   Fail: (21) naf(naf(female(alice)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Redo: (20) proceed(female(alice), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (21) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (22) read(_G3397) ? 
   Exit: (22) read(female(jimmy)) ? 
   Call: (22) proceed(female(jimmy), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (23) naf(naf(female(jimmy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Call: (24) naf(female(jimmy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (25) female(jimmy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Fail: (25) female(jimmy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Redo: (24) naf(female(jimmy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Exit: (24) naf(female(jimmy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (24) fail ? 
   Fail: (24) fail ? 
   Fail: (23) naf(naf(female(jimmy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Redo: (22) proceed(female(jimmy), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (23) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (24) read(_G3399) ? 
   Exit: (24) read(female(eimy)) ? 
   Call: (24) proceed(female(eimy), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (25) naf(naf(female(eimy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Call: (26) naf(female(eimy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (27) female(eimy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Fail: (27) female(eimy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]) ? 
   Redo: (26) naf(female(eimy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Exit: (26) naf(female(eimy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
   Call: (26) fail ? 
   Fail: (26) fail ? 
   Fail: (25) naf(naf(female(eimy)=family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]))) ? 
   Redo: (24) proceed(female(eimy), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (25) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (26) read(_G3401) ? 
   Exit: (26) read(end_of_file) ? 
   Call: (26) proceed(end_of_file, family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Call: (27) seen ? 
   Exit: (27) seen ? 
   Call: (27) fail ? 
   Fail: (27) fail ? 
   Fail: (26) proceed(end_of_file, family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (25) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (24) proceed(female(eimy), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (23) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (22) proceed(female(jimmy), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (21) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (20) proceed(female(alice), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (19) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (18) proceed(male(james), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (17) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (16) proceed(male(jeremy), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (15) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (14) proceed(male(richard), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (13) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (12) proceed(family(james, eimy, []), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (11) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (10) proceed(family(jeremy, jimmy, [child]), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (9) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (8) proceed(family(richard, alice, [child1, child2]), family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (7) read_and_proceed(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272]), 0) ? 
   Fail: (6) findallterm(family(_G3274, _G3275, [_G3265, _G3268, _G3271|_G3272])) ? 
false.






  [説明, 考察, 評価]

[*] 説明
      手続き findallterm(Term) の定義にあたって、(1)手続き内でファイルを開き、
    その後で、(2)ファイルから項を読み出す部分、(3)ユニファイできるか判断する、という
    形で、大きく３つの部分に分けて定義した。その中で、(2),(3) を再帰的に実行することで、
    ファイルの中に書かれているすべての項に関してマッチングを行うようにした。

      すなわち、手続き findallterm(Term) ではファイルを開いて入力ストリームを切り替え、
    read_and_proceed(Term,Count) では、現入力ストリームから項を 1 つ取り出す。
    proceed(Input,Term,Count) では、ファイルから取り出した項 Input と、ユーザからの入力 Term
    のマッチングを行い、マッチング成功の場合 Count をインクリメントし、その項 Input を表示する。
    マッチング失敗の場合何もしない。read_and_proceed → proceed → read_and_proceed → proceed → ...
    と再帰的に処理することで、ファイル内のすべての項をマッチングする。

      ファイル終端へ到達した際は、 proceed(Input,Term,Count) で Input が end_of_file となるので、
    カットオペレータにより処理を終了する。このとき、マッチングに成功した項が存在しない (Count が 0) なら
    cut-fail により、 findallterm(Term) の結果が失敗となるようにした。

      プログラム内で使用している、項のファイル /home/24115/cjh15113/rep08.txt を以下に示す:
    =======[/home/24115/cjh15113/rep08.txt]=======
   1| family(richard, alice, [child1, child2]).
   2| family(jeremy, jimmy, [child]).
   3| family(james, eimy, []).
   4|
   5| male(richard).
   6| male(jeremy).
   7| male(james).
   8|
   9| female(alice).
  10| female(jimmy).
  11| female(eimy).
    ==============================================


[*] 考察・評価
      はじめ、 seen の記述を忘れていたため、see で開いた入力ストリームから項を読み込むと、
    1 度読み込まれた項がそれ以降読み込まれなくなってしまった。手続きの完了時に seen でファイルを
    閉じるようにして、この問題は部分的に解決したが、エラーが起きたときなど、
    proceed(end_of_file, _, _) が呼ばれないまま終了してしまうと、seen されずファイルが閉じられない。
    バックトラックを利用して, エラーが生じた時にも確実に seen が実行されるようにできないかと考えたが、
    うまくプログラムが書けず、まだまだ未熟さを感じた。

      今回の演習問題を通して、Prolog においてファイルから文字列を入力・出力する方法を知ることができた。
    自分が触ったことのある言語におけるファイルの入出力の方法とは少し違い、とまどったが、それほど
    複雑なものには感じず、むしろファイルを開いたり閉じたりすることを含めた、プログラムの流れを考える
    ことに難しさを覚えた。

      今回作ったプログラムは、上で述べたとおり入力ストリームを閉じる部分に不備があるため、
    あまり良いプログラムではない。また、使用しているカットオペレータの中には、 proceed など
    レッドカットも含まれる。（これは手続き proceed を直接呼ぶことがないと前提して用いたが。）
    加えて、プログラム中でファイルを読み込む処理を書いているので、再帰処理を部分的に行いたいがために
    別の手続きを増やし、プログラム量が大きくなってしまっている。

      これらのことをふまえ、よりよい findallterm の定義が可能だと思うが、今の自分では
    そのような洗練されたプログラムを書けるほど、Prolog を習得できていないと感じた。
    よりよいプログラムを書けるように、Prolog の習得をがんばりたいと思った。
*/


% -----------------------------------------------------------------------------
% (練習 6.3)   (テキスト 155 ページ)
% 問: squeeze手続きを一般化して，カンマも扱えるようにせよ．カンマ
%     のすぐ前の空白はすべて削除し，各カンマのあとには1つの空白を
%     入れねばならないとする．
%
% [述語の説明]
%   - squeeze:
%       文字列を現入力ストリームから読み込み、単語間の複数個の空白を 1 個の空白
%       に置換する。加えて、カンマの前の空白をすべて削除し、各カンマのあとには
%       1 つの空白を入れる。
%   - dorest(Letter, State):
%       読み込んだ 1 文字 Letter に関して、状態 State の時の処理を行う。
%
% /* 以下に回答を示す */

squeeze :-
    get0(C),
    dorest(C,s1).

% 再帰の終了条件
dorest(46,_) :- !.          % '.'

% (s1): 初期状態
dorest(44,s1) :- !,         % ','
    put(44),
    get(C),
    dorest(C,s3).
dorest(32,s1) :- !,         % ' '
    get(C),
    dorest(C,s2).
dorest(C,s1) :- !,
    put(C),
    squeeze.

% (s2): 最後にスペースが入力された状態
dorest(44,s2) :- !,         % ' +,'
    put(44),
    get(C),
    dorest(C,s3).
dorest(C, s2) :- !,         % ' +[^,]'
    put(32),
    dorest(C,s1).
    
% (s3): 最後にカンマが入力された状態
dorest(44,s3) :- !,         % ',+,'
    put(44),
    get(C),
    dorest(C,s3).

dorest(C,s3) :- !,          % ',+[^,]'
    put(32),
    dorest(C,s1).
/*
  (実行例)

---------- 例 1: Hello   ,World. ----------

[debug]  ?- see('in1.txt'), squeeze, seen.
Hello, World
true.

[trace]  ?- see('in1.txt'), squeeze, seen.
   Call: (7) see('in1.txt') ? 
   Exit: (7) see('in1.txt') ? 
   Call: (7) squeeze ? 
   Call: (8) get0(_G446) ? 
   Exit: (8) get0(72) ? 
   Call: (8) dorest(72, s1) ? 
   Call: (9) put(72) ? 
H
   Exit: (9) put(72) ? 
   Call: (9) squeeze ? 
   Call: (10) get0(_G446) ? 
   Exit: (10) get0(101) ? 
   Call: (10) dorest(101, s1) ? 
   Call: (11) put(101) ? 
e
   Exit: (11) put(101) ? 
   Call: (11) squeeze ? 
   Call: (12) get0(_G446) ? 
   Exit: (12) get0(108) ? 
   Call: (12) dorest(108, s1) ? 
   Call: (13) put(108) ? 
l
   Exit: (13) put(108) ? 
   Call: (13) squeeze ? 
   Call: (14) get0(_G446) ? 
   Exit: (14) get0(108) ? 
   Call: (14) dorest(108, s1) ? 
   Call: (15) put(108) ? 
l
   Exit: (15) put(108) ? 
   Call: (15) squeeze ? 
   Call: (16) get0(_G446) ? 
   Exit: (16) get0(111) ? 
   Call: (16) dorest(111, s1) ? 
   Call: (17) put(111) ? 
o
   Exit: (17) put(111) ? 
   Call: (17) squeeze ? 
   Call: (18) get0(_G446) ? 
   Exit: (18) get0(32) ? 
   Call: (18) dorest(32, s1) ? 
   Call: (19) get(_G446) ? 
   Exit: (19) get(44) ? 
   Call: (19) dorest(44, s2) ? 
   Call: (20) put(44) ? 
,
   Exit: (20) put(44) ? 
   Call: (20) get(_G446) ? 
   Exit: (20) get(87) ? 
   Call: (20) dorest(87, s3) ? 
   Call: (21) put(32) ? 
 
   Exit: (21) put(32) ? 
   Call: (21) dorest(87, s1) ? 
   Call: (22) put(87) ? 
W
   Exit: (22) put(87) ? 
   Call: (22) squeeze ? 
   Call: (23) get0(_G446) ? 
   Exit: (23) get0(111) ? 
   Call: (23) dorest(111, s1) ? 
   Call: (24) put(111) ? 
o
   Exit: (24) put(111) ? 
   Call: (24) squeeze ? 
   Call: (25) get0(_G446) ? 
   Exit: (25) get0(114) ? 
   Call: (25) dorest(114, s1) ? 
   Call: (26) put(114) ? 
r
   Exit: (26) put(114) ? 
   Call: (26) squeeze ? 
   Call: (27) get0(_G446) ? 
   Exit: (27) get0(108) ? 
   Call: (27) dorest(108, s1) ? 
   Call: (28) put(108) ? 
l
   Exit: (28) put(108) ? 
   Call: (28) squeeze ? 
   Call: (29) get0(_G446) ? 
   Exit: (29) get0(100) ? 
   Call: (29) dorest(100, s1) ? 
   Call: (30) put(100) ? 
d
   Exit: (30) put(100) ? 
   Call: (30) squeeze ? 
   Call: (31) get0(_G446) ? 
   Exit: (31) get0(46) ? 
   Call: (31) dorest(46, s1) ? 
   Exit: (31) dorest(46, s1) ? 
   Exit: (30) squeeze ? 
   Exit: (29) dorest(100, s1) ? 
   Exit: (28) squeeze ? 
   Exit: (27) dorest(108, s1) ? 
   Exit: (26) squeeze ? 
   Exit: (25) dorest(114, s1) ? 
   Exit: (24) squeeze ? 
   Exit: (23) dorest(111, s1) ? 
   Exit: (22) squeeze ? 
   Exit: (21) dorest(87, s1) ? 
   Exit: (20) dorest(87, s3) ? 
   Exit: (19) dorest(44, s2) ? 
   Exit: (18) dorest(32, s1) ? 
   Exit: (17) squeeze ? 
   Exit: (16) dorest(111, s1) ? 
   Exit: (15) squeeze ? 
   Exit: (14) dorest(108, s1) ? 
   Exit: (13) squeeze ? 
   Exit: (12) dorest(108, s1) ? 
   Exit: (11) squeeze ? 

   Exit: (10) dorest(101, s1) ? 
   Exit: (9) squeeze ? 
   Exit: (8) dorest(72, s1) ? 
   Exit: (7) squeeze ? 
   Call: (7) seen ? 
   Exit: (7) seen ? 
true.


------------- 例 2: K     T. -------------

[debug]  ?- see('in2.txt'), squeeze, seen.
K T
true.

[trace]  ?- see('in2.txt'), squeeze, seen.
   Call: (7) see('in2.txt') ? 
   Exit: (7) see('in2.txt') ? 
   Call: (7) squeeze ? 
   Call: (8) get0(_G446) ? 
   Exit: (8) get0(75) ? 
   Call: (8) dorest(75, s1) ? 
   Call: (9) put(75) ? 
K
   Exit: (9) put(75) ? 
   Call: (9) squeeze ? 
   Call: (10) get0(_G446) ? 
   Exit: (10) get0(32) ? 
   Call: (10) dorest(32, s1) ? 
   Call: (11) get(_G446) ? 
   Exit: (11) get(84) ? 
   Call: (11) dorest(84, s2) ? 
   Call: (12) put(32) ? 
 
   Exit: (12) put(32) ? 
   Call: (12) dorest(84, s1) ? 
   Call: (13) put(84) ? 
T
   Exit: (13) put(84) ? 
   Call: (13) squeeze ? 
   Call: (14) get0(_G446) ? 
   Exit: (14) get0(46) ? 
   Call: (14) dorest(46, s1) ? 
   Exit: (14) dorest(46, s1) ? 
   Exit: (13) squeeze ? 
   Exit: (12) dorest(84, s1) ? 
   Exit: (11) dorest(84, s2) ? 
   Exit: (10) dorest(32, s1) ? 
   Exit: (9) squeeze ? 
   Exit: (8) dorest(75, s1) ? 
   Exit: (7) squeeze ? 
   Call: (7) seen ? 
   Exit: (7) seen ? 
true.


------------- 例 3. A,,,,B. --------------

[debug]  ?- see('in3.txt'), squeeze, seen.
A,,,, B
true.

[trace]  ?- see('in3.txt'), squeeze, seen.
   Call: (7) see('in3.txt') ? 
   Exit: (7) see('in3.txt') ? 
   Call: (7) squeeze ? 
   Call: (8) get0(_G446) ? 
   Exit: (8) get0(65) ? 
   Call: (8) dorest(65, s1) ? 
   Call: (9) put(65) ? 
A
   Exit: (9) put(65) ? 
   Call: (9) squeeze ? 
   Call: (10) get0(_G446) ? 
   Exit: (10) get0(44) ? 
   Call: (10) dorest(44, s1) ? 
   Call: (11) put(44) ? 
,
   Exit: (11) put(44) ? 
   Call: (11) get(_G446) ? 
   Exit: (11) get(44) ? 
   Call: (11) dorest(44, s3) ? 
   Call: (12) put(44) ? 
,
   Exit: (12) put(44) ? 
   Call: (12) get(_G446) ? 
   Exit: (12) get(44) ? 
   Call: (12) dorest(44, s3) ? 
   Call: (13) put(44) ? 
,
   Exit: (13) put(44) ? 
   Call: (13) get(_G446) ? 
   Exit: (13) get(44) ? 
   Call: (13) dorest(44, s3) ? 
   Call: (14) put(44) ? 
,
   Exit: (14) put(44) ? 
   Call: (14) get(_G446) ? 
   Exit: (14) get(66) ? 
   Call: (14) dorest(66, s3) ? 
   Call: (15) put(32) ? 
 
   Exit: (15) put(32) ? 
   Call: (15) dorest(66, s1) ? 
   Call: (16) put(66) ? 
B
   Exit: (16) put(66) ? 

   Call: (16) squeeze ? 
   Call: (17) get0(_G446) ? 
   Exit: (17) get0(46) ? 
   Call: (17) dorest(46, s1) ? 
   Exit: (17) dorest(46, s1) ? 
   Exit: (16) squeeze ? 
   Exit: (15) dorest(66, s1) ? 
   Exit: (14) dorest(66, s3) ? 
   Exit: (13) dorest(44, s3) ? 
   Exit: (12) dorest(44, s3) ? 
   Exit: (11) dorest(44, s3) ? 
   Exit: (10) dorest(44, s1) ? 
   Exit: (9) squeeze ? 
   Exit: (8) dorest(65, s1) ? 
   Exit: (7) squeeze ? 
   Call: (7) seen ? 
   Exit: (7) seen ? 
true.




  [説明, 考察, 評価]

[*] 説明
      教科書で定義されている手続き squeeze を拡張し、カンマの前のスペースをすべて削除下上で、各カンマのあとに
    1 つのスペースを入れるようにするために、まず、
        squeeze :-
          get0(C),
          put(C),     <-- これ
          dorest(C).
    この put(C) を手続き squeeze から取り除いた。これは、入力された文字列が、たとえば 'A , B' といったように、
    空白 + カンマ を含むとき、出力結果としては空白は取り除きたいが、上記 squeeze の put(C) があると
    これがそのまま表示されてしまうからである。

      問題文で squeeze 手続きを一般化して、と言っており、一般化する必要があると思ったが、果たしてどのような
    プログラムの書き方が一般化されているのか、いまいちよくわからなかったため、今回はオートマトンを使って、
    入力文字に対する出力の制御を行うように考えた。

      すなわち、次のような状態遷移をするオートマトンを考え、プログラム中の dorest 第二引数に状態を加え、
    各 dorest において出力と状態遷移をすることで、目的の動作をするプログラムを書くことを考えた。
    なお、以下の図において、 A / B は A を入力した際に B を出力して状態遷移することを示し、
    一部プログラムに合わせ、空白を入力し得ない ( get(C) を使って ) ときは、その入力に対する状態遷移を
    省いた。

          (' '、','、EOF 以外)=C / C
          +------------------------+
          |                        |        ',' / ','
      +----------+ <---------------+      +----------+
      |          |                        |          |
      |初期状態 s1|     ',' / ','     +----------+    |
      |          | ----------------> |  ','   s3| <--+
      +----------+ <---------------- +----------+
          |  A     (カンマ以外)=C / C      A 
  ' ' / ''|  |                    　      | 
          |  | (カンマ以外)=C / ' '+C      | 
          v  |                    　      | 
      +----------+               　       | 
      |   ' '  s2| -----------------------+ 
      +----------+       ',' / ','
     

    なお、今回実行例 3 で示したように、カンマが複数個続くような文字列が入力された際に、
    「カンマのすぐ前の空白はすべて削除し, 各カンマのあとには 1 つの空白を入れねばならないとする。」
    という指定に関して、文字列を前から処理することを考慮し、
       A,,,,B --> A , , , , B
    ではなく
       A,,,,B --> A,,,, B
    となるようにプログラムを書いた。


[*] 考察・評価
      今回の演習問題では、「手続き squeeze を一般化して」という指定があったが、自分が書いたプログラムが
    果たして一般化されているかどうか、あまり自信がない。

      Prolog においてオートマトンを使う方法は、これまでの演習でも何度か学んだので、
    比較的特殊な方法で実現した訳では無いと思う上、必要に応じて状態数を増やし、状態遷移とその際の
    出力も変えることで、容易に出力フォーマットを整えることができる。従って、その観点からすると、
    少しは一般化されているのではないかと思った。

      ただ、今回のプログラムでは Prolog 特有のバックトラックの機能は全く用いず、比較的これまでのプログラムと比べ
    手続き型プログラミング言語での書き方に似たような構造になってしまっているように思える。
    状態遷移の定義を数行で簡単に書くことができる部分は Prolog の恩恵を受けているが、
    それ以外の書き方においては、 Prolog の特色を生かし切れていないと思った。
    もっと綺麗な、一般化された Prolog ならではの書き方があるのかなと思ったし、そういった書き方が
    できるような考え方ができるといいなと思った。
*/
