% rep02: 第02回 演習課題レポート
% 2014年04月24日      by 24115113 名前: 林 政行
%
% 教科書の練習 (2.1), (2.3), (2.5), (2.8)を解いてレポートとして提出する。
%
% -----------------------------------------------------------------------------
% (練習 2.1) Prolog オブジェクトに関する問題 (テキスト 34 ページ)
%
% 以下の Prolog オブジェクトが正しいかどうか、どんな種類のオブジェクトかを示す。

%
% (a) Diana
%    正しい。変数。
/*
   (実行例)

  ?- X = Diana.
  X = Diana.
*/

%
% (b) diana
%    正しい。アトム。
/*
   (実行例)

  ?- X = diana.
  X = diana.
*/

%
% (c) 'Diana'
%    正しい。アトム。
/*
   (実行例)

  ?- X = 'Diana'.
  X = 'Diana'.
*/

%
% (d) _diana
%    正しい。変数。
/*
   (実行例)

  ?- X = _diana.
  X = _diana.
*/

%
% (e) 'Dians goes south'
%    正しい。アトム。
/*
   (実行例)

  ?- X = 'Diana goes south'.
  X = 'Diana goes south'.
*/

%
% (f) goes(diana,south)
%    正しい。構造。
/*
   (実行例)

  ?- X = goes(diana,south).
  X = goes(diana, south).
*/

%
% (g) 45
%    正しい。数。
/*
   (実行例)

  ?- X = 45.
  X = 45.
*/

%
% (h) 5(X,Y)
%    正しい Prolog オブジェクトではない。
/*
   (実行例)

   ?- X = 5(X,Y).
   ERROR: Syntax error: Operator expected
   ERROR: X = 5
   ERROR: ** here **
   ERROR: (X,Y) . 
*/

%
% (i) +(north,west)
%    正しい。構造。
/*
   (実行例)

   ?- X = +(north,west).
   X = north+west.
*/

%
% (j) three(Black(Cats))
%    正しい Prolog オブジェクトではない。
/*
   (実行例)

   ?- X = three(Black(Cats)).
   ERROR: Syntax error: Operator expected
   ERROR: X = three(Black
   ERROR: ** here **
   ERROR: (Cats)) . 
*/

/*
  [説明, 考察, 評価]
  　Prolog における定数、変数、数、構造の書き方がよくわかった。
*/


% -----------------------------------------------------------------------------
% (練習 2.3) マッチングが成功するか否か。成功する場合は結果として得られる変数の具体化を示す。
%                                                            (テキスト 12 ページ)

%
% (a) point(A,B) = point(1,2)
%    成功する。変数の具体化 A=1, B=2 が得られる。
/* 
   (実行例)

   ?- point(A,B) = point(1,2).
   A = 1,
   B = 2.
*/

%
% (b) point(A,B,C) = point(X,Y,Z)
%    成功しない。アリティが異なるため、別の構造のマッチングになり失敗する。
/*
   (実行例)

   ?- point(A,B) = point(X,Y,Z).
   false.
*/

%
% (c) plus(2,2) = 4
%    成功しない。構造と数のマッチングで失敗する。
/*
   (実行例)
   ?- plus(2,2) = 4.
   false.
*/

%
% (d) +(2,D) = +(E,2)
%    成功する。変数の具体化 D=E, E=2 が得られる。
/*
   (実行例)
   ?- +(2,D) = +(E,2).
   D = E, E = 2.
*/

%
% (e) triangle(point(-1,0),P2,P3) = triangle(P1,point(1,0),point(0,Y))
%   成功する。変数の具体化 P2=point(1,0), P3=point(0,Y), P1=point(-1.0) が得られる。
/*
   (実行例)
   ?- triangle(point(-1,0),P2,P3) = triangle(P1,point(1,0),point(0,Y)).
   P2 = point(1, 0),
   P3 = point(0, Y),
   P1 = point(-1, 0).
*/

/*
  [説明, 考察, 評価]
  　実行例より、マッチングがどういった動作をするのかを大まかに理解できた。
*/


% -----------------------------------------------------------------------------
% (練習 2.5) regular(R) の定義 (テキスト 40 ページ)
%
% 矩形 R が水平と垂直な辺をもったものである場合に真となる関係
%   regular(R)
% を定義する。
%
% /* ここから回答 */

