% rep06: 第06回 演習課題レポート
% 2014年05月22日      by 24115113 名前: 林 政行
%
% 教科書の練習 (4.2), (4.5) を解いてレポートとして提出する。
%
% -----------------------------------------------------------------------------
% (練習 4.2)  (テキスト 98 ページ)
% 問: 家族データベースで双子を見つけるために，twins(Child1,Child2)という関係を定義せよ．
%     また，従兄弟を見つけるための述語cousin(P1,P2)という関係を定義せよ．
%     血縁関係等を参考に各自でDBをつくり確認すること．
% 
% [述語の説明]
%   - family(Husband, Wife, Children):
%        夫 Husband, 妻 Wife, 子供たち Children からなる家族を表す。
%   - person(Name, Surname, Birthday, Occupation):
%        姓 Surname, 名 Name, 誕生日 Birthday, 職業 Occupation の人を表す。
%   - member(X, List):
%        X はリスト List の要素である。
%   - twins(Child1, Child2):
%        Child1 と Child2 が双子であることを表す。
%   - cousin(P1, P2)
%        P1 と P2 が従兄弟関係であることを示す。
%
% /* ここから必要なプログラムを書く */

% 関係 twins(Child1, Child2)
twins(Child1, Child2) :-
    family(_,_,Children),
    member(Child1, Children),
    member(Child2, Children),
    Child1 \== Child2,
    Child1 = person(_,_,Birthday,_),
    Child2 = person(_,_,Birthday,_).

% 関係 cousin(P1, P2)
cousin(P1, P2) :-
    family(H1,W1,C1), member(P1,C1),
    family(H2,W2,C2), member(P2,C2),
    P1 \== P2,
    H1 \== H2,
    W1 \== W2,
    family(_,_,C3),
    ( member(H1,C3), member(H2,C3);
      member(H1,C3), member(W2,C3);
      member(W1,C3), member(H2,C3);
      member(W2,C3), member(H2,C3) ).
    

% 以下、必要な関係の定義
child(X) :- family(_, _, Children), member(X,Children).

member(X, [X|_]).
member(X, [_|L]) :- member(X,L).

% 以下、家族データベース
% ※ 名前など異なる部分が多いが、現在の自分の家族構成を模したデータベースを作成した。
family(
	person(bannet, brick, date(10,january,1930), works(com2, 1000)),
	person(danielle, brick, date(10,may,1928), works(com2, 1000)),
	[ person(othniel, mcclintock, date(30,june,1958), works(com2, 1000)),
	  person(evie, ransome, date(25,may,1962), unemployed),
	  person(oswald, giles, date(15,october,1964), works(ntt,800)) ]).
family(
	person(othniel, mcclintock, date(30,june,1958), works(com2, 1000)),
	person(robin, mcclintock, date(10,may,1958), works(com2, 800)),
	[ person(may, mcclintock, date(30,june,2000), unemployed),
	  person(clarkson, mcclintock, date(25,may,2002), unemployed),
	  person(hammond, mcclintock, date(15,october,2004), unemployed) ]).
family(
	person(adolphus, ransome, date(1,march,1960), works(com1,500)),
	person(evie, ransome, date(25,may,1962), unemployed),
	[ person(selma, ransome, date(11,october,1986), unemployed),
	  person(oliver, ransome, date(28,december,1993), unemployed),
	  person(allan, ransome, date(28,december,1993), unemployed) ] ).
family(
	person(oswald, giles, date(15,october,1964), works(ntt,800)),
	person(robin, giles, date(10,may,1958), works(unknown, 800)),
	[ person(oscar, giles, date(30,june, 1992), unemployed),
	  person(kyle, giles, date(25,may,1995), unemployed) ] ).
