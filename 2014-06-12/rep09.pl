% rep09: 第09回 演習課題レポート
% 2014年06月12日      by 24115113 名前: 林 政行
%
% 教科書の練習 (7.3), (7.5), (7.8) を解いてレポートとして提出する。
%
% -----------------------------------------------------------------------------
% (練習 7.3) 述語 ground の定義 (テキスト 175 ページ)
% 問: 述語ground(Term)を，具体化されていない変数がTermに含まれない
%     なら真となるように定義せよ．※ただし，組み込み述語にgroundが
%     定義されているので，gndとして定義せよ．
%
% [述語の説明]
%   - gnd(Term):
%       具体化されていない変数が Term に含まれないなら真となる。
%
% /* 以下に回答を示す */

% ここから本体
gnd(Term) :-
    nonvar(Term),
    Term =.. [F|Args],
    checkArgs(F,Args).

checkArgs(_,[]) :- !.
checkArgs(F,[Arg|Rest]) :-
    nonvar(Arg),
    atomic(Arg), !,
    checkArgs(F,Rest).
checkArgs(F,[Arg|Rest]) :- !,
    nonvar(Arg),
    Arg =.. [F1|Args1],
    checkArgs(F1,Args1),
    checkArgs(F,Rest).


/*
  (実行例)

[debug]  ?- gnd(x).
true.

[debug]  ?- gnd(X).
false.

[debug]  ?- gnd(f(X)).
false.

[debug]  ?- gnd(f(a,g(x))).
true.

[debug]  ?- gnd(f(a,g(X))).
false.


[trace]  ?- gnd(x).
   Call: (6) gnd(x) ? 
   Call: (7) nonvar(x) ? 
   Exit: (7) nonvar(x) ? 
   Call: (7) x=..[_G609|_G610] ? 
   Exit: (7) x=..[x] ? 
   Call: (7) checkArgs(x, []) ? 
   Exit: (7) checkArgs(x, []) ? 
   Exit: (6) gnd(x) ? 
true.


[trace]  ?- gnd(X).
   Call: (6) gnd(_G595) ? 
   Call: (7) nonvar(_G595) ? 
   Fail: (7) nonvar(_G595) ? 
   Fail: (6) gnd(_G595) ? 
false.


[trace]  ?- gnd(f(X)).
   Call: (6) gnd(f(_G885)) ? 
   Call: (7) nonvar(f(_G885)) ? 
   Exit: (7) nonvar(f(_G885)) ? 
   Call: (7) f(_G885)=..[_G956|_G957] ? 
   Exit: (7) f(_G885)=..[f, _G885] ? 
   Call: (7) checkArgs(f, [_G885]) ? 
   Call: (8) nonvar(_G885) ? 
   Fail: (8) nonvar(_G885) ? 
   Redo: (7) checkArgs(f, [_G885]) ? 
   Call: (8) nonvar(_G885) ? 
   Fail: (8) nonvar(_G885) ? 
   Fail: (7) checkArgs(f, [_G885]) ? 
   Fail: (6) gnd(f(_G885)) ? 
false.


[trace]  ?- gnd(f(a,g(x))).
   Call: (6) gnd(f(a, g(x))) ? 
   Call: (7) nonvar(f(a, g(x))) ? 
   Exit: (7) nonvar(f(a, g(x))) ? 
   Call: (7) f(a, g(x))=..[_G1240|_G1241] ? 
   Exit: (7) f(a, g(x))=..[f, a, g(x)] ? 
   Call: (7) checkArgs(f, [a, g(x)]) ? 
   Call: (8) nonvar(a) ? 
   Exit: (8) nonvar(a) ? 
   Call: (8) atomic(a) ? 
   Exit: (8) atomic(a) ? 
   Call: (8) checkArgs(f, [g(x)]) ? 
   Call: (9) nonvar(g(x)) ? 
   Exit: (9) nonvar(g(x)) ? 
   Call: (9) atomic(g(x)) ? 
   Fail: (9) atomic(g(x)) ? 
   Redo: (8) checkArgs(f, [g(x)]) ? 
   Call: (9) nonvar(g(x)) ? 
   Exit: (9) nonvar(g(x)) ? 
   Call: (9) g(x)=..[_G1249|_G1250] ? 
   Exit: (9) g(x)=..[g, x] ? 
   Call: (9) checkArgs(g, [x]) ? 
   Call: (10) nonvar(x) ? 
   Exit: (10) nonvar(x) ? 
   Call: (10) atomic(x) ? 
   Exit: (10) atomic(x) ? 
   Call: (10) checkArgs(g, []) ? 
   Exit: (10) checkArgs(g, []) ? 
   Exit: (9) checkArgs(g, [x]) ? 
   Call: (9) checkArgs(f, []) ? 
   Exit: (9) checkArgs(f, []) ? 
   Exit: (8) checkArgs(f, [g(x)]) ? 
   Exit: (7) checkArgs(f, [a, g(x)]) ? 
   Exit: (6) gnd(f(a, g(x))) ? 
true.


[trace]  ?- gnd(f(a,g(X))).
   Call: (6) gnd(f(a, g(_G1465))) ? 
   Call: (7) nonvar(f(a, g(_G1465))) ? 
   Exit: (7) nonvar(f(a, g(_G1465))) ? 
   Call: (7) f(a, g(_G1465))=..[_G1542|_G1543] ? 
   Exit: (7) f(a, g(_G1465))=..[f, a, g(_G1465)] ? 
   Call: (7) checkArgs(f, [a, g(_G1465)]) ? 
   Call: (8) nonvar(a) ? 
   Exit: (8) nonvar(a) ? 
   Call: (8) atomic(a) ? 
   Exit: (8) atomic(a) ? 
   Call: (8) checkArgs(f, [g(_G1465)]) ? 
   Call: (9) nonvar(g(_G1465)) ? 
   Exit: (9) nonvar(g(_G1465)) ? 
   Call: (9) atomic(g(_G1465)) ? 
   Fail: (9) atomic(g(_G1465)) ? 
   Redo: (8) checkArgs(f, [g(_G1465)]) ? 
   Call: (9) nonvar(g(_G1465)) ? 
   Exit: (9) nonvar(g(_G1465)) ? 
   Call: (9) g(_G1465)=..[_G1551|_G1552] ? 
   Exit: (9) g(_G1465)=..[g, _G1465] ? 
   Call: (9) checkArgs(g, [_G1465]) ? 
   Call: (10) nonvar(_G1465) ? 
   Fail: (10) nonvar(_G1465) ? 
   Redo: (9) checkArgs(g, [_G1465]) ? 
   Call: (10) nonvar(_G1465) ? 
   Fail: (10) nonvar(_G1465) ? 
   Fail: (9) checkArgs(g, [_G1465]) ? 
   Fail: (8) checkArgs(f, [g(_G1465)]) ? 
   Fail: (7) checkArgs(f, [a, g(_G1465)]) ? 
   Fail: (6) gnd(f(a, g(_G1465))) ? 
false.


  [説明, 考察, 評価]
      具体化されていない変数が Term に存在しない場合 True を返す述語 gnd の定義にあたって、
    項の組み立て、分解を行う =.. を使うことで、Term から述語と引数を取り出し、今回学んだ
    組み込み述語 var, novar, atomic を使うことで、具体化されているかを確認する方法をとった。
    また、引数の中に述語が含まれているときは、再帰的にその述語に関して前述の処理を行うようにした。

      今回、項に関する操作、確認が行える組み込み述語を学び、はじめはその使い方がよくわからず、
    メタプログラミングを行うのがすごく難しく感じたが、それらの組み込み述語を実際に使って何度も
    結果を確認し、試行錯誤することで、ようやくその動作を理解することができた。

      今回特に、組み込み述語 =.. の動作に慣れるのが大変であった。
         X =.. L
    としたとき、X が具体化されていない変数だと、Exception が生じてしまった。
    これを防ぐために、nonvar(X) として X が変数でないと確認してから、X の分解を行う形
    にすることで解決したが、Exception が生じる理由がなかなかわからず、時間がかかってしまった。

*/


