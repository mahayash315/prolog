squeeze :-
    get0(C),
    dorest(C,s1).

dorest(46,_) :- !.  % '.'

% (s1): 初期状態
dorest(44,s1) :- !, % ','
    put(44),
    get(C),
    dorest(C,s3).
dorest(32,s1) :- !, % ' '
    get(C),
    dorest(C,s2).
dorest(C,s1) :-
    put(C),
    squeeze.

% (s2): 最後にスペースが入力された状態
dorest(44,s2) :- !, % ' *,'
    put(44),
    get(C),
    dorest(C,s3).
dorest(C, s2) :- !,  % ' *[^,]'
    put(32),
    dorest(C,s1).
    
% (s3): 最後にカンマが入力された状態
dorest(44,s3) :- !,
    put(44),
    get(C),
    dorest(C,s3).

dorest(C,s3) :- !,
    put(32),
    dorest(C,s1).
