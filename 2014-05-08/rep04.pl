% rep04: 第04回 演習課題レポート
% 2014年05月08日      by 24115113 名前: 林 政行
%
% 教科書の練習 (3.8), (3.9), (3.11) を解いてレポートとして提出する。
%
% /* 共通で使用するプログラム */

conc([],L,L).
conc([X|L1],L2,[X|L3]) :-
    conc(L1,L2,L3).

del(X,[X|Tail],Tail).
del(X,[Y|Tail],[Y|Tail1]) :-
    del(X,Tail,Tail1).

insert(X,List,BiggerList) :-
    del(X,BiggerList,List).

permutation([],[]).
permutation(L,[X|P]) :-
    del(X,L,L1),
    permutation(L1,P).

%
% -----------------------------------------------------------------------------
% (練習 3.8) 関係 subs(Set,Subset) の定義 (テキスト 79 ページ)
% 問: 関係
%    	subs(Set,Subset)
%     を定義せよ．ただし，SetとSubsetは集合を表すリストである．この関
%     係は，部分集合関係を調べるだけではなく，与えられた集合の可能な部
%     分集合をすべて生成するためにも使えるようにしたい．たとえば
%    	?- subs([a,b,c],S).
%    	S=[a,b,c];
%    	S=[b,c];
%    	S=[c];
%    	S=[];
%    	S=[a,c];
%    	S=[a];
%
% /* 以下に回答を示す */

subs_inner(Set,Subset) :-
    conc(_,L2,Set),
    conc(Subset,_,L2).

subs(Set,Subset) :-
    permutation(Set, P),
    subs_inner(P,Subset).

