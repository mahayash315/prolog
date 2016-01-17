% rep05: 第05回 演習課題レポート
% 2014年05月15日      by 24115113 名前: 林 政行
%
% 教科書の練習 (3.12), (3.21), (3.9)-別解 を解いてレポートとして提出する。
%
% [述語の説明]
%   - conc(L1,L2,L): リスト L は L1 と L2 を結合したリストである。
%
% /* 共通で使用するプログラム */

conc([],L,L).
conc([X|L1],L2,[X|L3]) :-
    conc(L1,L2,L3).

%
% -----------------------------------------------------------------------------
% (練習 3.12) オペレータの定義 (テキスト 85 ページ)
% 問: 関係
%        :- op(300,xfx,plays).
%        :- op(200,xfy,and).
%    というオペレータ定義を仮定すると，次の2つの項は構文的に正しいオブジェクトである．
%        Term1 = jimmy plays football and squash
%        Term2 = susan plays tennis and basketball and volleyball
%    これらの項はPrologによりいかに解釈されるか．その主関数子と構造を示せ．
%
% /* ここから必要なプログラムを書く */

:- op(300,xfx,plays).
:- op(200,xfy,and).

/*
  (実行例)
   [trace]  ?- Term3 = plays(jeremy, tennis).
   Term3 = jeremy plays tennis.

   [trace]  ?- Term4 = plays(richard, and(soccer, tennis)).
   Term4 = richard plays soccer and tennis.

   [trace]  ?- Term5 = plays(james, and(and(chess,othello),21)).
   Term5 = james plays (chess and othello)and 21.

   [trace]  ?- Term5 = plays(james, and(chess, and(othello,21))).
   Term5 = james plays chess and othello and 21.

   [trace]  ?- T1 = plays(susan, and(soccer, plays(jimmy, tennis))).
   T1 = susan plays soccer and (jimmy plays tennis).

   [trace]  ?- T1 = plays(susan, and(soccer, plays(jeremy, and(tennis, squash)))).
   T1 = susan plays soccer and (jeremy plays tennis and squash).



  [説明, 考察, 評価]
      :- op(300,xfx,plays)
    により、順位 300 で構文が xfx のオペレータ plays が定義され、
      :- op(200,xfy,and)
    により、順位 200 で構文が xfy のオペレータ and が定義される。
    
    　教科書の記載より、構文に現れる x, y に関して、
        - x : オペレータ順位よりも厳密に低い引数
        - y : オペレータ順位より低いかまたは等しい引数
    となっている。ただし、構造を持たないオブジェクトは順位 0 となる。
    また、式の中で最高の順位をもったオペレータがその式の第1関数子となり、
    最低順位のオペレータが最強の結合力を持つ。

      Term1 の第1関数子は plays, 解釈は

              plays
            ／      ＼          ┐ 
        jimmy        and        |
       (順位 0)     ／   ＼      |- (順位 200)
             football   squash  |
                  　　          ┘

    となる。このとき、 jimmy, football, squash の順位は 0 であり、
    and の順位は 200, 従って、 plays の第2引数の順位は 200 となり、
    オペレータ plays の順位が 300, 構文が xfx なので、この解釈で
    問題ない。また、 plays の順位がこの式の中の最大値 300 なので、
    plays が第1関数子となる。

      Term2 の第1関数子は plays, 解釈は

                 plays
              ／        ＼
            ／            ＼
        susan              and(*1)
                        ／      ＼
                      ／          ＼
                   tennis          and(*2)
                                 ／    ＼
                               ／        ＼
                        bascketball   volleyball

       (※ 説明のためオペレータ and に添字をつけている)
 
    となる。このとき、susan, tennis, bascketball, volleyball の順位は 0 であり、
    and(*2) の順位は 200, and(*1) の順位は 200 となり、オペレータ and の構文は xfy
    なので、
      and(and(tennis, bascketball), volleyball)
    という解釈は xfy に沿わないため除外され、上記のように
      and(tennis, and(bascketball, volleyball))
    という解釈がされる。
    また、 plays の順位がこの式の中の最大値 300 なので、 plays が第1関数子となる。

    　オペレータを自分で定義することで、今回のように英文の解釈のようなことが
    可能になり、述語論理として扱うことができることがわかり、便利だと感じた。
    　加えて、and の中に新たな文を入れたときの解釈も行ったところ、
      susan plays soccer and (jimmy plays tennis)
    となり、and の構文 xfy に沿わない plays(jimmy, tennis) が別の1つの項として
    取り出されていることが確認できた。

    　述語を用いるより、中置オペレータを使った方が、人にとって理解しやすい式は多いが、
    それらの変換がたった 1 行のオペレータの定義で可能になり、Prolog はすごいと思った。
*/