% -----------------------------------------------------------------------------
% (練習 7.5)   (テキスト 155 ページ)
% 問: subsumes(Term1,Term2)
%    という関係を，Term1がTerm2と等しいか一般的であるように定義せよ．
%    たとえば，
%         ?- subsumes(X,c).
%         yes
%         ?- subsumes(g(X),g(t(Y))).
%         yes
%         ?- subsumes(f(X,X),f(a,b)).
%         no
%    つまり，subsumes(Term1,Term2)は以下の式を満足するときに真を
%    返す述語とする．
%         HB(Term1)⊇HB(Term2)
%    ここでHB(T)は項Tのエルブラン基底の集合を表す．
%    ただし，組み込み述語にsubsumesが定義されているので，
%    subsumeとして定義せよ
%
%
% [述語の説明]
%   - subsumes(Term1, Term2):
%       Term1 が Term2 と等しいか一般的であるという関係を表す。
%       Term1 と Term2 の述語名またはアリティが異なる場合、false となる。
%   - cmpArgs(Args1, Args2):
%       述語の引数 Args1, Args2 を比較し、HB(Term1)⊇HB(Term2)であれば真を返す
%
% /* 以下に回答を示す */

% プログラム本体
subsume(Term1, _) :- var(Term1), !.
subsume(Term1, Term2) :- nonvar(Term2), not(not(Term1=Term2)), !.
subsume(Term1, Term2) :-
    not( atomic(Term1) ),
    not( atomic(Term2) ),
    nonvar(Term1),
    nonvar(Term2),
    Term1 =.. [F|Args1],
    Term2 =.. [F|Args2],
    cmpArgs(Args1, Args2).

