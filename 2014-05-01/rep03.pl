% rep03: 第03回 演習課題レポート
% 2014年05月01日      by 24115113 名前: 林 政行
%
% 教科書の練習 (3.1), (3.2), (3.4), (3.6) を解いてレポートとして提出する。
%
% -----------------------------------------------------------------------------
% (練習 3.1) リストに関する問題 (テキスト 72 ページ)
%
% /* ここから必要な定義 conc */

conc([],L,L).
conc([X|L1],L2,[X|L3]) :- conc(L1,L2,L3).

% /* ここまで必要な定義 conc */
%
% (a) リスト L からその最後の 3 つの要素を消して別のリスト L1 を作る目標を conc を使って
%     書け.
%
%     次のようにすればよい
%       conc(L1, [_,_,_], L).
%
/*
   (実行例)

   ?- L=[a,b,c,d,e,f], conc(L1, [_,_,_], L).
   L = [a, b, c, d, e, f],
   L1 = [a, b, c] ;
   false.

   ?- L=[1,2,3,4], conc(L1, [_,_,_], L).
   L = [1, 2, 3, 4],
   L1 = [1] ;
   false.

   ?- L=[1,2], conc(L1, [_,_,_], L).
   false.
*/

/*
  [説明, 考察, 評価]
  　　教科書に載っているヒントを参考に、
      L1 と [a,b,c] の連接 = [L1,a,b,c] = L
    なので、
      conc(L1, [_,_,_], L)
    という形で書くと、目的のリスト L1 を得ることができる。
    　実行結果から、求めたいリスト L1 が得られていることがわかった。
*/

%
% (b) リスト L からその最初の 3 つの要素と最後の 3 つの要素を消したリスト L2 を作る
%     目標の系列を書け.
%
%     次のようにすればよい
%       conc([_,_,_|L2], [_,_,_], L).
%
/*
   (実行例)

   ?- L=[a,b,c,d,e,f,g], conc([_,_,_|L2], [_,_,_], L).
   L = [a, b, c, d, e, f, g],
   L2 = [d] ;
   false.

   ?- L=[a,b,c,d,e,f,g,h,i,j], conc([_,_,_|L2], [_,_,_], L).
   L = [a, b, c, d, e, f, g, h, i|...],
   L2 = [d, e, f, g] ;
   false.
*/

/*
  [説明, 考察, 評価]
  　　(a)を参考に、求めるリスト L2 は
      [a,b,c|L2] と [p,q,r] の連接 = [a,b,c,d,e,f, ... ,p,q,r] = L
                                           ^^^^^
    となるので、
      conc([_,_,_|L2], [_,_,_], L)
    という形で書くと、目的のリスト L2 を得ることができる。
    　実行結果より、求めるリスト L2 が正しく得られていることがわかった。
*/

% -----------------------------------------------------------------------------
% (練習 3.2) las(Item,List) の定義 (テキスト 73 ページ)
%
% 関係
%   las(Item,List)
% を, Item が List の最後の要素であるように定義せよ.
%

%
% (a) conc 関係を使うプログラム
%     ※ 述語の名前が重複しないよう las1(Item,List) と定義した。
%
% /* ここから回答 */

las1(Item,List) :- conc(_, [Item], List).

% /* ここまで回答 */
/*
   (実行例)
   ?- las1(4,[1,2,3]).
   false.

   ?- las1(4,[1,2,3,4]).
   true ;
   false.

   ?- las1(X,[1,2,3,4]).
   X = 4 ;
   false.
*/

/*
  [説明, 考察, 評価]
    　List は
      [a,b,c, ... ,p,q,Item] = List
    という中身になっているので、
      [a,b,c, ... ,p,q] と [Item] の連接 = List
    という関係が成り立つはず。従って、
      conc(_, [Item], List)
    とすれば、リスト List の最後の要素が Item であるかどうかがわかるはずと考えた。

    　実行結果より、求める結果が得られていることが確認できた。
*/

%
% (b) conc を使わないプログラム
%     ※ 述語の名前が重ならないよう las2 と定義した。
%
% /* ここから回答 */

las2(Item,[Item]).
las2(Item,[_|List]) :- las2(Item,List).