/*
  (実行例)
  ※ 以下のトレースにおいて、すべてを出力すると長くなってしまうため、出力する必要が無いと判断した部分
  　 に関しては、skip した。

 ---------------- ここからが twins(自分, Y)  の実行例 ----------------

[trace]  ?- twins(person(allan,ransome,date(28,december,1993),unemployed), X).
   Call: (6) twins(person(allan, ransome, date(28, december, 1993), unemployed), _G307) ? 
   Call: (7) family(_G388, _G389, _G390) ? s
   Exit: (7) family(person(bannet, brick, date(10, january, 1930), works(com2, 1000)), person(danielle, brick, date(10, may, 1928), works(com2, 1000)), [person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)), person(evie, ransome, date(25, may, 1962), unemployed), person(oswald, giles, date(15, october, 1964), works(ntt, 800))]) ? 
   Call: (7) member(person(allan, ransome, date(28, december, 1993), unemployed), [person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)), person(evie, ransome, date(25, may, 1962), unemployed), person(oswald, giles, date(15, october, 1964), works(ntt, 800))]) ? s
   Fail: (7) member(person(allan, ransome, date(28, december, 1993), unemployed), [person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)), person(evie, ransome, date(25, may, 1962), unemployed), person(oswald, giles, date(15, october, 1964), works(ntt, 800))]) ? 
   Redo: (7) family(_G388, _G389, _G390) ? s
   Redo: (7) family(_G388, _G389, _G390) ? s
   Exit: (7) family(person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)), person(robin, mcclintock, date(10, may, 1958), works(com2, 800)), [person(may, mcclintock, date(30, june, 2000), unemployed), person(clarkson, mcclintock, date(25, may, 2002), unemployed), person(hammond, mcclintock, date(15, october, 2004), unemployed)]) ? 
   Call: (7) member(person(allan, ransome, date(28, december, 1993), unemployed), [person(may, mcclintock, date(30, june, 2000), unemployed), person(clarkson, mcclintock, date(25, may, 2002), unemployed), person(hammond, mcclintock, date(15, october, 2004), unemployed)]) ? s
   Fail: (7) member(person(allan, ransome, date(28, december, 1993), unemployed), [person(may, mcclintock, date(30, june, 2000), unemployed), person(clarkson, mcclintock, date(25, may, 2002), unemployed), person(hammond, mcclintock, date(15, october, 2004), unemployed)]) ? 
   Redo: (7) family(_G388, _G389, _G390) ? s
   Redo: (7) family(_G388, _G389, _G390) ? s
   Exit: (7) family(person(adolphus, ransome, date(1, march, 1960), works(com1, 500)), person(evie, ransome, date(25, may, 1962), unemployed), [person(selma, ransome, date(11, october, 1986), unemployed), person(oliver, ransome, date(28, december, 1993), unemployed), person(allan, ransome, date(28, december, 1993), unemployed)]) ? 
   Call: (7) member(person(allan, ransome, date(28, december, 1993), unemployed), [person(selma, ransome, date(11, october, 1986), unemployed), person(oliver, ransome, date(28, december, 1993), unemployed), person(allan, ransome, date(28, december, 1993), unemployed)]) ? s
   Exit: (7) member(person(allan, ransome, date(28, december, 1993), unemployed), [person(selma, ransome, date(11, october, 1986), unemployed), person(oliver, ransome, date(28, december, 1993), unemployed), person(allan, ransome, date(28, december, 1993), unemployed)]) ? 
   Call: (7) member(_G307, [person(selma, ransome, date(11, october, 1986), unemployed), person(oliver, ransome, date(28, december, 1993), unemployed), person(allan, ransome, date(28, december, 1993), unemployed)]) ? s
   Exit: (7) member(person(selma, ransome, date(11, october, 1986), unemployed), [person(selma, ransome, date(11, october, 1986), unemployed), person(oliver, ransome, date(28, december, 1993), unemployed), person(allan, ransome, date(28, december, 1993), unemployed)]) ? 
   Call: (7) person(allan, ransome, date(28, december, 1993), unemployed)\==person(selma, ransome, date(11, october, 1986), unemployed) ? s
   Exit: (7) person(allan, ransome, date(28, december, 1993), unemployed)\==person(selma, ransome, date(11, october, 1986), unemployed) ? 
   Call: (7) person(allan, ransome, date(28, december, 1993), unemployed)=person(_G438, _G439, _G440, _G441) ? s
   Exit: (7) person(allan, ransome, date(28, december, 1993), unemployed)=person(allan, ransome, date(28, december, 1993), unemployed) ? 
   Call: (7) person(selma, ransome, date(11, october, 1986), unemployed)=person(_G443, _G444, date(28, december, 1993), _G446) ? s
   Fail: (7) person(selma, ransome, date(11, october, 1986), unemployed)=person(_G443, _G444, date(28, december, 1993), _G446) ? 
   Redo: (7) member(_G307, [person(selma, ransome, date(11, october, 1986), unemployed), person(oliver, ransome, date(28, december, 1993), unemployed), person(allan, ransome, date(28, december, 1993), unemployed)]) ? s
   Redo: (7) member(_G307, [person(selma, ransome, date(11, october, 1986), unemployed), person(oliver, ransome, date(28, december, 1993), unemployed), person(allan, ransome, date(28, december, 1993), unemployed)]) ? s
   Exit: (7) member(person(oliver, ransome, date(28, december, 1993), unemployed), [person(selma, ransome, date(11, october, 1986), unemployed), person(oliver, ransome, date(28, december, 1993), unemployed), person(allan, ransome, date(28, december, 1993), unemployed)]) ? 
   Call: (7) person(allan, ransome, date(28, december, 1993), unemployed)\==person(oliver, ransome, date(28, december, 1993), unemployed) ? s
   Exit: (7) person(allan, ransome, date(28, december, 1993), unemployed)\==person(oliver, ransome, date(28, december, 1993), unemployed) ? 
   Call: (7) person(allan, ransome, date(28, december, 1993), unemployed)=person(_G438, _G439, _G440, _G441) ? s
   Exit: (7) person(allan, ransome, date(28, december, 1993), unemployed)=person(allan, ransome, date(28, december, 1993), unemployed) ? 
   Call: (7) person(oliver, ransome, date(28, december, 1993), unemployed)=person(_G443, _G444, date(28, december, 1993), _G446) ? s
   Exit: (7) person(oliver, ransome, date(28, december, 1993), unemployed)=person(oliver, ransome, date(28, december, 1993), unemployed) ? 
   Exit: (6) twins(person(allan, ransome, date(28, december, 1993), unemployed), person(oliver, ransome, date(28, december, 1993), unemployed)) ? 
X = person(oliver, ransome, date(28, december, 1993), unemployed) ;
   Redo: (7) member(_G307, [person(selma, ransome, date(11, october, 1986), unemployed), person(oliver, ransome, date(28, december, 1993), unemployed), person(allan, ransome, date(28, december, 1993), unemployed)]) ? s
   Exit: (7) member(person(allan, ransome, date(28, december, 1993), unemployed), [person(selma, ransome, date(11, october, 1986), unemployed), person(oliver, ransome, date(28, december, 1993), unemployed), person(allan, ransome, date(28, december, 1993), unemployed)]) ? s
   Call: (7) person(allan, ransome, date(28, december, 1993), unemployed)\==person(allan, ransome, date(28, december, 1993), unemployed) ? s
   Fail: (7) person(allan, ransome, date(28, december, 1993), unemployed)\==person(allan, ransome, date(28, december, 1993), unemployed) ? s
   Fail: (7) member(_G307, [person(selma, ransome, date(11, october, 1986), unemployed), person(oliver, ransome, date(28, december, 1993), unemployed), person(allan, ransome, date(28, december, 1993), unemployed)]) ? s
   Fail: (7) member(person(allan, ransome, date(28, december, 1993), unemployed), [person(selma, ransome, date(11, october, 1986), unemployed), person(oliver, ransome, date(28, december, 1993), unemployed), person(allan, ransome, date(28, december, 1993), unemployed)]) ? s
   Exit: (7) family(person(oswald, giles, date(15, october, 1964), works(ntt, 800)), person(robin, giles, date(10, may, 1958), works(unknown, 800)), [person(oscar, giles, date(30, june, 1992), unemployed), person(kyle, giles, date(25, may, 1995), unemployed)]) ? s
   Call: (7) member(person(allan, ransome, date(28, december, 1993), unemployed), [person(oscar, giles, date(30, june, 1992), unemployed), person(kyle, giles, date(25, may, 1995), unemployed)]) ? s
   Fail: (7) member(person(allan, ransome, date(28, december, 1993), unemployed), [person(oscar, giles, date(30, june, 1992), unemployed), person(kyle, giles, date(25, may, 1995), unemployed)]) ? s
   Fail: (6) twins(person(allan, ransome, date(28, december, 1993), unemployed), _G307) ? s
false.

 ---------------- ここまでが twins(自分, Y)  の実行例 ----------------



 ---------------- ここからが cousin(自分, X) の実行例 ----------------

[trace]  ?-  cousin(person(allan, ransome, date(28,december,1993), unemployed), X).
   Call: (6) cousin(person(allan, ransome, date(28, december, 1993), unemployed), _G1997) ? 
   Call: (7) family(_G2078, _G2079, _G2080) ? s
   Exit: (7) family(person(bannet, brick, date(10, january, 1930), works(com2, 1000)), person(danielle, brick, date(10, may, 1928), works(com2, 1000)), [person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)), person(evie, ransome, date(25, may, 1962), unemployed), person(oswald, giles, date(15, october, 1964), works(ntt, 800))]) ? 
   Call: (7) member(person(allan, ransome, date(28, december, 1993), unemployed), [person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)), person(evie, ransome, date(25, may, 1962), unemployed), person(oswald, giles, date(15, october, 1964), works(ntt, 800))]) ? s
   Fail: (7) member(person(allan, ransome, date(28, december, 1993), unemployed), [person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)), person(evie, ransome, date(25, may, 1962), unemployed), person(oswald, giles, date(15, october, 1964), works(ntt, 800))]) ? 
   Redo: (7) family(_G2078, _G2079, _G2080) ? s
   Redo: (7) family(_G2078, _G2079, _G2080) ? s
   Exit: (7) family(person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)), person(robin, mcclintock, date(10, may, 1958), works(com2, 800)), [person(may, mcclintock, date(30, june, 2000), unemployed), person(clarkson, mcclintock, date(25, may, 2002), unemployed), person(hammond, mcclintock, date(15, october, 2004), unemployed)]) ? 
   Call: (7) member(person(allan, ransome, date(28, december, 1993), unemployed), [person(may, mcclintock, date(30, june, 2000), unemployed), person(clarkson, mcclintock, date(25, may, 2002), unemployed), person(hammond, mcclintock, date(15, october, 2004), unemployed)]) ? s
   Fail: (7) member(person(allan, ransome, date(28, december, 1993), unemployed), [person(may, mcclintock, date(30, june, 2000), unemployed), person(clarkson, mcclintock, date(25, may, 2002), unemployed), person(hammond, mcclintock, date(15, october, 2004), unemployed)]) ? 
   Redo: (7) family(_G2078, _G2079, _G2080) ? s
   Redo: (7) family(_G2078, _G2079, _G2080) ? s
   Exit: (7) family(person(adolphus, ransome, date(1, march, 1960), works(com1, 500)), person(evie, ransome, date(25, may, 1962), unemployed), [person(selma, ransome, date(11, october, 1986), unemployed), person(oliver, ransome, date(28, december, 1993), unemployed), person(allan, ransome, date(28, december, 1993), unemployed)]) ? 
   Call: (7) member(person(allan, ransome, date(28, december, 1993), unemployed), [person(selma, ransome, date(11, october, 1986), unemployed), person(oliver, ransome, date(28, december, 1993), unemployed), person(allan, ransome, date(28, december, 1993), unemployed)]) ? s
   Exit: (7) member(person(allan, ransome, date(28, december, 1993), unemployed), [person(selma, ransome, date(11, october, 1986), unemployed), person(oliver, ransome, date(28, december, 1993), unemployed), person(allan, ransome, date(28, december, 1993), unemployed)]) ? 
   Call: (7) family(_G2135, _G2136, _G2137) ? s
   Exit: (7) family(person(bannet, brick, date(10, january, 1930), works(com2, 1000)), person(danielle, brick, date(10, may, 1928), works(com2, 1000)), [person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)), person(evie, ransome, date(25, may, 1962), unemployed), person(oswald, giles, date(15, october, 1964), works(ntt, 800))]) ? 
   Call: (7) member(_G1997, [person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)), person(evie, ransome, date(25, may, 1962), unemployed), person(oswald, giles, date(15, october, 1964), works(ntt, 800))]) ? s
   Exit: (7) member(person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)), [person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)), person(evie, ransome, date(25, may, 1962), unemployed), person(oswald, giles, date(15, october, 1964), works(ntt, 800))]) ? 
   Call: (7) person(allan, ransome, date(28, december, 1993), unemployed)\==person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)) ? s
   Exit: (7) person(allan, ransome, date(28, december, 1993), unemployed)\==person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)) ? 
   Call: (7) person(adolphus, ransome, date(1, march, 1960), works(com1, 500))\==person(bannet, brick, date(10, january, 1930), works(com2, 1000)) ? s
   Exit: (7) person(adolphus, ransome, date(1, march, 1960), works(com1, 500))\==person(bannet, brick, date(10, january, 1930), works(com2, 1000)) ? 
   Call: (7) person(evie, ransome, date(25, may, 1962), unemployed)\==person(danielle, brick, date(10, may, 1928), works(com2, 1000)) ? s
   Exit: (7) person(evie, ransome, date(25, may, 1962), unemployed)\==person(danielle, brick, date(10, may, 1928), works(com2, 1000)) ? 
   Call: (7) family(_G2201, _G2202, _G2203) ? s
   Exit: (7) family(person(bannet, brick, date(10, january, 1930), works(com2, 1000)), person(danielle, brick, date(10, may, 1928), works(com2, 1000)), [person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)), person(evie, ransome, date(25, may, 1962), unemployed), person(oswald, giles, date(15, october, 1964), works(ntt, 800))]) ? 
   Call: (7) member(person(adolphus, ransome, date(1, march, 1960), works(com1, 500)), [person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)), person(evie, ransome, date(25, may, 1962), unemployed), person(oswald, giles, date(15, october, 1964), works(ntt, 800))]) ? s
   Fail: (7) member(person(adolphus, ransome, date(1, march, 1960), works(com1, 500)), [person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000)), person(evie, ransome, date(25, may, 1962), unemployed), person(oswald, giles, date(15, october, 1964), works(ntt, 800))]) ? 
   Redo: (6) cousin(person(allan, ransome, date(28, december, 1993), unemployed), person(othniel, mcclintock, date(30, june, 1958), works(com2, 1000))) ? s
   Exit: (6) cousin(person(allan, ransome, date(28, december, 1993), unemployed), person(may, mcclintock, date(30, june, 2000), unemployed)) ? 
X = person(may, mcclintock, date(30, june, 2000), unemployed) ;
   Redo: (6) cousin(person(allan, ransome, date(28, december, 1993), unemployed), person(may, mcclintock, date(30, june, 2000), unemployed)) ? 
   Exit: (6) cousin(person(allan, ransome, date(28, december, 1993), unemployed), person(clarkson, mcclintock, date(25, may, 2002), unemployed)) ? 
X = person(clarkson, mcclintock, date(25, may, 2002), unemployed) ;
   Redo: (6) cousin(person(allan, ransome, date(28, december, 1993), unemployed), person(clarkson, mcclintock, date(25, may, 2002), unemployed)) ? 
   Exit: (6) cousin(person(allan, ransome, date(28, december, 1993), unemployed), person(hammond, mcclintock, date(15, october, 2004), unemployed)) ? 
X = person(hammond, mcclintock, date(15, october, 2004), unemployed) ;
   Redo: (6) cousin(person(allan, ransome, date(28, december, 1993), unemployed), person(hammond, mcclintock, date(15, october, 2004), unemployed)) ? 
   Exit: (6) cousin(person(allan, ransome, date(28, december, 1993), unemployed), person(oscar, giles, date(30, june, 1992), unemployed)) ? 
X = person(oscar, giles, date(30, june, 1992), unemployed) ;
   Redo: (6) cousin(person(allan, ransome, date(28, december, 1993), unemployed), person(oscar, giles, date(30, june, 1992), unemployed)) ? 
   Exit: (6) cousin(person(allan, ransome, date(28, december, 1993), unemployed), person(kyle, giles, date(25, may, 1995), unemployed)) ? 
X = person(kyle, giles, date(25, may, 1995), unemployed) ;
   Redo: (6) cousin(person(allan, ransome, date(28, december, 1993), unemployed), person(kyle, giles, date(25, may, 1995), unemployed)) ? 
   Fail: (6) cousin(person(allan, ransome, date(28, december, 1993), unemployed), _G1997) ? 
false.





  [説明, 考察, 評価]

[*] 関係 twins に関して

  　関係 twins(Child1,Child2) の定義に際して、双子は「同じ家族に属する、誕生日が同じ別人の 2 人」と
  定義すればよいと考えた。従ってまず「Child1 と Child2 が同じ家族に属する」判断について、

      family(_,_,Children),
      member(Child1, Children),
      member(Child2, Children),

  とした。次に、「誕生日が同じ別人」について、

      Child1 \== Child2,
      Child1 = person(_,_,Birthday,_),
      Child2 = person(_,_,Birthday,_).

  とした。

    はじめは、「別人」の判定をする

      Child1 \== Child2

  を、関係の定義の一番先頭、つまり一番最初に最汎単一化を行う部分に書いてしまったために、
  まだ値が代入されていない Child1 と Child2 の比較が行われ、「別人」の判断が正しく
  できなかった。Prolog において、導出は節の本体の :- に近い節からなされ、
  関係の定義において、処理される順番を考慮したプログラムを書くよう、気をつけないといけないと
  改めてわかった。


[*] 関係 cousin に関して

  　関係 cousin(P1, P2) について、自分と従兄弟の関係にある人は「自分の父または母の兄弟の子供」
  であるので、これはつまり「自分の父または母が子供である家族の、父または母以外の子供の家族の子供」
  とかみくだくことができる。なので、まず「自分(P1)の父または母が子供である家族」を

      family(H1,W1,C1), member(P1,C1),               % 自分 (P1) が子供として属する family を取り出す
      family(_,_,C3), (member(H1,C3); member(W1,C3)) % 父または母が子供として属する family を取り出す

  として取り出し、「父または母以外の子供の家族の子供(P2)」を

      (member(H2,C3); member(W2,C3)),                % 父または母以外の子供 H2, W2 を取り出す。
      family(H2,W2,C2), member(P2,C2).               % 取り出した H2 または W2 の家族の子供 P2 を取り出す

  として、従兄弟関係にある P2 との関係を定義した。このとき、

      P1 \== P2,
      H1 \== H2,
      W1 \== W2,

  と条件を付け、自分の兄弟が従兄弟関係にあると判断されないようにしている。

  　cousin の定義に際し、「父または母が・・・」という条件を Prolog で表現するときに、
  今まで ( sth(x), sth(y) ) という形で、部分的な「または」が定義できることを知らなかったが、
  今回友達に教えてもらい、上記のような書き方も可能ということを知ることができた。これによって
  プログラムの行数が大幅に減った。Prolog 特有の記法をもっと知りたいと思った。
*/