cmpArgs([],[]).
cmpArgs([Arg|L1], [Arg|L2]) :- !, cmpArgs(L1, L2).
cmpArgs([Arg1|L1], [Arg2|L2]) :-   % Arg1 が変数で Arg2 がアトムのとき
    var(Arg1),                     % 
    atomic(Arg2), !,               % 
    not(not(Arg1 = Arg2)),         %   Arg1 を具体化する
    cmpArgs(L1, L2).               % --> 次の引数の比較
cmpArgs([Arg1|L1], [Arg2|L2]) :-   % Arg1 が変数で Arg2 がアトムでないとき
    var(Arg1), !,                  % 
    not(not(Arg1 = Arg2)),         %   Arg1 と Arg2 をマッチングする
    cmpArgs(L1, L2).               % --> 次の引数の比較
cmpArgs([Arg1|L1], [Arg2|L2]) :-   % Arg1 と Arg2 が構造のとき
    subsume(Arg1, Arg2),           %   Arg1 と Arg2 で subsume を再帰呼び出し
    cmpArgs(L1, L2).               % --> 次の引数の比較


/*
  (実行例)

[debug]  ?- subsume(X,c).
true.

[debug]  ?- subsume(g(X),g(t(Y))).
true.

[debug]  ?- subsume(f(X,X),f(a,b)).
false.

[trace]  ?- subsume(X,c).
   Call: (6) subsume(_G3197, c) ? 
   Call: (7) var(_G3197) ? 
   Exit: (7) var(_G3197) ? 
   Exit: (6) subsume(_G3197, c) ? 
true.

[trace]  ?- subsume(g(X),g(t(Y))).
   Call: (6) subsume(g(_G2220), g(t(_G2222))) ? 
   Call: (7) var(g(_G2220)) ? 
   Fail: (7) var(g(_G2220)) ? 
   Redo: (6) subsume(g(_G2220), g(t(_G2222))) ? 
   Call: (7) nonvar(g(t(_G2222))) ? 
   Exit: (7) nonvar(g(t(_G2222))) ? 
^  Call: (7) not(not(g(_G2220)=g(t(_G2222)))) ? 
^  Exit: (7) not(user:not(g(_G2220)=g(t(_G2222)))) ? 
   Exit: (6) subsume(g(_G2220), g(t(_G2222))) ? 
true.

[trace]  ?- subsume(f(X,X),f(a,b)).
   Call: (6) subsume(f(_G2551, _G2551), f(a, b)) ? 
   Call: (7) var(f(_G2551, _G2551)) ? 
   Fail: (7) var(f(_G2551, _G2551)) ? 
   Redo: (6) subsume(f(_G2551, _G2551), f(a, b)) ? 
   Call: (7) nonvar(f(a, b)) ? 
   Exit: (7) nonvar(f(a, b)) ? 
^  Call: (7) not(not(f(_G2551, _G2551)=f(a, b))) ? 
^  Fail: (7) not(user:not(f(_G2551, _G2551)=f(a, b))) ? 
   Redo: (6) subsume(f(_G2551, _G2551), f(a, b)) ? 
^  Call: (7) not(atomic(f(_G2551, _G2551))) ? 
^  Exit: (7) not(user:atomic(f(_G2551, _G2551))) ? 
^  Call: (7) not(atomic(f(a, b))) ? 
^  Exit: (7) not(user:atomic(f(a, b))) ? 
   Call: (7) nonvar(f(_G2551, _G2551)) ? 
   Exit: (7) nonvar(f(_G2551, _G2551)) ? 
   Call: (7) nonvar(f(a, b)) ? 
   Exit: (7) nonvar(f(a, b)) ? 
   Call: (7) f(_G2551, _G2551)=..[_G2639|_G2640] ? 
   Exit: (7) f(_G2551, _G2551)=..[f, _G2551, _G2551] ? 
   Call: (7) f(a, b)=..[f|_G2649] ? 
   Exit: (7) f(a, b)=..[f, a, b] ? 
   Call: (7) cmpArgs([_G2551, _G2551], [a, b]) ? 
   Call: (8) cmpArgs([a], [b]) ? 
   Call: (9) var(a) ? 
   Fail: (9) var(a) ? 
   Redo: (8) cmpArgs([a], [b]) ? 
   Call: (9) var(a) ? 
   Fail: (9) var(a) ? 
   Redo: (8) cmpArgs([a], [b]) ? 
   Call: (9) subsume(a, b) ? 
   Call: (10) var(a) ? 
   Fail: (10) var(a) ? 
   Redo: (9) subsume(a, b) ? 
   Call: (10) nonvar(b) ? 
   Exit: (10) nonvar(b) ? 
^  Call: (10) not(not(a=b)) ? 
^  Fail: (10) not(user:not(a=b)) ? 
   Redo: (9) subsume(a, b) ? 
^  Call: (10) not(atomic(a)) ? 
^  Fail: (10) not(user:atomic(a)) ? 
   Fail: (9) subsume(a, b) ? 
   Fail: (8) cmpArgs([a], [b]) ? 
   Fail: (7) cmpArgs([_G2551, _G2551], [a, b]) ? 
   Fail: (6) subsume(f(_G2551, _G2551), f(a, b)) ? 
false.


  [説明, 考察, 評価]
      述語 subsume の定義にあたって、
        HB(Term1)⊇HB(Term2)
    となるような Term1, Term2 を考えたとき、次の3通りの関係を考えた。
      1) Term1 が変数のとき
      2) Term1, Term2 の述語とアリティが等しいとき
      3) それ以外
    このとき、それぞれの場合において、次のことが言えると考えた。

      1) Term1 が変数のとき
           このとき、Term2 が如何なる値であれ、HB(Term1)⊇HB(Term2) の関係は成り立つ。

      2) Term1 が具体化された値のとき
           このとき、Term2 も同じ値であれば、HB(Term1)⊇HB(Term2) は成り立つ。

      3) Term1, Term2 の述語とアリティが等しいとき
           Term1 と Term2 の引数（それぞれ A1, A2 とする）を、一つずつ比較していく。
         このとき
           a) A1 が具体化された値で、A2 が変数のとき、 HB(Term1)⊇HB(Term2) とはなり得ない。
           b) A1 が具体化された値で、A2 も具体化された値のとき
               A1, A2 ともにアトムであれば、どちらも同じ値のとき HB(Term1)⊇HB(Term2)。
               A1, A2 ともに構造で、同じ述語とアリティであれば、再帰的に subsume を呼べば比較できる。
           c) A1 が変数、A2 が具体化された値のとき HB(Term1)⊇HB(Term2) である。
           d) A1 が変数、A2 も変数のとき、HB(Term1)⊇HB(Term2) である。
         という関係が成り立つと考えた。

      4) それ以外のとき
           HB(Term1)⊇HB(Term2) ではなくなる。

    この考えに沿って、上記プログラムを書いた。

     
      始め、上に示したような、項の構造、引数を比較することで HB(Term1)⊇HB(Term2) が
    成り立つかどうかを列挙して考える方法を取らず、最終的なプログラムが完成するまでに
    とても時間が掛かってしまった。今考えるとこの方法でなぜ一般性の比較ができるかよくわかるが、
    はじめはもっと回りくどい方法をして比較をしようとしており、なかなかこの考えにつながらなかった。
    また、比較の途中でマッチングを行うが、このマッチングを行うという発想も始め無かったため、
    気がつくのが遅く、プログラムを作るのに非常に時間が掛かった。こうしたことから、
    つくづくと Prolog でのプログラムの書き方に困難を覚えるが、そうはいっても
    徐々に複雑なプログラムも書けるようになってきているので、そういったプログラムを
    簡単に思いつくことができるようになれればいいなと思った。
*/


