% rep00: 第00回 演習課題レポート
% 2014年 4月10日          by 24115113 名前: 林 政行
%
% [述語の説明]
%  parent(X,Y): X は Y の親である
%  male(X): X は男である
%  father(X,Y): X は Y の父親である
%  ancestor(X,Y): X は Y の祖先である
%
parent(pam,bob).
parent(tom,bob).
parent(tom,liz).
parent(bob,ann).
male(tom).
male(bob).
father(X,Y) :- parent(X,Y),male(X).
ancestor(X,Y) :- parent(X,Y).
ancestor(X,Y) :- parent(X,Z),ancestor(Z,Y).