% /* ここまで回答 */
/*
   (実行例)

   ?- las2(4,[1,2,3]).
   false.

   ?- las2(4,[1,2,3,4]).
   true ;
   false.

   ?- las2(X,[1,2,3,4]).
   X = 4 ;
   false.
*/

/*
  [説明, 考察, 評価]
    　las2(Item,List) を再帰を用いて、
       las2(Item,[Item])
    を終了条件に、
       las2(Item,[_|List])
    を再帰呼び出しにすることで、求める結果が得られるような定義ができる。

      これは、具体的に示すとわかりやすく、
       las2(3, [1,2,3])
         --> las2(3, [2,3])
           --> las2(3, [3]) = true
    というように、引数 List を前から１つづつ取り出していき、最終的に要素数が
    １つになったときに引数 Item と比較するような形をとっている。

    　実行結果より、求める結果を正しく得られていることが確認できた。また、
    練習 (3.1), (3.2) を通して、リスト特有の表現
      [L1|Lx]
    の動作がよく理解できた。
*/

% -----------------------------------------------------------------------------
% (練習 3.4) rev(List,ReversedList) の定義  (テキスト 79 ページ)
%
% リストを反転させる関係
%   rev(List,ReversedList)
% を定義せよ, たとえば rev([a,b,c,d],[d,c,b,a]).
%
% /* ここから回答 */

rev([],[]).
rev([X|List], L) :-
    rev(List, ReversedList),
    conc(ReversedList, [X], L).

% /* ここまで回答 */
/*
   (実行例)

   ?- rev([a,b,c,d],[d,c,b,a]).
   true.

   ?- rev([a,b,c,d],X).
   X = [d, c, b, a].

   ?- rev([1,2,3,4,5,6,7],X).
   X = [7, 6, 5, 4, 3, 2, 1].
*/

/*
  [説明, 考察, 評価]
  　　再帰を用いる。まず、終了条件において、
      rev([], []).
    とすることで、第一引数 List が空のとき、 ReverseList も空にする。
    次に、再帰の中身において、
      rev([X|List], L) :- rev(List, ReversedList), conc(ReversedList, [X], L).
    とすることで、第一引数 List から先頭の要素を取り出し、それを
    ReversedList の最後に追加する、という再帰を定義している。

      従って、 rev(List,ReversedList) は、List から先頭の要素を一つずつ取り出し、
    空になった段階で ReversedList も空に初期化し、再帰から戻っていく際に ReversedList
    の末尾に、取り出した要素を追加していく、という動作をする。

    　実行結果より、正しく求める結果が求まっていることが確認できた。

    　練習 3.4 を通して、再帰を使った関係の定義、およびリスト特有の表現
      [L1|Lx]
    の使い方がよくわかった。
*/


% -----------------------------------------------------------------------------
% (練習 3.6) 関係 shift(L1,L2) の (テキスト 40 ページ)
%
% List2 が List1 を 1 要素分左へシフトしたものとなるよう,
% 関係 shift(List1,List2) を定義せよ.たとえば
%    ?-shift([1,2,3,4,5],L1),
%        shift(L1,L2).
%    は
%        L1=[2,3,4,5,1]
%        L2=[3,4,5,1,2]
%    を作る．
%
% /* ここから回答 */

shift([],[]).
shift(List1,List2) :-
    conc([X], L, List1),
    conc(L, [X], List2).

% /* ここまで回答 */
/*
   (実行例)

   ?- shift([1,2,3,4,5],L1), shift(L1,L2).
   L1 = [2, 3, 4, 5, 1],
   L2 = [3, 4, 5, 1, 2].

   ?- shift([1,2,3],[2,3,1]).
   true.
*/

/*
  [説明, 考察, 評価]
    　shift(List1, List2) を、List1 の先頭の要素を末尾に移動させたリストが List2 となるような
    関係と考えて、今回のような定義を行った。
      まず、
        conc([X], L, List1)
    とすることで、List1 から先頭の要素を X として取り出し、残ったリストを L とする。
      次に、
        conc(L, [X], List2)
    とすることで、リスト L の末尾に要素 X を追加したリスト List2 を作る。

    　実行結果より、正しく求めたい結果が得られていることを確認できた。

    　この練習を通して、たった 2 行で定義された関係 conc を使うだけで、リストにおける様々な操作を
    行える、ということがよくわかった。
*/