/*
  (実行例)
[trace] [2]  ?- subs([a,b,c],S).
   Call: (31) subs([a, b, c], _G3767) ? 
   Call: (32) permutation([a, b, c], _G3852) ? 
   Call: (33) del(_G3844, [a, b, c], _G3856) ? 
   Exit: (33) del(a, [a, b, c], [b, c]) ? 
   Call: (33) permutation([b, c], _G3845) ? 
   Call: (34) del(_G3847, [b, c], _G3859) ? 
   Exit: (34) del(b, [b, c], [c]) ? 
   Call: (34) permutation([c], _G3848) ? 
   Call: (35) del(_G3850, [c], _G3862) ? 
   Exit: (35) del(c, [c], []) ? 
   Call: (35) permutation([], _G3851) ? 
   Exit: (35) permutation([], []) ? 
   Exit: (34) permutation([c], [c]) ? 
   Exit: (33) permutation([b, c], [b, c]) ? 
   Exit: (32) permutation([a, b, c], [a, b, c]) ? 
   Call: (32) subs_inner([a, b, c], _G3767) ? 
   Call: (33) conc(_G3860, _G3861, [a, b, c]) ? 
   Exit: (33) conc([], [a, b, c], [a, b, c]) ? 
   Call: (33) conc(_G3767, _G3861, [a, b, c]) ? 
   Exit: (33) conc([], [a, b, c], [a, b, c]) ? 
   Exit: (32) subs_inner([a, b, c], []) ? 
   Exit: (31) subs([a, b, c], []) ? 
S = [] ;
   Redo: (33) conc(_G3767, _G3861, [a, b, c]) ? 
   Call: (34) conc(_G3854, _G3864, [b, c]) ? 
   Exit: (34) conc([], [b, c], [b, c]) ? 
   Exit: (33) conc([a], [b, c], [a, b, c]) ? 
   Exit: (32) subs_inner([a, b, c], [a]) ? 
   Exit: (31) subs([a, b, c], [a]) ? 
S = [a] ;
   Redo: (34) conc(_G3854, _G3864, [b, c]) ? 
   Call: (35) conc(_G3857, _G3867, [c]) ? 
   Exit: (35) conc([], [c], [c]) ? 
   Exit: (34) conc([b], [c], [b, c]) ? 
   Exit: (33) conc([a, b], [c], [a, b, c]) ? 
   Exit: (32) subs_inner([a, b, c], [a, b]) ? 
   Exit: (31) subs([a, b, c], [a, b]) ? 
S = [a, b] ;
   Redo: (35) conc(_G3857, _G3867, [c]) ? 
   Call: (36) conc(_G3860, _G3870, []) ? 
   Exit: (36) conc([], [], []) ? 
   Exit: (35) conc([c], [], [c]) ? 
   Exit: (34) conc([b, c], [], [b, c]) ? 
   Exit: (33) conc([a, b, c], [], [a, b, c]) ? 
   Exit: (32) subs_inner([a, b, c], [a, b, c]) ? 
   Exit: (31) subs([a, b, c], [a, b, c]) ? 
S = [a, b, c] ;
   Redo: (36) conc(_G3860, _G3870, []) ? 
   Fail: (36) conc(_G3860, _G3870, []) ? 
   Fail: (35) conc(_G3857, _G3867, [c]) ? 
   Fail: (34) conc(_G3854, _G3864, [b, c]) ? 
   Fail: (33) conc(_G3767, _G3861, [a, b, c]) ? 
   Redo: (33) conc(_G3860, _G3861, [a, b, c]) ? 
   Call: (34) conc(_G3854, _G3864, [b, c]) ? 
   Exit: (34) conc([], [b, c], [b, c]) ? 
   Exit: (33) conc([a], [b, c], [a, b, c]) ? 
   Call: (33) conc(_G3767, _G3864, [b, c]) ? 
   Exit: (33) conc([], [b, c], [b, c]) ? 
   Exit: (32) subs_inner([a, b, c], []) ? 
   Exit: (31) subs([a, b, c], []) ? 
S = [] ;
   Redo: (33) conc(_G3767, _G3864, [b, c]) ? notrace.
S = [b] ;
S = [b, c] ;
S = [] ;
S = [c] ;
S = [] ;
S = [] ;
S = [a] ;
S = [a, c] ;
S = [a, c, b] ;
S = [] ;
S = [c] ;
S = [c, b] ;
S = [] ;
S = [b] ;
S = [] ;
S = [] ;
S = [b] ;
S = [b, a] ;
S = [b, a, c] ;
S = [] ;
S = [a] ;
S = [a, c] ;
S = [] ;
S = [c] ;
S = [] ;
S = [] ;
S = [b] ;
S = [b, c] ;
S = [b, c, a] ;
S = [] ;
S = [c] ;
S = [c, a] ;
S = [] ;
S = [a] ;
S = [] ;
S = [] ;
S = [c] ;
S = [c, a] ;
S = [c, a, b] ;
S = [] ;
S = [a] ;
S = [a, b] ;
S = [] ;
S = [b] ;
S = [] ;
S = [] ;
S = [c] ;
S = [c, b] ;
S = [c, b, a] ;
S = [] ;
S = [b] ;
S = [b, a] ;
S = [] ;
S = [a] ;
S = [] ;
false.

  [説明, 考察, 評価]
  　教科書で定義されている関係 sublist を見ると、
     sublist(S,L) :-
        conc(L1,L2,L),
        conc(S,L3,L2).
  となっている。従って、リストと部分リストの関係は上記の方法で定義できる。
  関係 subs の定義において、集合はリストのあらゆる順序を考えればよいと考え、
  上記の sublist の定義において、L の部分を permutation を使ってあらゆる順序を
  考慮した集合に置き換えることで、目的の関係を定義できる、と考えた。

　　実行結果を見ると、重複した代入が多数出てしまっている。すべての集合を求めることは
  できているが、 permutation(Set,P) をしてから P に関して部分リストを求めているため、
  かなり多くの計算をすることになってしまっており、効率が悪いことがわかった。
　　この演習を通して、効率がよく、より柔軟な考え方を身につけられるよう、努力しようと思った。
*/


% -----------------------------------------------------------------------------
% (練習 3.9) 関係 dividelist の定義  (テキスト 79 ページ)
% 問: 関係
%        dividelist(List,List1,List2)
%     を，Listの要素がほぼ同じ長さのList1とList2に分割されるように定義せよ．たとえば
%        dividelist([a,b,c,d,e],[a,c,e],[b,d]).
%
% /* 以下に回答を示す */

dividelist_inner([], [], []).
dividelist_inner([Item], [Item], []).
dividelist_inner([Item], [], [Item]).
dividelist_inner([Item1, Item2], [Item1], [Item2]).
dividelist_inner([X,Y|Rest], List1, List2) :-
    conc([X], L1, List1),
    conc([Y], L2, List2),
    dividelist_inner(Rest,L1,L2).
    