% -----------------------------------------------------------------------------
% (練習 4.5)   (テキスト 105 ページ)
% 問: acceptsの実行時のループは，たとえばそこまでの動作回数を数えることにより回避できる．
%     そうすると，シュミレータはある決められた長さの道だけを探すように求められる．acceptsをそのように修正せよ．
%     教科書P.104のaccepts/2のプログラムでは無限ループに陥るようなオートマトンを用意して動作確認を行うこと．
%
% [述語の説明]
%   - final(S): 状態 S がオートマトンの最終状態であることを表す。
%   - trans(S1, X, S2): 入力記号が X のとき、状態 S1 から S2 に遷移可能であることを表す。
%   - silent(S1, S2): 状態 S1 から S2 へ無言遷移ができることを表す。
%   - accepts(S, String): オートマトンが初期状態として、状態 S から始めて、系列 String を受理することを表す。
%   - accepts(S, String, Max_moves): オートマトンが初期状態として、状態 S から始めて
%                                    Max_moves 回以下の動作回数で系列 String を受理することを表す。
%
% /* 以下に回答を示す */

% 以下に修正した accepts を定義する
accepts(S, [], Remaining_moves) :-
    0 < Remaining_moves,
    final(S).
accepts(S, [X | Rest], Remaining_moves) :-
    0 < Remaining_moves,
    Next_remaining_moves is Remaining_moves - 1,
    trans(S, X, S1),
    accepts(S1, Rest, Next_remaining_moves).