% -----------------------------------------------------------------------------
% (練習 3.21) 関係 bet の定義  (テキスト 92 ページ)
% 問: 関係
%    手続き
%        bet(N1,N2,X)
%    が，与えられた２つの整数N1,N2に対して，制約N1≦X≦N2を満たすすべての整数Xをバックトラックにより
%    生成するよう定義せよ．
%
% [述語の説明]
%    - bet(N1,N2,X): ２つの整数N1,N2に対して，X は制約 N1≦X≦N2 を満たす整数である。
%
% /* 以下に回答を示す */

bet(N1,N2,X) :-
    N1 =< N2,
    X is N1.
bet(N1,N2,X) :-
    N1 =< N2,
    N is N1+1,
    bet(N, N2, X).

/*
  (実行例)
[trace]  ?- bet(1,3,X).
   Call: (6) bet(1, 3, _G2908) ? creep
   Call: (7) 1=<3 ? creep
   Exit: (7) 1=<3 ? creep
   Call: (7) _G2908 is 1 ? creep
   Exit: (7) 1 is 1 ? creep
   Exit: (6) bet(1, 3, 1) ? creep
X = 1 ;
   Redo: (6) bet(1, 3, _G2908) ? creep
   Call: (7) 1=<3 ? creep
   Exit: (7) 1=<3 ? creep
   Call: (7) _G2984 is 1+1 ? creep
   Exit: (7) 2 is 1+1 ? creep
   Call: (7) bet(2, 3, _G2908) ? creep
   Call: (8) 2=<3 ? creep
   Exit: (8) 2=<3 ? creep
   Call: (8) _G2908 is 2 ? creep
   Exit: (8) 2 is 2 ? creep
   Exit: (7) bet(2, 3, 2) ? creep
   Exit: (6) bet(1, 3, 2) ? creep
X = 2 ;
   Redo: (7) bet(2, 3, _G2908) ? creep
   Call: (8) 2=<3 ? creep
   Exit: (8) 2=<3 ? creep
   Call: (8) _G2987 is 2+1 ? creep
   Exit: (8) 3 is 2+1 ? creep
   Call: (8) bet(3, 3, _G2908) ? creep
   Call: (9) 3=<3 ? creep
   Exit: (9) 3=<3 ? creep
   Call: (9) _G2908 is 3 ? creep
   Exit: (9) 3 is 3 ? creep
   Exit: (8) bet(3, 3, 3) ? creep
   Exit: (7) bet(2, 3, 3) ? creep
   Exit: (6) bet(1, 3, 3) ? creep
X = 3 ;
   Redo: (8) bet(3, 3, _G2908) ? creep
   Call: (9) 3=<3 ? creep
   Exit: (9) 3=<3 ? creep
   Call: (9) _G2990 is 3+1 ? creep
   Exit: (9) 4 is 3+1 ? creep
   Call: (9) bet(4, 3, _G2908) ? creep
   Call: (10) 4=<3 ? creep
   Fail: (10) 4=<3 ? creep
   Redo: (9) bet(4, 3, _G2908) ? creep
   Call: (10) 4=<3 ? creep
   Fail: (10) 4=<3 ? creep
   Fail: (9) bet(4, 3, _G2908) ? creep
   Fail: (8) bet(3, 3, _G2908) ? creep
   Fail: (7) bet(2, 3, _G2908) ? creep
   Fail: (6) bet(1, 3, _G2908) ? creep
false.



  [説明, 考察, 評価]
    　バックトラックを用いて N1≦X≦N2 を満たす整数 X を生成するために、
    正しい方法かはわからないが、今回は 2 つの関係 bet(N1,N2,X) を定義した。
    一つは X に値を代入するための関係であり、もう一つは次の X の値を求める
    ために、再帰的に手続きを呼び出す関係である。どちらの関係にも
      N1 =< N2
    という条件をつけ、X is N1+1, bet(N1+1, N2, X) を再帰的に呼び出すことで、
    N1≦X≦N2 を満たす整数 X を再帰的にバックトラックを用いて生成している。

      今回の問題を通して、Prolog において算術計算を扱えるようになった。
    is という、今まで触ってきたプログラミング言語では見たことがないオペレータの
    存在にはじめはとまどったが、徐々に慣れることができ、算術式よりも論理式を優先して
    いる言語がおもしろいと思った。
*/