dividelist(List, List1, List2) :-
    permutation(List,P),
    dividelist_inner(P, List1, List2).

/*
  (実行例)
[trace] [2]  ?- dividelist([a,b,c,d,e],[a,c,e],[b,d]).
   Call: (31) dividelist([a, b, c, d, e], [a, c, e], [b, d]) ? 
   Call: (32) permutation([a, b, c, d, e], _G4146) ? 
   Call: (33) del(_G4138, [a, b, c, d, e], _G4150) ? 
   Exit: (33) del(a, [a, b, c, d, e], [b, c, d, e]) ? 
   Call: (33) permutation([b, c, d, e], _G4139) ? 
   Call: (34) del(_G4141, [b, c, d, e], _G4153) ? 
   Exit: (34) del(b, [b, c, d, e], [c, d, e]) ? 
   Call: (34) permutation([c, d, e], _G4142) ? 
   Call: (35) del(_G4144, [c, d, e], _G4156) ? 
   Exit: (35) del(c, [c, d, e], [d, e]) ? 
   Call: (35) permutation([d, e], _G4145) ? 
   Call: (36) del(_G4147, [d, e], _G4159) ? 
   Exit: (36) del(d, [d, e], [e]) ? 
   Call: (36) permutation([e], _G4148) ? 
   Call: (37) del(_G4150, [e], _G4162) ? 
   Exit: (37) del(e, [e], []) ? 
   Call: (37) permutation([], _G4151) ? 
   Exit: (37) permutation([], []) ? 
   Exit: (36) permutation([e], [e]) ? 
   Exit: (35) permutation([d, e], [d, e]) ? 
   Exit: (34) permutation([c, d, e], [c, d, e]) ? 
   Exit: (33) permutation([b, c, d, e], [b, c, d, e]) ? 
   Exit: (32) permutation([a, b, c, d, e], [a, b, c, d, e]) ? 
   Call: (32) dividelist_inner([a, b, c, d, e], [a, c, e], [b, d]) ? 
   Call: (33) conc([a], _G4164, [a, c, e]) ? 
   Call: (34) conc([], _G4164, [c, e]) ? 
   Exit: (34) conc([], [c, e], [c, e]) ? 
   Exit: (33) conc([a], [c, e], [a, c, e]) ? 
   Call: (33) conc([b], _G4167, [b, d]) ? 
   Call: (34) conc([], _G4167, [d]) ? 
   Exit: (34) conc([], [d], [d]) ? 
   Exit: (33) conc([b], [d], [b, d]) ? 
   Call: (33) dividelist_inner([c, d, e], [c, e], [d]) ? 
   Call: (34) conc([c], _G4170, [c, e]) ? 
   Call: (35) conc([], _G4170, [e]) ? 
   Exit: (35) conc([], [e], [e]) ? 
   Exit: (34) conc([c], [e], [c, e]) ? 
   Call: (34) conc([d], _G4173, [d]) ? 
   Call: (35) conc([], _G4173, []) ? 
   Exit: (35) conc([], [], []) ? 
   Exit: (34) conc([d], [], [d]) ? 
   Call: (34) dividelist_inner([e], [e], []) ? 
   Exit: (34) dividelist_inner([e], [e], []) ? 
   Exit: (33) dividelist_inner([c, d, e], [c, e], [d]) ? 
   Exit: (32) dividelist_inner([a, b, c, d, e], [a, c, e], [b, d]) ? 
   Exit: (31) dividelist([a, b, c, d, e], [a, c, e], [b, d]) ? 
true ;
   Redo: (34) dividelist_inner([e], [e], []) ? 
   Fail: (34) dividelist_inner([e], [e], []) ? 
   Fail: (33) dividelist_inner([c, d, e], [c, e], [d]) ? 
   Fail: (32) dividelist_inner([a, b, c, d, e], [a, c, e], [b, d]) ? 
   Redo: (37) permutation([], _G4151) ? 
   Call: (38) del(_G4153, [], _G4165) ? 
   Fail: (38) del(_G4153, [], _G4165) ? 
   Fail: (37) permutation([], _G4151) ? 
   Redo: (37) del(_G4150, [e], _G4162) ? 
   Call: (38) del(_G4150, [], _G4154) ? 
   Fail: (38) del(_G4150, [], _G4154) ? 
   Fail: (37) del(_G4150, [e], _G4162) ? 
   Fail: (36) permutation([e], _G4148) ? 
   Redo: (36) del(_G4147, [d, e], _G4159) ? 
   .
   . (長いため省略)
   .
false.


[trace] [2]  ?-  dividelist([a,b,c],[a,c],[b]).
   Call: (31) dividelist([a, b, c], [a, c], [b]) ? 
   Call: (32) permutation([a, b, c], _G4122) ? 
   Call: (33) del(_G4114, [a, b, c], _G4126) ? 
   Exit: (33) del(a, [a, b, c], [b, c]) ? 
   Call: (33) permutation([b, c], _G4115) ? 
   Call: (34) del(_G4117, [b, c], _G4129) ? 
   Exit: (34) del(b, [b, c], [c]) ? 
   Call: (34) permutation([c], _G4118) ? 
   Call: (35) del(_G4120, [c], _G4132) ? 
   Exit: (35) del(c, [c], []) ? 
   Call: (35) permutation([], _G4121) ? 
   Exit: (35) permutation([], []) ? 
   Exit: (34) permutation([c], [c]) ? 
   Exit: (33) permutation([b, c], [b, c]) ? 
   Exit: (32) permutation([a, b, c], [a, b, c]) ? 
   Call: (32) dividelist_inner([a, b, c], [a, c], [b]) ? 
   Call: (33) conc([a], _G4134, [a, c]) ? 
   Call: (34) conc([], _G4134, [c]) ? 
   Exit: (34) conc([], [c], [c]) ? 
   Exit: (33) conc([a], [c], [a, c]) ? 
   Call: (33) conc([b], _G4137, [b]) ? 
   Call: (34) conc([], _G4137, []) ? 
   Exit: (34) conc([], [], []) ? 
   Exit: (33) conc([b], [], [b]) ? 
   Call: (33) dividelist_inner([c], [c], []) ? 
   Exit: (33) dividelist_inner([c], [c], []) ? 
   Exit: (32) dividelist_inner([a, b, c], [a, c], [b]) ? 
   Exit: (31) dividelist([a, b, c], [a, c], [b]) ? 
true 

  [説明, 考察, 評価]
  　関係 dividelist(List,List1,List2) の動作として、以下の 4 種類を考えた。
     (a) List の要素が空
     (b) List の要素が 1 つだけ
     (c) List の要素が 2 つだけ
     (d) List の要素が 3 つ以上
  このとき、
  (a)に関しては、 List1, List2 ともに [] にすればよく、
  (b)に関しては、 List1 か List2 のどちらかに List の要素を入れ、
  (c)に関しては、 List1 と List2 の両方に 1 つずつ List の要素を入れればよい。
  (d)に関しては、 List の先頭 2 要素を取り出し、List1 と List2 の両方に加え、
  再び dividelist を呼び出す、という再帰処理を行えばよいと考えた。
  　今回、List1 と List2 への分け方が問題文から読み取れなかったため、例のような、
  リストの順序を維持した分割方法だけでなく、あらゆる分割方法を考慮した関係を定義した。
  すなわち、はじめに dividelist に入れられた List を permutation によりあらゆる
  順序を考慮した集合のようにして、前述した方法で分割を行うようにした。

  　実行例を見ると、問題文中の例のような、順序が揃ったリストの分割に加え、
  順序を無視した分割も、意図した通りにできていることが確認できた。

  　だんだんと Prolog におけるリストの扱い方がわかってきたが、まだまだリストを使った
  関係の記述は難しいと感じている。もっと頭の良い記述方法があると思うし、そういった記述
  ができるよう二なりたいと思った。
*/