accepts(S, String, Remaining_moves) :-
    0 < Remaining_moves,
    Next_remaining_moves is Remaining_moves - 1,
    silent(S, S1),
    accepts(S1, String, Next_remaining_moves).


% 以下にもともとの accepts を書く
accepts(S, []) :-
    final(S).
accepts(S, [X | Rest]) :-
    trans(S, X, S1),
    accepts(S1, Rest).
accepts(S, String) :-
    silent(S, S1),
    accepts(S1, String).


% 以下に確認のため使用するオートマトンの定義をする
final(s3).

trans(s1, a, s1).
trans(s1, b, s1).
trans(s1, a, s2).
trans(s2, b, s3).
trans(s3, b, s4).

silent(s2, s4).
silent(s3, s1).
silent(s4, s2).

/*
  (実行例)
[trace]  ?- accepts(s1, [a,a]).
   Call: (6) accepts(s1, [a, a]) ? creep
   Call: (7) trans(s1, a, _G2182) ? creep
   Exit: (7) trans(s1, a, s1) ? creep
   Call: (7) accepts(s1, [a]) ? creep
   Call: (8) trans(s1, a, _G2182) ? creep
   Exit: (8) trans(s1, a, s1) ? creep
   Call: (8) accepts(s1, []) ? creep
   Call: (9) final(s1) ? creep
   Fail: (9) final(s1) ? creep
   Redo: (8) accepts(s1, []) ? creep
   Call: (9) silent(s1, _G2181) ? creep
   Fail: (9) silent(s1, _G2181) ? creep
   Fail: (8) accepts(s1, []) ? creep
   Redo: (8) trans(s1, a, _G2182) ? creep
   Exit: (8) trans(s1, a, s2) ? creep
   Call: (8) accepts(s2, []) ? creep
   Call: (9) final(s2) ? creep
   Fail: (9) final(s2) ? creep
   Redo: (8) accepts(s2, []) ? creep
   Call: (9) silent(s2, _G2181) ? creep
   Exit: (9) silent(s2, s4) ? creep
   Call: (9) accepts(s4, []) ? creep
   Call: (10) final(s4) ? creep
   Fail: (10) final(s4) ? creep
   Redo: (9) accepts(s4, []) ? creep
   Call: (10) silent(s4, _G2181) ? creep
   Exit: (10) silent(s4, s2) ? creep
   Call: (10) accepts(s2, []) ? creep
   Call: (11) final(s2) ? creep
   Fail: (11) final(s2) ? creep
   Redo: (10) accepts(s2, []) ? creep
   Call: (11) silent(s2, _G2181) ? creep
   Exit: (11) silent(s2, s4) ? creep
   Call: (11) accepts(s4, []) ? creep
   Call: (12) final(s4) ? creep
   Fail: (12) final(s4) ? creep
   Redo: (11) accepts(s4, []) ? creep
   Call: (12) silent(s4, _G2181) ? creep
   Exit: (12) silent(s4, s2) ? creep
   Call: (12) accepts(s2, []) ? creep
   Call: (13) final(s2) ? creep
   Fail: (13) final(s2) ? creep
   Redo: (12) accepts(s2, []) ? creep
   Call: (13) silent(s2, _G2181) ? creep
   Exit: (13) silent(s2, s4) ? creep
   Call: (13) accepts(s4, []) ? creep
   Call: (14) final(s4) ? creep
   Fail: (14) final(s4) ? creep
   Redo: (13) accepts(s4, []) ? creep
   Call: (14) silent(s4, _G2181) ? 
   Call: (14) accepts(s2, []) ? creep
   Call: (15) final(s2) ? creep
   Fail: (15) final(s2) ? creep
   Redo: (14) accepts(s2, []) ? creep
   Call: (15) silent(s2, _G2181) ? creep
   Exit: (15) silent(s2, s4) ? creep
   Call: (15) accepts(s4, []) ? creep
   Call: (16) final(s4) ? creep
   Fail: (16) final(s4) ? creep
   Redo: (15) accepts(s4, []) ? creep
   Call: (16) silent(s4, _G2181) ? creep
   Exit: (16) silent(s4, s2) ? creep
   Call: (16) accepts(s2, []) ? creep
   Call: (17) final(s2) ? creep
   Fail: (17) final(s2) ? creep
   Redo: (16) accepts(s2, []) ? creep
   Call: (17) silent(s2, _G2181) ? creep
   Exit: (17) silent(s2, s4) ? creep
   Call: (17) accepts(s4, []) ? creep
   Call: (18) final(s4) ? creep
   Fail: (18) final(s4) ? creep
   Redo: (17) accepts(s4, []) ? creep
   Call: (18) silent(s4, _G2181) ? creep
   Exit: (18) silent(s4, s2) ? creep
   Call: (18) accepts(s2, []) ? creep
   Call: (19) final(s2) ? creep
   Fail: (19) final(s2) ? creep
   Redo: (18) accepts(s2, []) ? creep
   Call: (19) silent(s2, _G2181) ? 
   .
   .
   .
 (終わらない)
   .
   .
   .
   Call: (28) silent(s4, _G1095) ? abort


[trace]  ?- accepts(s1, [a,a],3).
   Call: (6) accepts(s1, [a, a], 3) ? creep
   Call: (7) 0<3 ? creep
   Exit: (7) 0<3 ? creep
   Call: (7) _G3271 is 3+ -1 ? creep
   Exit: (7) 2 is 3+ -1 ? creep
   Call: (7) trans(s1, a, _G3273) ? creep
   Exit: (7) trans(s1, a, s1) ? creep
   Call: (7) accepts(s1, [a], 2) ? creep
   Call: (8) 0<2 ? creep
   Exit: (8) 0<2 ? creep
   Call: (8) _G3274 is 2+ -1 ? creep
   Exit: (8) 1 is 2+ -1 ? creep
   Call: (8) trans(s1, a, _G3276) ? creep
   Exit: (8) trans(s1, a, s1) ? creep
   Call: (8) accepts(s1, [], 1) ? creep
   Call: (9) 0<1 ? creep
   Exit: (9) 0<1 ? creep
   Call: (9) final(s1) ? creep
   Fail: (9) final(s1) ? creep
   Redo: (8) accepts(s1, [], 1) ? creep
   Call: (9) 0<1 ? creep
   Exit: (9) 0<1 ? creep
   Call: (9) _G3277 is 1+ -1 ? creep
   Exit: (9) 0 is 1+ -1 ? creep
   Call: (9) silent(s1, _G3278) ? creep
   Fail: (9) silent(s1, _G3278) ? creep
   Fail: (8) accepts(s1, [], 1) ? creep
   Redo: (8) trans(s1, a, _G3276) ? creep
   Exit: (8) trans(s1, a, s2) ? creep
   Call: (8) accepts(s2, [], 1) ? creep
   Call: (9) 0<1 ? creep
   Exit: (9) 0<1 ? creep
   Call: (9) final(s2) ? creep
   Fail: (9) final(s2) ? creep
   Redo: (8) accepts(s2, [], 1) ? creep
   Call: (9) 0<1 ? creep
   Exit: (9) 0<1 ? creep
   Call: (9) _G3277 is 1+ -1 ? creep
   Exit: (9) 0 is 1+ -1 ? creep
   Call: (9) silent(s2, _G3278) ? creep
   Exit: (9) silent(s2, s4) ? creep
   Call: (9) accepts(s4, [], 0) ? creep
   Call: (10) 0<0 ? creep
   Fail: (10) 0<0 ? creep
   Redo: (9) accepts(s4, [], 0) ? creep
   Call: (10) 0<0 ? creep
   Fail: (10) 0<0 ? creep
   Fail: (9) accepts(s4, [], 0) ? creep
   Fail: (8) accepts(s2, [], 1) ? creep
   Redo: (7) accepts(s1, [a], 2) ? creep
   Call: (8) 0<2 ? creep
   Exit: (8) 0<2 ? creep
   Call: (8) _G3274 is 2+ -1 ? creep
   Exit: (8) 1 is 2+ -1 ? creep
   Call: (8) silent(s1, _G3275) ? creep
   Fail: (8) silent(s1, _G3275) ? creep
   Fail: (7) accepts(s1, [a], 2) ? creep
   Redo: (7) trans(s1, a, _G3273) ? creep
   Exit: (7) trans(s1, a, s2) ? creep
   Call: (7) accepts(s2, [a], 2) ? creep
   Call: (8) 0<2 ? creep
   Exit: (8) 0<2 ? creep
   Call: (8) _G3274 is 2+ -1 ? creep
   Exit: (8) 1 is 2+ -1 ? creep
   Call: (8) trans(s2, a, _G3276) ? creep
   Fail: (8) trans(s2, a, _G3276) ? creep
   Redo: (7) accepts(s2, [a], 2) ? creep
   Call: (8) 0<2 ? creep
   Exit: (8) 0<2 ? creep
   Call: (8) _G3274 is 2+ -1 ? creep
   Exit: (8) 1 is 2+ -1 ? creep
   Call: (8) silent(s2, _G3275) ? creep
   Exit: (8) silent(s2, s4) ? creep
   Call: (8) accepts(s4, [a], 1) ? creep
   Call: (9) 0<1 ? creep
   Exit: (9) 0<1 ? creep
   Call: (9) _G3277 is 1+ -1 ? creep
   Exit: (9) 0 is 1+ -1 ? creep
   Call: (9) trans(s4, a, _G3279) ? creep
   Fail: (9) trans(s4, a, _G3279) ? creep
   Redo: (8) accepts(s4, [a], 1) ? creep
   Call: (9) 0<1 ? creep
   Exit: (9) 0<1 ? creep
   Call: (9) _G3277 is 1+ -1 ? creep
   Exit: (9) 0 is 1+ -1 ? creep
   Call: (9) silent(s4, _G3278) ? creep
   Exit: (9) silent(s4, s2) ? creep
   Call: (9) accepts(s2, [a], 0) ? creep
   Call: (10) 0<0 ? creep
   Fail: (10) 0<0 ? creep
   Redo: (9) accepts(s2, [a], 0) ? creep
   Call: (10) 0<0 ? creep
   Fail: (10) 0<0 ? creep
   Fail: (9) accepts(s2, [a], 0) ? creep
   Fail: (8) accepts(s4, [a], 1) ? creep
   Fail: (7) accepts(s2, [a], 2) ? creep
   Redo: (6) accepts(s1, [a, a], 3) ? creep
   Call: (7) 0<3 ? creep
   Exit: (7) 0<3 ? creep
   Call: (7) _G3271 is 3+ -1 ? creep
   Exit: (7) 2 is 3+ -1 ? creep
   Call: (7) silent(s1, _G3272) ? creep
   Fail: (7) silent(s1, _G3272) ? creep
   Fail: (6) accepts(s1, [a, a], 3) ? creep
false.



  [説明, 考察, 評価]
    　関係 accepts(S, String, Max_moves) の定義にあたって、オートマトンの動作回数が
    Max_moves 回を超えた時点で false にしてバックトラックさせるために、別途カウンタを用意する
    のではなく、accepts の再帰呼び出しの際に第三引数をデクリメントしていき、0 以下の時は false
    にすることで、同じ動作をする関係を定義した。
    　今回の章では、オートマトンを Prolog を使って動作させる例が挙げられている。述語論理を使った
    処理が行えるだけで、少ないプログラム量でオートマトンを動作させたり、8クイーン問題を解いたりする
    ことができるので、とても便利だと思った。ただ、まだ自分にはそういったプログラムを何も見ずに考えて
    作ることを難しく感じるので、使いこなせるようになれるよう、勉強しようと思った。加えて、今までのプログラミング
    よりも頭を使ってプログラムを書くような感覚を覚えるので、柔軟な発想ができるようになりたいと思った。
*/