% -----------------------------------------------------------------------------
% (練習 3.9)-別解 dividelist2(F, G, H) の定義
% 問: 関係
%    conc(A, B, C)とlength(D, E)(p.90)を用いてdividelist(F, G, H)の別解dividelist2(F, G, H)を定義せよ．
%    lengthは組込み述語が存在するので述語名をlenとせよ．
%
% [述語の説明]
%   - len(List, Len):     リスト List の長さが Len となる。
%   - dividelist2(F,G,H): リスト F を、リストの長さが大体同じになるように、リスト G, H に分割する
%
% /* 以下に回答を示す */

% len の定義
len([], 0).
len([_|Tail], N) :-
      len(Tail, N1),
      N is 1 + N1.

% dividelist2 の定義
dividelist2(F, G, H) :-
    conc(G, H, F),
    len(G, LenG),
    len(H, LenH),
    D is LenG - LenH,
    -1 =< D,
    D =< 1.

/*
  (実行例)
[trace]  ?- dividelist2([a,b,c],X,Y).
   Call: (6) dividelist2([a, b, c], _G13602, _G13603) ? creep
   Call: (7) conc(_G13602, _G13603, [a, b, c]) ? creep
   Exit: (7) conc([], [a, b, c], [a, b, c]) ? creep
   Call: (7) len([], _G13701) ? creep
   Exit: (7) len([], 0) ? creep
   Call: (7) len([a, b, c], _G13701) ? creep
   Call: (8) len([b, c], _G13701) ? creep
   Call: (9) len([c], _G13701) ? creep
   Call: (10) len([], _G13701) ? creep
   Exit: (10) len([], 0) ? creep
   Call: (10) _G13703 is 1+0 ? creep
   Exit: (10) 1 is 1+0 ? creep
   Exit: (9) len([c], 1) ? creep
   Call: (9) _G13706 is 1+1 ? creep
   Exit: (9) 2 is 1+1 ? creep
   Exit: (8) len([b, c], 2) ? creep
   Call: (8) _G13709 is 1+2 ? creep
   Exit: (8) 3 is 1+2 ? creep
   Exit: (7) len([a, b, c], 3) ? creep
   Call: (7) _G13712 is 0-3 ? creep
   Exit: (7) -3 is 0-3 ? creep
   Call: (7) -1=< -3 ? creep
   Fail: (7) -1=< -3 ? creep
   Redo: (7) conc(_G13602, _G13603, [a, b, c]) ? creep
   Call: (8) conc(_G13694, _G13603, [b, c]) ? creep
   Exit: (8) conc([], [b, c], [b, c]) ? creep
   Exit: (7) conc([a], [b, c], [a, b, c]) ? creep
   Call: (7) len([a], _G13704) ? creep
   Call: (8) len([], _G13704) ? creep
   Exit: (8) len([], 0) ? creep
   Call: (8) _G13706 is 1+0 ? creep
   Exit: (8) 1 is 1+0 ? creep
   Exit: (7) len([a], 1) ? creep
   Call: (7) len([b, c], _G13707) ? creep
   Call: (8) len([c], _G13707) ? creep
   Call: (9) len([], _G13707) ? creep
   Exit: (9) len([], 0) ? creep
   Call: (9) _G13709 is 1+0 ? creep
   Exit: (9) 1 is 1+0 ? creep
   Exit: (8) len([c], 1) ? creep
   Call: (8) _G13712 is 1+1 ? creep
   Exit: (8) 2 is 1+1 ? creep
   Exit: (7) len([b, c], 2) ? creep
   Call: (7) _G13715 is 1-2 ? creep
   Exit: (7) -1 is 1-2 ? creep
   Call: (7) -1=< -1 ? creep
   Exit: (7) -1=< -1 ? creep
   Call: (7) -1=<1 ? creep
   Exit: (7) -1=<1 ? creep
   Exit: (6) dividelist2([a, b, c], [a], [b, c]) ? creep
X = [a],
Y = [b, c] ;
   Redo: (8) conc(_G13694, _G13603, [b, c]) ? creep
   Call: (9) conc(_G13697, _G13603, [c]) ? creep
   Exit: (9) conc([], [c], [c]) ? creep
   Exit: (8) conc([b], [c], [b, c]) ? creep
   Exit: (7) conc([a, b], [c], [a, b, c]) ? creep
   Call: (7) len([a, b], _G13707) ? creep
   Call: (8) len([b], _G13707) ? creep
   Call: (9) len([], _G13707) ? creep
   Exit: (9) len([], 0) ? creep
   Call: (9) _G13709 is 1+0 ? creep
   Exit: (9) 1 is 1+0 ? creep
   Exit: (8) len([b], 1) ? creep
   Call: (8) _G13712 is 1+1 ? creep
   Exit: (8) 2 is 1+1 ? creep
   Exit: (7) len([a, b], 2) ? creep
   Call: (7) len([c], _G13713) ? creep
   Call: (8) len([], _G13713) ? creep
   Exit: (8) len([], 0) ? creep
   Call: (8) _G13715 is 1+0 ? creep
   Exit: (8) 1 is 1+0 ? creep
   Exit: (7) len([c], 1) ? creep
   Call: (7) _G13718 is 2-1 ? creep
   Exit: (7) 1 is 2-1 ? creep
   Call: (7) -1=<1 ? creep
   Exit: (7) -1=<1 ? creep
   Call: (7) 1=<1 ? creep
   Exit: (7) 1=<1 ? creep
   Exit: (6) dividelist2([a, b, c], [a, b], [c]) ? creep
X = [a, b],
Y = [c] ;
   Redo: (9) conc(_G13697, _G13603, [c]) ? creep
   Call: (10) conc(_G13700, _G13603, []) ? creep
   Exit: (10) conc([], [], []) ? creep
   Exit: (9) conc([c], [], [c]) ? creep
   Exit: (8) conc([b, c], [], [b, c]) ? creep
   Exit: (7) conc([a, b, c], [], [a, b, c]) ? creep
   Call: (7) len([a, b, c], _G13710) ? creep
   Call: (8) len([b, c], _G13710) ? creep
   Call: (9) len([c], _G13710) ? creep
   Call: (10) len([], _G13710) ? creep
   Exit: (10) len([], 0) ? creep
   Call: (10) _G13712 is 1+0 ? creep
   Exit: (10) 1 is 1+0 ? creep
   Exit: (9) len([c], 1) ? creep
   Call: (9) _G13715 is 1+1 ? creep
   Exit: (9) 2 is 1+1 ? creep
   Exit: (8) len([b, c], 2) ? creep
   Call: (8) _G13718 is 1+2 ? creep
   Exit: (8) 3 is 1+2 ? creep
   Exit: (7) len([a, b, c], 3) ? creep
   Call: (7) len([], _G13719) ? creep
   Exit: (7) len([], 0) ? creep
   Call: (7) _G13721 is 3-0 ? creep
   Exit: (7) 3 is 3-0 ? creep
   Call: (7) -1=<3 ? creep
   Exit: (7) -1=<3 ? creep
   Call: (7) 3=<1 ? creep
   Fail: (7) 3=<1 ? creep
   Redo: (10) conc(_G13700, _G13603, []) ? creep
   Fail: (10) conc(_G13700, _G13603, []) ? creep
   Fail: (9) conc(_G13697, _G13603, [c]) ? creep
   Fail: (8) conc(_G13694, _G13603, [b, c]) ? creep
   Fail: (7) conc(_G13602, _G13603, [a, b, c]) ? creep
   Fail: (6) dividelist2([a, b, c], _G13602, _G13603) ? creep
false.

  [説明, 考察, 評価]
    　dividelist2(F,G,H) は入力されたリスト F を、ほぼ同じ長さのリスト G, H
    に分割する動作をする。まず、入力されたリスト F を conc(G,H,F) により
    分解し、有り得るすべてのリスト G, H を取得する。次に、リスト G, H の長さ
    LenH, LenG に関して、|LenH - LenG| ≦ 1 という条件を付ける。このとき、
    この条件に合わない G, H の分け方になった場合は、バックトラックにより別の
    G, H の分割方法を探す動作をする。

    　今回は conc と len を使うことで、「リスト G,H の長さの差が 1 以下」という
    条件を、そのままわかりやすく表現することができた。第 04 回の課題で作った、
    F の頭の要素を 2 つずつ取り出し、各々 G, H に追加する、という方法と比べると、
    trace を見る限りは呼ばれる手続きが多くなってしまっているが、読んでわかりやすい
    今回のような定義の方法もある、ということがわかり、関係の定義方法は様々だなと思った。
*/