/* 必要な定義 */
vertical(P1,P2) :-
    P1 = point(X, _),
    P2 = point(X, _).
horizontal(P1,P2) :-
    P1 = point(_,Y),
    P2 = point(_,Y).

/* regular の定義 */
regular(R) :-
    R = rectangle(P1,P2,P3,P4),
    vertical(P1,P2),
    vertical(P3,P4),
    horizontal(P2,P3),
    horizontal(P4,P1).
regular(R) :-
    R = rectangle(P1,P2,P3,P4),
    horizontal(P1,P2),
    horizontal(P3,P4),
    vertical(P2,P3),
    vertical(P4,P1).


% /* ここまで回答 */
%

%
% 実行例として、次の二種類の矩形に関して regular の実行結果を求めた。
%
% (a) true になるべき矩形
% ┌┐ - rectangle(point(0,1), point(1,1), point(1,0), point(0,0))
% └┘ - rectangle(point(0,0), point(0,1), point(1,1), point(1,0))
%
% (b) false になるべき矩形
% ／＼ - rectangle(point(1,1), point(2,0), point(-1,-1), point(0,0))
% ＼／ - rectangle(point(0,0), point(1,1), point(2,0), point(-1,-1))
%
/*
   (実行例)

   ?- regular( rectangle(point(0,1), point(1,1), point(1,0), point(0,0)) ).
   true.
   
   ?- regular( rectangle(point(0,0), point(0,1), point(1,1), point(1,0)) ).
   true .
   
   ?- regular(rectangle(point(1,1), point(2,0), point(-1,-1), point(0,0))).
   false.
   
   ?- regular(rectangle(point(0,0), point(1,1), point(2,0), point(-1,-1))).
   false.
*/
/*
  [説明, 考察, 評価]
  　regular(R) が真になる条件は、与えられた 4 点 P1,P2,P3,P4 に関して、
  直線(P1,P2), (P3,P4)が水平であり,かつ直線(P2,P3), (P4,P1)が垂直であること、または
  直線(P1,P2), (P3,P4)が垂直であり,かつ直線(P2,P3), (P4,P1)が水平であることである
  と考え、回答のようなプログラムを書いた。
  　実行例を見ると、意図した結果が得られていることがわかる。ただ、プログラム中で
     R = rectangle(P1,P2,P3,P4),
  と、マッチングを行っているが、これが果たして正しい回答なのかよくわからなかった。
  理論的な部分があいまいになっていると思ったため、知識表現と推論で学んだ内容を復習しようと
  思った。
*/


% -----------------------------------------------------------------------------
% (練習 2.8) セミコロン表示法を使わない表現 (テキスト 43 ページ)
%
%  　次のプログラム
%     translate(Number,Word):-
%       Number=1,Word=one;
%       Number=2,Word=two;
%       Number=3,Word=three.
%  を、セミコロン表示法を使わない書き方で書き直す。
%
%  ※ 実行結果の比較のため、元の translate(Number,Word) を translate_orig(Number,Word)
%     として定義した。
%
% /* ここから回答 */

translate_orig(Number,Word):-
    Number=1,Word=one;
    Number=2,Word=two;
    Number=3,Word=three.

translate(Number,Word) :-
    Number=1,Word=one.
translate(Number,Word) :-
    Number=2,Word=two.
translate(Number,Word) :-
    Number=3,Word=three.

% /* ここまで回答 */
%
/*
   (実行例)

   ?- translate_orig(T,W).
   T = 1,
   W = one ;
   T = 2,
   W = two ;
   T = 3,
   W = three.
   
   ?- translate(T,W).
   T = 1,
   W = one ;
   T = 2,
   W = two ;
   T = 3,
   W = three.
   
   ?- translate_orig(1,W).
   W = one ;
   false.
   
   ?- translate(1,W).
   W = one ;
   false.
*/
/*
  [説明, 考察, 評価]
  　先生の説明、教科書の説明があったので、セミコロン表示法をセミコロンを使わない等価な書き方に
  直すことは特に難しくはなかった。
  　セミコロンを使うと、見やすくまとめられる場合もあるので、今後の演習において活用しようと思った。
*/