% -----------------------------------------------------------------------------
% (練習 3.11) 関係 flatten の定義  (テキスト 80 ページ)
% 問: 関係
%    	flat(List,FlatList)
%     を定義せよ．ただしListはリストのリストで，FlatListはListの部分リスト(またはそのまた部分リスト)の要素が
%     平板なリストとなるように，Listを平滑化したものである．たとえば，
%    	?-flat([a,b,[c,d],[],[[[e]]],f],L).
%    	  L=[a,b,c,d,e,f]
%
% /* 以下に回答を示す */

flat([],[]).                  % 再帰の終了条件

flat([[]|Rest],FlatList) :-   % 再帰処理(1)
    flat(Rest, FlatList).     % * [] を無視

flat([Item|Rest],FlatList) :- % 再帰処理(2)
    Item \= [],               % * [] でない
    Item \= [_|_],            % * List = [[a,b,...]] でない
    flat(Rest, L2),
    conc([Item], L2, FlatList).

flat([Item|Rest],FlatList) :- % 再帰処理(3)
    Item \= [],               % * [] でない
    Item  = [_|_],            % * List = [[a,b,...]] である
    flat(Item, L1),
    flat(Rest, L2),
    conc(L1, L2, FlatList).

/*
  (実行例)
[trace] [3]  ?- flat([a,b,[c,d],[],[[[e]]],f],L).
   Call: (36) flat([a, b, [c, d], [], [[[e]]], f], _G5030) ? 
   Call: (37) a\=[] ? 
   Exit: (37) a\=[] ? 
   Call: (37) a\=[_G5131|_G5132] ? 
   Exit: (37) a\=[_G5131|_G5132] ? 
   Call: (37) flat([b, [c, d], [], [[[e]]], f], _G5142) ? 
   Call: (38) b\=[] ? 
   Exit: (38) b\=[] ? 
   Call: (38) b\=[_G5134|_G5135] ? 
   Exit: (38) b\=[_G5134|_G5135] ? 
   Call: (38) flat([[c, d], [], [[[e]]], f], _G5145) ? 
   Call: (39) [c, d]\=[] ? 
   Exit: (39) [c, d]\=[] ? 
   Call: (39) [c, d]\=[_G5137|_G5138] ? 
   Fail: (39) [c, d]\=[_G5137|_G5138] ? 
   Redo: (38) flat([[c, d], [], [[[e]]], f], _G5145) ? 
   Call: (39) [c, d]\=[] ? 
   Exit: (39) [c, d]\=[] ? 
   Call: (39) [c, d]=[_G5137|_G5138] ? 
   Exit: (39) [c, d]=[c, d] ? 
   Call: (39) flat([c, d], _G5148) ? 
   Call: (40) c\=[] ? 
   Exit: (40) c\=[] ? 
   Call: (40) c\=[_G5140|_G5141] ? 
   Exit: (40) c\=[_G5140|_G5141] ? 
   Call: (40) flat([d], _G5151) ? 
   Call: (41) d\=[] ? 
   Exit: (41) d\=[] ? 
   Call: (41) d\=[_G5143|_G5144] ? 
   Exit: (41) d\=[_G5143|_G5144] ? 
   Call: (41) flat([], _G5154) ? 
   Exit: (41) flat([], []) ? 
   Call: (41) conc([d], [], _G5158) ? 
   Call: (42) conc([], [], _G5150) ? 
   Exit: (42) conc([], [], []) ? 
   Exit: (41) conc([d], [], [d]) ? 
   Exit: (40) flat([d], [d]) ? 
   Call: (40) conc([c], [d], _G5164) ? 
   Call: (41) conc([], [d], _G5156) ? 
   Exit: (41) conc([], [d], [d]) ? 
   Exit: (40) conc([c], [d], [c, d]) ? 
   Exit: (39) flat([c, d], [c, d]) ? 
   Call: (39) flat([[], [[[e]]], f], _G5166) ? 
   Call: (40) flat([[[[e]]], f], _G5166) ? 
   Call: (41) [[[e]]]\=[] ? 
   Exit: (41) [[[e]]]\=[] ? 
   Call: (41) [[[e]]]\=[_G5158|_G5159] ? 
   Fail: (41) [[[e]]]\=[_G5158|_G5159] ? 
   Redo: (40) flat([[[[e]]], f], _G5166) ? 
   Call: (41) [[[e]]]\=[] ? 
   Exit: (41) [[[e]]]\=[] ? 
   Call: (41) [[[e]]]=[_G5158|_G5159] ? 
   Exit: (41) [[[e]]]=[[[e]]] ? 
   Call: (41) flat([[[e]]], _G5169) ? 
   Call: (42) [[e]]\=[] ? 
   Exit: (42) [[e]]\=[] ? 
   Call: (42) [[e]]\=[_G5161|_G5162] ? 
   Fail: (42) [[e]]\=[_G5161|_G5162] ? 
   Redo: (41) flat([[[e]]], _G5169) ? 
   Call: (42) [[e]]\=[] ? 
   Exit: (42) [[e]]\=[] ? 
   Call: (42) [[e]]=[_G5161|_G5162] ? 
   Exit: (42) [[e]]=[[e]] ? 
   Call: (42) flat([[e]], _G5172) ? 
   Call: (43) [e]\=[] ? 
   Exit: (43) [e]\=[] ? 
   Call: (43) [e]\=[_G5164|_G5165] ? 
   Fail: (43) [e]\=[_G5164|_G5165] ? 
   Redo: (42) flat([[e]], _G5172) ? 
   Call: (43) [e]\=[] ? 
   Exit: (43) [e]\=[] ? 
   Call: (43) [e]=[_G5164|_G5165] ? 
   Exit: (43) [e]=[e] ? 
   Call: (43) flat([e], _G5175) ? 
   Call: (44) e\=[] ? 
   Exit: (44) e\=[] ? 
   Call: (44) e\=[_G5167|_G5168] ? 
   Exit: (44) e\=[_G5167|_G5168] ? 
   Call: (44) flat([], _G5178) ? 
   Exit: (44) flat([], []) ? 
   Call: (44) conc([e], [], _G5182) ? 
   Call: (45) conc([], [], _G5174) ? 
   Exit: (45) conc([], [], []) ? 
   Exit: (44) conc([e], [], [e]) ? 
   Exit: (43) flat([e], [e]) ? 
   Call: (43) flat([], _G5184) ? 
   Exit: (43) flat([], []) ? 
   Call: (43) conc([e], [], _G5185) ? 
   Call: (44) conc([], [], _G5177) ? 
   Exit: (44) conc([], [], []) ? 
   Exit: (43) conc([e], [], [e]) ? 
   Exit: (42) flat([[e]], [e]) ? 
   Call: (42) flat([], _G5187) ? 
   Exit: (42) flat([], []) ? 
   Call: (42) conc([e], [], _G5188) ? 
   Call: (43) conc([], [], _G5180) ? 
   Exit: (43) conc([], [], []) ? 
   Exit: (42) conc([e], [], [e]) ? 
   Exit: (41) flat([[[e]]], [e]) ? 
   Call: (41) flat([f], _G5190) ? 
   Call: (42) f\=[] ? 
   Exit: (42) f\=[] ? 
   Call: (42) f\=[_G5182|_G5183] ? 
   Exit: (42) f\=[_G5182|_G5183] ? 
   Call: (42) flat([], _G5193) ? 
   Exit: (42) flat([], []) ? 
   Call: (42) conc([f], [], _G5197) ? 
   Call: (43) conc([], [], _G5189) ? 
   Exit: (43) conc([], [], []) ? 
   Exit: (42) conc([f], [], [f]) ? 
   Exit: (41) flat([f], [f]) ? 
   Call: (41) conc([e], [f], _G5200) ? 
   Call: (42) conc([], [f], _G5192) ? 
   Exit: (42) conc([], [f], [f]) ? 
   Exit: (41) conc([e], [f], [e, f]) ? 
   Exit: (40) flat([[[[e]]], f], [e, f]) ? 
   Exit: (39) flat([[], [[[e]]], f], [e, f]) ? 
   Call: (39) conc([c, d], [e, f], _G5203) ? 
   Call: (40) conc([d], [e, f], _G5195) ? 
   Call: (41) conc([], [e, f], _G5198) ? 
   Exit: (41) conc([], [e, f], [e, f]) ? 
   Exit: (40) conc([d], [e, f], [d, e, f]) ? 
   Exit: (39) conc([c, d], [e, f], [c, d, e, f]) ? 
   Exit: (38) flat([[c, d], [], [[[e]]], f], [c, d, e, f]) ? 
   Call: (38) conc([b], [c, d, e, f], _G5212) ? 
   Call: (39) conc([], [c, d, e, f], _G5204) ? 
   Exit: (39) conc([], [c, d, e, f], [c, d, e, f]) ? 
   Exit: (38) conc([b], [c, d, e, f], [b, c, d, e, f]) ? 
   Exit: (37) flat([b, [c, d], [], [[[e]]], f], [b, c, d, e, f]) ? 
   Call: (37) conc([a], [b, c, d, e, f], _G5030) ? 
   Call: (38) conc([], [b, c, d, e, f], _G5210) ? 
   Exit: (38) conc([], [b, c, d, e, f], [b, c, d, e, f]) ? 
   Exit: (37) conc([a], [b, c, d, e, f], [a, b, c, d, e, f]) ? 
   Exit: (36) flat([a, b, [c, d], [], [[[e]]], f], [a, b, c, d, e, f]) ? 
L = [a, b, c, d, e, f] ;
   Redo: (41) flat([f], _G5190) ? 
   Call: (42) f\=[] ? 
   Exit: (42) f\=[] ? 
   Call: (42) f=[_G5182|_G5183] ? 
   Fail: (42) f=[_G5182|_G5183] ? 
   Fail: (41) flat([f], _G5190) ? 
   Redo: (43) flat([e], _G5175) ? 
   Call: (44) e\=[] ? 
   Exit: (44) e\=[] ? 
   Call: (44) e=[_G5167|_G5168] ? 
   Fail: (44) e=[_G5167|_G5168] ? 
   Fail: (43) flat([e], _G5175) ? 
   Fail: (42) flat([[e]], _G5172) ? 
   Fail: (41) flat([[[e]]], _G5169) ? 
   Fail: (40) flat([[[[e]]], f], _G5166) ? 
   Redo: (39) flat([[], [[[e]]], f], _G5166) ? 
   Call: (40) []\=[] ? 
   Fail: (40) []\=[] ? 
   Redo: (39) flat([[], [[[e]]], f], _G5166) ? 
   Call: (40) []\=[] ? 
   Fail: (40) []\=[] ? 
   Fail: (39) flat([[], [[[e]]], f], _G5166) ? 
   Redo: (40) flat([d], _G5151) ? 
   Call: (41) d\=[] ? 
   Exit: (41) d\=[] ? 
   Call: (41) d=[_G5143|_G5144] ? 
   Fail: (41) d=[_G5143|_G5144] ? 
   Fail: (40) flat([d], _G5151) ? 
   Redo: (39) flat([c, d], _G5148) ? 
   Call: (40) c\=[] ? 
   Exit: (40) c\=[] ? 
   Call: (40) c=[_G5140|_G5141] ? 
   Fail: (40) c=[_G5140|_G5141] ? 
   Fail: (39) flat([c, d], _G5148) ? 
   Fail: (38) flat([[c, d], [], [[[e]]], f], _G5145) ? 
   Redo: (37) flat([b, [c, d], [], [[[e]]], f], _G5142) ? 
   Call: (38) b\=[] ? 
   Exit: (38) b\=[] ? 
   Call: (38) b=[_G5134|_G5135] ? 
   Fail: (38) b=[_G5134|_G5135] ? 
   Fail: (37) flat([b, [c, d], [], [[[e]]], f], _G5142) ? 
   Redo: (36) flat([a, b, [c, d], [], [[[e]]], f], _G5030) ? 
   Call: (37) a\=[] ? 
   Exit: (37) a\=[] ? 
   Call: (37) a=[_G5131|_G5132] ? 
   Fail: (37) a=[_G5131|_G5132] ? 
   Fail: (36) flat([a, b, [c, d], [], [[[e]]], f], _G5030) ? 
false.

  [説明, 考察, 評価]
  　flat(List,FlatList) に関して、与えられた List の要素を先頭から 1 つずつ取り出し、
  その要素を flat の再帰呼び出しにより平板なリストとして、帰ってきたリストを FlatList に
  追加する、という実装方法を考えた。
  　はじめ、上記回答のコメントにある '*' の部分を書かずに、
      flat([[Item]|Rest], FlatList) :- ...
      flat([Item|Rest], FlatList) :- ...
  のみを書いたところ、実行結果が
    ?- flat([a,[b]],L).
       L = [a, b];
       L = [a, [b]];
  という具合に、誤った答えも得られるようになってしまった。そこで、 '*' 部分の条件を加えることで、
  欲しい答え L = [a, b] のみを得られるようにした。加えて、List に空リスト [] が入っている時に
  FlatList に入れないようにする条件も加えた。

  　実行結果より、欲しい答えが得られていることがわかった。

  　今回はプログラムが複雑になってしまい、きれいに書くことができなかった。
  トレースの内容を見ても、効率よく動作しているようには見えず、良いプログラムでは
  ないことがわかる。より洗練された考え方を身につけられるよう、努力しようと思った。
*/