% -----------------------------------------------------------------------------
% (練習 7.8) 関係 powerset(Set, Subsets) の定義  (テキスト 185 ページ)
% 問: 与えられた集合(集合はリストで表わされるとする)のすべての部分集合の集合を
%     計算するために，関係 powerset(Set,Subsets)をbagofを用いて定義せよ
%
% [述語の説明]
%   - conc(L1,L2,L3):
%       リスト L1 と L2 を結合すると L3 になる関係
%   - powerset(Set, Subsets):
%       集合 Subsets が集合 Set のすべての部分集合である関係
%   - makeSubset(Set, Subset):
%       集合 Subset が集合 Set の部分集合である関係
%
% /* 以下に回答を示す */

% 必要な定義 conc
conc([],L,L).
conc([X|L1],L2,[X|L3]) :- conc(L1,L2,L3).

powerset(Set, Subsets) :-
    bagof(Subset, makeSubset(Set, Subset), Subsets).

makeSubset(_,[]).
makeSubset(Set, Subset) :-
    conc(_,L,Set),
    conc(Subset,_,L),
    Subset = [_|_].



/*
  (実行例)

[debug]  ?- powerset([1,2,3],Subsets).
Subsets = [[], [1], [1, 2], [1, 2, 3], [2], [2, 3], [3]].

[trace]  ?- powerset([1,2,3],Subsets).
   Call: (6) powerset([1, 2, 3], _G2876) ? 
^  Call: (7) bagof(_G2951, makeSubset([1, 2, 3], _G2951), _G2876) ? 
   Call: (13) makeSubset([1, 2, 3], _G2951) ? 
   Exit: (13) makeSubset([1, 2, 3], []) ? 
   Redo: (13) makeSubset([1, 2, 3], _G2951) ? 
   Call: (14) conc(_G2983, _G2984, [1, 2, 3]) ? 
   Exit: (14) conc([], [1, 2, 3], [1, 2, 3]) ? 
   Call: (14) conc(_G2951, _G2984, [1, 2, 3]) ? 
   Exit: (14) conc([], [1, 2, 3], [1, 2, 3]) ? 
   Call: (14) []=[_G2976|_G2977] ? 
   Fail: (14) []=[_G2976|_G2977] ? 
   Redo: (14) conc(_G2951, _G2984, [1, 2, 3]) ? 
   Call: (15) conc(_G2977, _G2987, [2, 3]) ? 
   Exit: (15) conc([], [2, 3], [2, 3]) ? 
   Exit: (14) conc([1], [2, 3], [1, 2, 3]) ? 
   Call: (14) [1]=[_G2979|_G2980] ? 
   Exit: (14) [1]=[1] ? 
   Exit: (13) makeSubset([1, 2, 3], [1]) ? 
   Redo: (15) conc(_G2977, _G2987, [2, 3]) ? 
   Call: (16) conc(_G2980, _G2990, [3]) ? 
   Exit: (16) conc([], [3], [3]) ? 
   Exit: (15) conc([2], [3], [2, 3]) ? 
   Exit: (14) conc([1, 2], [3], [1, 2, 3]) ? 
   Call: (14) [1, 2]=[_G2982|_G2983] ? 
   Exit: (14) [1, 2]=[1, 2] ? 
   Exit: (13) makeSubset([1, 2, 3], [1, 2]) ? 
   Redo: (16) conc(_G2980, _G2990, [3]) ? 
   Call: (17) conc(_G2983, _G2993, []) ? 
   Exit: (17) conc([], [], []) ? 
   Exit: (16) conc([3], [], [3]) ? 
   Exit: (15) conc([2, 3], [], [2, 3]) ? 
   Exit: (14) conc([1, 2, 3], [], [1, 2, 3]) ? 
   Call: (14) [1, 2, 3]=[_G2985|_G2986] ? 
   Exit: (14) [1, 2, 3]=[1, 2, 3] ? 
   Exit: (13) makeSubset([1, 2, 3], [1, 2, 3]) ? 
   Redo: (17) conc(_G2983, _G2993, []) ? 
   Fail: (17) conc(_G2983, _G2993, []) ? 
   Fail: (16) conc(_G2980, _G2990, [3]) ? 
   Fail: (15) conc(_G2977, _G2987, [2, 3]) ? 
   Fail: (14) conc(_G2951, _G2984, [1, 2, 3]) ? 
   Redo: (14) conc(_G2983, _G2984, [1, 2, 3]) ? 
   Call: (15) conc(_G2977, _G2987, [2, 3]) ? 
   Exit: (15) conc([], [2, 3], [2, 3]) ? 
   Exit: (14) conc([1], [2, 3], [1, 2, 3]) ? 
   Call: (14) conc(_G2951, _G2987, [2, 3]) ? 
   Exit: (14) conc([], [2, 3], [2, 3]) ? 
   Call: (14) []=[_G2979|_G2980] ? 
   Fail: (14) []=[_G2979|_G2980] ? 
   Redo: (14) conc(_G2951, _G2987, [2, 3]) ? 
   Call: (15) conc(_G2980, _G2990, [3]) ? 
   Exit: (15) conc([], [3], [3]) ? 
   Exit: (14) conc([2], [3], [2, 3]) ? 
   Call: (14) [2]=[_G2982|_G2983] ? 
   Exit: (14) [2]=[2] ? 
   Exit: (13) makeSubset([1, 2, 3], [2]) ? 
   Redo: (15) conc(_G2980, _G2990, [3]) ? 
   Call: (16) conc(_G2983, _G2993, []) ? 
   Exit: (16) conc([], [], []) ? 
   Exit: (15) conc([3], [], [3]) ? 
   Exit: (14) conc([2, 3], [], [2, 3]) ? 
   Call: (14) [2, 3]=[_G2985|_G2986] ? 
   Exit: (14) [2, 3]=[2, 3] ? 
   Exit: (13) makeSubset([1, 2, 3], [2, 3]) ? 
   Redo: (16) conc(_G2983, _G2993, []) ? 
   Fail: (16) conc(_G2983, _G2993, []) ? 
   Fail: (15) conc(_G2980, _G2990, [3]) ? 
   Fail: (14) conc(_G2951, _G2987, [2, 3]) ? 
   Redo: (15) conc(_G2977, _G2987, [2, 3]) ? 
   Call: (16) conc(_G2980, _G2990, [3]) ? 
   Exit: (16) conc([], [3], [3]) ? 
   Exit: (15) conc([2], [3], [2, 3]) ? 
   Exit: (14) conc([1, 2], [3], [1, 2, 3]) ? 
   Call: (14) conc(_G2951, _G2990, [3]) ? 
   Exit: (14) conc([], [3], [3]) ? 
   Call: (14) []=[_G2982|_G2983] ? 
   Fail: (14) []=[_G2982|_G2983] ? 
   Redo: (14) conc(_G2951, _G2990, [3]) ? 
   Call: (15) conc(_G2983, _G2993, []) ? 
   Exit: (15) conc([], [], []) ? 
   Exit: (14) conc([3], [], [3]) ? 
   Call: (14) [3]=[_G2985|_G2986] ? 
   Exit: (14) [3]=[3] ? 
   Exit: (13) makeSubset([1, 2, 3], [3]) ? 
   Redo: (15) conc(_G2983, _G2993, []) ? 
   Fail: (15) conc(_G2983, _G2993, []) ? 
   Fail: (14) conc(_G2951, _G2990, [3]) ? 
   Redo: (16) conc(_G2980, _G2990, [3]) ? 
   Call: (17) conc(_G2983, _G2993, []) ? 
   Exit: (17) conc([], [], []) ? 
   Exit: (16) conc([3], [], [3]) ? 
   Exit: (15) conc([2, 3], [], [2, 3]) ? 
   Exit: (14) conc([1, 2, 3], [], [1, 2, 3]) ? 
   Call: (14) conc(_G2951, _G2993, []) ? 
   Exit: (14) conc([], [], []) ? 
   Call: (14) []=[_G2985|_G2986] ? 
   Fail: (14) []=[_G2985|_G2986] ? 
   Redo: (14) conc(_G2951, _G2993, []) ? 
   Fail: (14) conc(_G2951, _G2993, []) ? 
   Redo: (17) conc(_G2983, _G2993, []) ? 
   Fail: (17) conc(_G2983, _G2993, []) ? 
   Fail: (16) conc(_G2980, _G2990, [3]) ? 
   Fail: (15) conc(_G2977, _G2987, [2, 3]) ? 
   Fail: (14) conc(_G2983, _G2984, [1, 2, 3]) ? 
   Fail: (13) makeSubset([1, 2, 3], _G2951) ? 
^  Exit: (7) bagof(_G2951, user:makeSubset([1, 2, 3], _G2951), [[], [1], [1, 2], [1, 2, 3], [2], [2, 3], [3]]) ? 
   Exit: (6) powerset([1, 2, 3], [[], [1], [1, 2], [1, 2, 3], [2], [2, 3], [3]]) ? 
Subsets = [[], [1], [1, 2], [1, 2, 3], [2], [2, 3], [3]].



  [説明, 考察, 評価]
      述語 powerset はその名の通りべき集合を求める述語だが、組み込み述語の bagof を使うことで
    数行のプログラムで実装することができた。組み込み述語 bagof がどういう動作をするのかを理解
    するまでに少し時間が掛かったが、友人にも教えてもらい、その動作がよくわかった。

      今回の練習問題では、メタプログラミングを行う上で便利な組み込み述語を学んだが、
    プログラムがプログラム自身を書き換えることをこんなにも容易に行える言語は、自分は始めて
    触ったので、とても興味深く感じた。以前、英語の授業で「自分でプログラムを変えることができる
    プログラムが存在する」といったトピックが取り上げられた文章を読む機会があり、当時はあまり
    ピンとこなかったが、Prolog でいとも簡単にその操作ができることを実感し、メタプログラミング
    に興味が持てた。

      気づけば教科書も第 7 章まで進み、それなりに Prolog でプログラムを書く力もついてきたとは
    思っているが、難しい問題を解くようなプログラムをすぐに思いつくことは自分には難しく、まして
    それを簡素にプログラムにするのはもっと困難に感じる。論理プログラミングを使いこなせるように
    なるには、センスが必要なのかなと感じるが、少しでも Prolog を使いこなせるようになるべく、
    積極的に Prolog を使ってみたいと思った。

*/
