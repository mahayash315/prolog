/*
自由課題レポート最終版 (〆切 8月 8日)
提出 8月 4日    by 24115113 林 政行


自由課題: 「スケジュール自動生成」


(1) 実行方法, 実行例

  [ プログラムの動作 ]
  ~~~~~~~~~~~~~~~~~~
      今回作成したプログラムは、タスク定義ファイルで定義されているタスクから、特定の期間において、
    タスクが被ることなく、依存するタスクの順序を考慮し、定義されているタスクの締切よりも前にその
    タスクを終えられるように、適当なスケジュールを作成し、出力する、という処理を行う。
      次項より、ファイル構成、およびプログラム動作に必要な定義ファイルの記述方法に関して説明する。



  [ 構成 ]
  ~~~~~~~
    　ファイル構成は以下のようになっている。

    (プログラムの存在するディレクトリ) /
                                   +- prog.pl       (プログラム本体)
                                   +- tasks.dat     (タスク定義ファイル)
                                   +- schedules.dat (スケジュール定義/格納ファイル)

    　このファイル構成の中で、プログラム本体はタスク定義ファイル tasks.dat とスケジュール定義
    ファイル schedules.dat を使用する。従って、これらは前もって作ってある、あるいはプログラム
    から作成可能になっている必要がある。

    　続いて、それぞれの定義ファイルの内容を記述する。



  [ 定義ファイル ]
  ~~~~~~~~~~~~~~
     (a) tasks.dat (タスク定義ファイル)

         [*] tasks.dat の内容の一例
         ------------------------------------------------------------------
          task(t1,task1,10,-,[]).
          task(t2,task2,22,-,[t1]).
          task(t3,task3,35,-,[]).
          task(t4,task4,50,date(2014,8,8,17,0,0,0,-,-),[t2,t3]).
          task(t5,task5,10,-,[]).
         ------------------------------------------------------------------

         　スケジューリングするタスクはタスク設定ファイル tasks.dat に定義する。
         この定義ファイルに次のフォーマットに従って記述されているタスクのみ、プログラムに読み込まれる。

         ( タスクの記述フォーマット )
          ~~~~~~~~~~~~~~~~~~~~~~~
            task(TaskId, Description, ETP, Deadline, [TaskId1, TaskId2, ..., TaskIdN])
                                                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                                   └ Dependent tasks

            * TaskId : タスク識別子（ユニークである必要がある）
            * Description : タスクの説明（スケジュール表示時に表示）
            * ETP = Estimated Time to Process : 推定所要時間 (分)
            * Deadline : この日時までに終わってないといけないという日時。
                            ex. date(2014,8,8,17,00,00,0,-,-)
                            ex. - (時間固定タスク or 締め切りなし)
            * Dependent tasks: 依存先タスクの TaskId のリスト。
                               ここに記述されるタスクは先行して終わっている必要がある、
                               というタスクを記述する。

          　従って、上記 [*] tasks.dat の内容の一例 で定義されている

             task(t4,task4,50,date(2014,8,8,17,0,0,0,-,-),[t2,t3]).
          
          は、タスク識別子 't4', 説明 'task4' の 50分 掛かる, タスク 't2', 't3'
          に依存するタスクを示している。


     (b) schedules.dat (スケジュール定義ファイル)

         [*] schedules.dat の内容の一例
         ------------------------------------------------------------------
          % schedule(date(Y,M,D,H,I,S,0,-,-),tid,isFixed)

          % static schedules:
          schedule(date(2014,8,4,8,0,0,0,-,-),t1,true).


          % dynamic schedules:
            ...(以下、生成されたスケジュールが出力される)...

         ------------------------------------------------------------------

           あらかじめタスクの実施開始日時を指定（固定）する場合は、上記一例のように
         static schedule として定義する。

         ( スケジュールの記述フォーマット )
          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             schedule(StartDateTime, TaskId, IsFixed)

            * TaskId : タスク識別子（tasks.dat で定義したもの）
            * StartDateTime : タスク開始日時
                         ex. date(2014,8,8,17,00,00,0,-,-)
            * IsFixed : 固定スケジュールタスクかどうか。
                        固定スケジュールタスクとは、指定した日時 StartDateTime に必ず開始
                        する必要があるタスクのことを言う。（授業の１コマなど）
                        (true = 固定スケジュールタスク, false = 自由に動かせるタスク)



  [ プログラムの実行方法と実行例 ]
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     (※ 以下、実行結果を貼り付ける都合上、インデントが崩れます。)

     ※ 本プログラムはターミナル上で動作している prolog 上での実行を想定しています。
        emacs 上で動く prolog 上ではエスケープシーケンスが使えなかったため、
        正しく表示されませんでした。

  　実行方法は、次のように go. を実行する。するとメインメニューが表示されるので、その後の操作は
  キーボードの矢印キー、エンターキーで行う。具体的には次のようなメニューが表示される。


(実行例): メインメニュー
---------------------------------------------------------------------------------
スケジュール自動生成  (2014年8月5日 〜 2014年8月11日)
 -> リロード
    期間設定
    スケジュール初期化
    スケジューリング
    スケジュール表示
    終わり
---------------------------------------------------------------------------------


  　メインメニューの各項目は、次のような操作を表す。
    ________________________________________________________________________

       - リロード　　　　　　: タスク、スケジュールの定義ファイルから定義を再読込する

       - 期間設定　　　　　　: スケジューリングを行う期間を入力する
                            （デフォルトではプログラム実行日から一週間）

       - スケジュール初期化　: 生成した動的スケジュールを初期化する
         　　　　　　　　　   次回実行時はランダムな初期値が用意される。

       - スケジューリング　　: スケジュールを生成する

       - スケジュール表示　　: スケジュールを表示する

       - 終わり　　　　　　　: メインメニューを抜ける
    ________________________________________________________________________



   　キーボードでの操作により、ポインタを目的の項目に合わせ、エンターキーを押すことで、
   その項目を実行することができる。

   　以下にスケジューリングを実行した際の動作を記載する。





---------------------------------------------------------------------------------
(実行例): スケジューリング時の制約表示
---------------------------------------------------------------------------------
既存のスケジュール:
---------------------------------------
:- dynamic schedule/3.

schedule(date(2014, 8, 4, 8, 0, 0, 0, -, -), t1, true).


存在する制約:
---------------------------------------
:- dynamic constraint/4.

constraint(t4, 1, deadline, cell(49, 4, -, -)).
constraint(t4, 1, dependent, chunk(t2, 3, 2)).
constraint(t4, 1, dependent, chunk(t3, 5, 5)).
constraint(t2, 2, sequential, chunk(t2, 1, 10)).
constraint(t2, 3, sequential, chunk(t2, 2, 10)).
constraint(t3, 2, sequential, chunk(t3, 1, 10)).
constraint(t3, 3, sequential, chunk(t3, 2, 10)).
constraint(t3, 4, sequential, chunk(t3, 3, 10)).
constraint(t3, 5, sequential, chunk(t3, 4, 10)).
constraint(t4, 2, sequential, chunk(t4, 1, 10)).
constraint(t4, 3, sequential, chunk(t4, 2, 10)).
constraint(t4, 4, sequential, chunk(t4, 3, 10)).
constraint(t4, 5, sequential, chunk(t4, 4, 10)).



何かキーを押すと続行...
---------------------------------------------------------------------------------




---------------------------------------------------------------------------------
(実行例): スケジューリングの途中経過が表示される
---------------------------------------------------------------------------------
Remaining Iteration: 9930, Eval = 278.91999999999996, DupCount=0
[p(51.0,t4,5),p(50.6,t3,3),p(50.5,t3,4),p(50.5,t2,3),p(50.2,t4,4),p(26.119999999999997,t4,1)]999997,t4,1)](25.85,t4,1)](25.25,t4,1)]000003,t4,1)]999995,t4,1)]

choose cell to move: (t4-5) [20,5] (P=51.0)
TMP=[1]          1         2         3         4         5         6         7    
  1              -         -         -         -         -         -         -    
  2              -      [t2-3]       -         -         -         -         -    
  3              -         -         -         -         -         -         -    
  4              -         -         -         -      [t4-1]       -         -    
  5              -         -         -         -      [t4-2]       -         -    
  6              -         -         -         -      [t4-3]       -         -    
  7              -         -         -         -         -         -         -    
  8              -         -         -         -         -         -         -    
  9              -         -         -         -      [t4-4]       -         -    
 10              -         -         -         -         -         -         -    
 11              -         -         -         -         -         -         -    
 12              -         -         -         -         -         -         -    
 13              -         -         -         -         -         -         -    
 14              -         -         -         -         -         -         -    
 15              -         -         -         -         -         -         -    
 16              -         -         -         -         -         -         -    
 17              -         -         -         -         -         -         -    
 18              -         -         -         -         -         -         -    
 19              -         -         -         -         -         -         -    
 20              -         -         -         -      [t4-5]       -         -    
 21              -         -         -         -         -         -         -    
 22              -         -         -         -         -         -         -    
 23              -         -         -         -         -         -         -    
 24              -         -         -         -         -         -      [t5-1]  
 25              -         -         -         -         -         -         -    
 26              -         -        3.8        -         -         -         -    
 27              -         -        2.7        -         -         -         -    
 28              -         -        1.6        -         -         -         -    
 29              -         -      [t3-1]       -         -         -         -    
 30              -         -       -50.6       -         -         -         -    
 31              -         -       -0.5        -         -         -         -    
 32              -         -       -0.4        -         -         -         -    
 33              -         -       -0.3        -         -         -         -    
 34              -         -       -0.2        -         -         -         -    
 35              -         -       -0.1        -         -         -         -    
 36              -         -      [t3-2]       -         -         -         -    
 37              -         -      [t3-3]       -         -         -         -    
 38              -         -        0.2        -         -         -         -    
 39              -         -        0.3        -         -         -         -    
 40              -         -        0.4        -         -         -         -    
 41              -         -        0.5        -         -         -         -    
 42              -         -        0.6        -         -         -         -    
 43              -         -      [t3-4]       -         -         -         -    
 44           [t2-1]       -      [t3-5]       -         -         -         -    
 45           [t2-2]       -        0.9        -         -         -         -    
 46              -         -         1         -         -         -         -    
 47              -         -         -         -         -         -         -    
 48              -         -         -         -         -         -         -    
 49              -         -         -       <t4>        -         -         -    

[ 9931] moving [36,3] -> [30,3], (FromP=50.6, Cost=-50.6)
---------------------------------------------------------------------------------


    　スケジュール生成のために制約充足問題を局所探索によって解くが、その際に
    上記のような実行経過が表示される。



---------------------------------------------------------------------------------
(実行例): スケジューリング結果の表示
---------------------------------------------------------------------------------
スケジューリング結果:
                 1         2         3         4         5         6         7    
  1              -         -         -         -         -         -         -    
  2              -         -         -         -         -         -         -    
  3              -         -         -         -         -         -         -    
  4              -         -         -         -         -         -         -    
  5              -         -         -         -         -         -         -    
  6              -         -         -         -         -         -         -    
  7           [t2-1]       -         -         -         -         -         -    
  8           [t2-2]       -         -         -         -         -         -    
  9           [t2-3]       -         -         -         -         -         -    
 10              -         -         -         -         -         -         -    
 11              -         -         -         -         -         -         -    
 12              -         -         -         -         -         -         -    
 13              -      [t3-1]       -         -         -         -         -    
 14              -      [t3-2]       -         -         -         -         -    
 15              -      [t3-3]       -         -         -         -         -    
 16              -      [t3-4]       -         -         -         -         -    
 17              -      [t3-5]       -         -         -         -         -    
 18              -         -         -         -         -         -         -    
 19              -      [t4-1]       -         -         -         -         -    
 20              -      [t4-2]       -         -         -         -         -    
 21              -      [t4-3]       -         -         -         -         -    
 22              -      [t4-4]       -         -         -         -         -    
 23              -      [t4-5]       -         -         -         -         -    
 24              -         -         -         -         -         -         -    
 25              -         -         -         -         -         -         -    
 26              -         -         -         -         -         -         -    
 27              -         -         -         -         -         -         -    
 28              -         -         -         -         -         -         -    
 29              -         -         -         -         -         -         -    
 30              -         -         -         -         -         -         -    
 31              -         -         -         -         -         -      [t5-1]  
 32              -         -         -         -         -         -         -    
 33              -         -         -         -         -         -         -    
 34              -         -         -         -         -         -         -    
 35              -         -         -         -         -         -         -    
 36              -         -         -         -         -         -         -    
 37              -         -         -         -         -         -         -    
 38              -         -         -         -         -         -         -    
 39              -         -         -         -         -         -         -    
 40              -         -         -         -         -         -         -    
 41              -         -         -         -         -         -         -    
 42              -         -         -         -         -         -         -    
 43              -         -         -         -         -         -         -    
 44              -         -         -         -         -         -         -    
 45              -         -         -         -         -         -         -    
 46              -         -         -         -         -         -         -    
 47              -         -         -         -         -         -         -    
 48              -         -         -         -         -         -         -    
 49              -         -         -       <t4>        -         -         -    
何かキーを押すと続行...
---------------------------------------------------------------------------------


    　局所探索の結果、上記のようにスケジューリング結果が表示される。











(2) テーマ名とテーマ選択理由, 参考にした文献

  [ テーマ名 ]
  ~~~~~~~~~~~
    　スケジュール自動生成


  [ テーマの選択理由 ]
  ~~~~~~~~~~~~~~~~~
    　日頃、自分のスケジュール管理は Google カレンダーで行っているが、スケジュールの入力、
    調整、編集へすべて手作業で行う必要がある。最近はその入力、調整が面倒に思えてきたことも
    相まって、自動でスケジュールを作ってくれて、管理してくれるプログラムがあれば便利だろうな
    と常々思っていたところ、Prolog 演習で N-Queen の制約充足問題を解くプログラムを作ることが
    できるのを知り、もしかしたらスケジュールを調整してくれるプログラムも作れるかもしれないと
    思い、このテーマを選択した。

  [ 参考にした文献 ]
  ~~~~~~~~~~~~~~~~
      
(3) アルゴリズム／データ構造の説明

  [ アルゴリズムの説明 ]
  ~~~~~~~~~~~~~~~~~~~
    　

  [ データ構造の説明 ]
  ~~~~~~~~~~~~~~~~~
    　

      
(4) 述語の説明

  [ 基本的な述語 ]
  ~~~~~~~~~~~~~~
    　

  [ CSP 関連の述語 ]
  ~~~~~~~~~~~~~~~~~
    　

  [ 画面操作関連の述語 ]
  ~~~~~~~~~~~~~~~~~~~
      
(5) 考察

  [ 工夫したところ ]
  ~~~~~~~~~~~~~~~~
      

  [ 問題点と改善点 ]
  ~~~~~~~~~~~~~~~~
      





  -----------------------------------------------------------------------------

  [ 参考文献のリスト（参考にした他の人のレポートも含む） ]
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      






*/


%
%============================================
%
%  *- 基本的な述語の実装
%     ~~~~~~~~~~~~~~~~
%--------------------------------------------
% 
%
% conc
conc([],L,L).
conc([X|L1],L2,[X|L3]) :- conc(L1,L2,L3).

% member
is_member(X,[X|_]).
is_member(X,[Y|Rest]) :-
    X \== Y,
    is_member(X,Rest).

% nth
nth([X|_],0,X) :- !.
nth([_|R],I,X) :- 1 =< I, NextI is I-1, nth(R,NextI,X).

% count
count(Cond, Count) :- (aggregate_all(count, Cond, Count), !; Count is 0).

% step
step(Low,High,Step,Int) :- between(Low,High,Int), (Int-Low) mod Step =:= 0.

% sum
sum([],0).
sum([X|L],S) :- sum(L,S0), S is S0 + X.

% choose
choose([],[]).
choose(List,Val) :-
    length(List,Len),
    random(0,Len,Index),
    nth(List,Index,Val).

% load
load :-
    retractAllTasks,
    retractAllSchedules,
    see('tasks.dat'),
    readTasks,
    seen,
    see('schedules.dat'),
    readSchedules,
    seen, !.
retractAllTasks :- (retractall(task(_,_,_,_,_)); true).
retractAllSchedules :- (retractall(schedule(_,_,_)); true).
readTasks :- read(X), (procReadTasks(X), readTasks; !).
readSchedules :- read(X), (procReadSchedules(X), readSchedules; !).
procReadTasks(end_of_file) :- !, fail.
procReadTasks(X) :- X =.. [task | _], !, assert(X).
procReadTasks(_).
procReadSchedules(end_of_file) :- !, fail.
procReadSchedules(X) :- X =.. [schedule | _], !, assert(X).
procReadScheudles(_).

% save
save :-
    tell('tasks.dat'),
    write('% task(tid,taskName,ETP,deadline,dependentTasks)\n\n'),
    writeTasks,
    told, !,
    tell('schedules.dat'),
    write('% schedule(date(Y,M,D,H,I,S,0,-,-),tid,isFixed)\n\n'),
    writeSchedules, !,
    told, !.

writeTasks([]) :- !.
writeTasks([T|Rest]) :- !,
    write(T), write('.'), nl,
    writeTasks(Rest).
writeTasks :-
    (setof(task(X1,X2,X3,X4,X5), task(X1,X2,X3,X4,X5), Set); Set=[]),
    writeTasks(Set).
writeSchedules([]) :- !.
writeSchedules([S|Rest]) :- !,
    write(S), write('.'), nl,
    writeSchedules(Rest).
writeSchedules :-
    write('% static schedules:\n'),
    (setof(schedule(X1,X2,true), schedule(X1,X2,true), Set1), !; Set1=[]),
    writeSchedules(Set1), nl, nl, !,
    write('% dynamic schedules:\n'),
    (setof(schedule(X1,X2,false), schedule(X1,X2,false), Set2), !; Set2=[]),
    writeSchedules(Set2), !.
    
% clear
clear :- (retractall(schedule(_,_,false)),!; true).
clear_all :- (retractall(schedule(_,_,_)), !; true).

% config
set_config(Key,Value) :-
    (retractall(my_config(Key,_)), !; true),
    assert(my_config(Key,Value)).

get_config(Key,Value) :-
    current_predicate(my_config/2),
    my_config(Key,Value).

% 日付の生成に使用する Generator
day_exists(Year,Month,Day,DayOfTheWeek) :-
    (is_member(Month, [1,3,5,7,9,11]), between(1,31,Day);
     is_member(Month, [4,6,8,10,12]), between(1,30,Day);
     Month = 2, ((Year mod 4 =:= 0, Year mod 100 =\= 0;  is_member(Year mod 900, [200, 600]), between(1,30,Day));
		 between(1,29,Day))),
    day_of_the_week(date(Year,Month,Day),DayOfTheWeek), !.

% スケジュール期間の取得に関する関数
get_schedule_span(ScheduleFrom, ScheduleTo) :-
    (get_config('ScheduleFrom',ScheduleFrom), !;
     get_time(Now), stamp_to_date(Now,Y,M,D), date_time_stamp(date(Y,M,D,0,0,0,0,-,-),ScheduleFrom),
     set_config('ScheduleFrom',ScheduleFrom)),
    (get_config('ScheduleTo',ScheduleTo), !; ScheduleTo is ScheduleFrom + 604799, set_config('ScheduleTo',ScheduleTo)).
get_schedule_span(FromYear,FromMonth,FromDay,ToYear,ToMonth,ToDay) :-
    get_schedule_span(From, To),
    stamp_to_date(From,FromYear,FromMonth,FromDay),
    stamp_to_date(To,ToYear,ToMonth,ToDay).

get_day_span(DayFrom, DayTo) :-
    (get_config('DayFrom',DayFrom), !; DayFrom is 900),
    (get_config('DayTo',DayTo), !; DayTo is 1200). % FIXME

get_cell_size('row',RowSize) :-
    get_day_span(DayFrom,DayTo),
    count_rows(DayFrom,DayTo,RowSize0),
    RowSize is RowSize0 + 1.

get_cell_size('col',ColSize) :-
    count(day(_,_,_,_), ColSize).

% date 構造体の操作を簡単にする関数
stamp_to_date(Timestamp, Y, M, D) :-
    stamp_date_time(Timestamp, Date, 'UTC'),
    Date = date(Y,M,D,_,_,_,_,_,_).

stamp_to_time(Timestamp, H, M, S) :-
    stamp_date_time(Timestamp, Date, 'UTC'),
    Date = date(_,_,_,H,M,S,_,_,_).

% setSchedule
set_schedule(Tid, Timestamp, Fix) :-
    % すでにエントリが存在していたら削除
    (schedule(_, Tid, _), retract(schedule(_,Tid,_)); true), !,
    % エントリを追加
    stamp_date_time(Timestamp, DateTime, 0),
    assert(schedule(DateTime, Tid, Fix)).

% set_cell
set_cell(Row,Col,Tid,Cid) :-
    (retractall(cell(Row,Col,_,_)), !; true),
    assert(cell(Row,Col,Tid,Cid)).
swap_cell(FromRow,FromCol,ToRow,ToCol) :-
    cell(FromRow,FromCol,Tid1,Cid1),
    cell(ToRow,ToCol,Tid2,Cid2), !,
    set_cell(FromRow,FromCol,Tid2,Cid2),
    set_cell(ToRow,ToCol,Tid1,Cid1).

% find
find_max([L|Ls], Max) :- find_max(Ls, L, Max).
find_max([], Max, Max).
find_max([L|Ls], Max0, Max) :-
    Max1 is max(L, Max0),
    find_max(Ls, Max1, Max).

find_min([L|Ls], Min) :- find_min(Ls, L, Min).
find_min([], Min, Min).
find_min([L|Ls], Min0, Min) :-
    Min1 is min(L, Min0),
    find_min(Ls, Min1, Min).

find_day(FromYear,FromMonth,FromDay,ToYear,ToMonth,ToDay,Year,Month,Day,DayOfTheWeek) :-
    between(FromYear,ToYear,Year),
    (FromYear =:= Year, Year =:= ToYear, find_day(FromMonth,FromDay,ToMonth,ToDay,Year,Month,Day,DayOfTheWeek);
     FromYear =:= Year, Year  <  ToYear, find_day(FromMonth,FromDay,     13,ToDay,Year,Month,Day,DayOfTheWeek);
     FromYear  <  Year, Year  <  ToYear, find_day(        0,FromDay,     13,ToDay,Year,Month,Day,DayOfTheWeek);
     FromYear  <  Year, Year =:= ToYear, find_day(        0,FromDay,ToMonth,ToDay,Year,Month,Day,DayOfTheWeek)).
find_day(FromMonth,FromDay,ToMonth,ToDay,Year,Month,Day,DayOfTheWeek) :-
    between(FromMonth,ToMonth,Month), between(1,12,Month),
    (FromMonth =:= Month, Month =:= ToMonth, find_day(FromDay,ToDay,Year,Month,Day,DayOfTheWeek);
     FromMonth =:= Month, Month  <  ToMonth, find_day(FromDay,   32,Year,Month,Day,DayOfTheWeek);
     FromMonth  <  Month, Month  <  ToMonth, find_day(      0,   32,Year,Month,Day,DayOfTheWeek);
     FromMonth  <  Month, Month =:= ToMonth, find_day(      0,ToDay,Year,Month,Day,DayOfTheWeek)).
find_day(FromDay,ToDay,Year,Month,Day,DayOfTheWeek) :-
    between(FromDay,ToDay,Day), between(1,31,Day),
    day_exists(Year,Month,Day,DayOfTheWeek).

count_rows(FromTime, ToTime, RowSize) :-
    Diff is ToTime-FromTime,
    H is floor(Diff / 100) + floor((Diff mod 100)/60),
    I is ((Diff mod 100) mod 60),
    RowSize is floor(H*6) + floor(I/10).

count_days(Y1,M1,D1,Y2,M2,D2,Count) :-
    (retractall(tmp_day(_,_,_,_)), !; true),
    forall(find_day(Y1,M1,D1,Y2,M2,D2,Year,Month,Day,DayOfTheWeek),
	   assert(tmp_day(Year,Month,Day,DayOfTheWeek))),
    count(tmp_day(_,_,_,_),Count),
    (retractall(tmp_day(_,_,_,_)), !; true).

stamp_to_cell(Timestamp,Row,Col) :-
    get_schedule_span(ScheduleFrom,ScheduleTo),
    ScheduleFrom =< Timestamp, Timestamp =< ScheduleTo,
    stamp_to_date(ScheduleFrom,Y0,M0,D0),
    stamp_to_date(Timestamp,Y1,M1,D1),
    count_days(Y0,M0,D0,Y1,M1,D1,Col),
    get_day_span(DayFrom,DayTo),
    stamp_to_time(Timestamp,H1,I1,_),
    Time is H1*100+I1,
    DayFrom =< Time, Time =< DayTo,
    count_rows(DayFrom,Time,Row0),
    Row is Row0 + 1.

cell_to_stamp(Row,Col,Timestamp) :-
    get_schedule_span(ScheduleFrom,ScheduleTo),
    get_day_span(DayFrom,_),
    get_cell_size('row',RowSize),
    stamp_to_date(ScheduleFrom,Y0,M0,D0),
    stamp_to_time(ScheduleFrom,H0,I0,S0),
    D1 is D0 + (Col-1) + floor(Row/RowSize),
    H1 is H0 + floor((DayFrom/100))+floor((Row mod RowSize)/6),
    I1 is I0 + ceil(DayFrom mod 100) + ceil(((Row-1) mod RowSize) mod 6),
    date_time_stamp(date(Y0,M0,D1,H1,I1,S0,0,-,-), Timestamp),
    Timestamp =< ScheduleTo.

cell_distance(Row1,Col1,Row2,Col2,D) :-
    get_cell_size('row',RowSize),
    get_cell_size('col',ColSize),
    between(1,RowSize,Row1), between(1,RowSize,Row2),
    between(1,ColSize,Col1), between(1,ColSize,Col2),
    D is (Col2-Col1)*RowSize + (Row2-Row1).

%
%============================================
%
%  *- 重み付き CSP の制約と重みの定義
%     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%--------------------------------------------
% 
%
% eval
eval(Eval) :-
	findall(P, penalty(_,_,P), Ps),
	sum(Ps,Eval).

% penalty
penalty_val(Tid, Cid, P) :- (penalty(Tid,Cid,P), !; P = 0).
penalty(Tid, Cid, P) :-
    chunk(Tid, Cid, _),
    findall(constraint(Tid,Cid,Type,Val), constraint(Tid,Cid,Type,Val), Constraints),
    penalty(Constraints, P),
    P \== 0.
penalty([],0) :- !.
penalty([C|Rest], Weight) :-
    penalty(Rest, Weight1),
    C = constraint(Tid,Cid,Type,Val),
    (penalty(Type,Tid,Cid,Val,Weight2), Weight is Weight1 + Weight2, !;
     Weight is Weight1 + 99999).

% 締め切りの制約
penalty('deadline', Tid, 1, Cell, Weight) :-
    Cell = cell(Drow,Dcol,_,_),
    chunk_size(Tid,ChunkSize),
    cell(Row,Col,Tid,1),
    cell_distance(Row,Col,Drow,Dcol,D),
    W0 is (D+ChunkSize),
    ( 0  < W0, Weight is 0, !;
     W0 =<  0, Weight is (-W0)*1.5 + 1000).

% 依存タスクの制約
penalty('dependent', Tid, 1, Chunk, Weight) :-
    Chunk = chunk(Dtid,Dcid,_),
    chunk_size(Dtid,Dchunksize),
    cell(Row,Col,Tid,1),
    cell(Drow,Dcol,Dtid,Dcid),
    cell_distance(Drow,Dcol,Row,Col,D),
    W0 is (D+1) - integer(Dchunksize/2),
    (W0 <  0, Weight is (-W0)*1.3 + 20, !;
     W0 =  0, Weight is 0, !;
      0 < W0, Weight is W0*0.03 + 10).

% 連続チャンクの制約
penalty('sequential', Tid, Cid, Chunk, Weight) :-
    Chunk = chunk(Ptid,Pcid,_),
    cell(Row,Col,Tid,Cid),
    cell(Prow,Pcol,Ptid,Pcid),
    cell_distance(Prow,Pcol,Row,Col,D),
    W0 is D - 1,
    (W0 <  0, Weight is (-W0)*1.1 + 50, !;
     W0 =  0, Weight is 0, !;
      0 < W0, Weight is W0*0.1 + 50).

% 固定スケジュールの制約
penalty('fixed', Tid, Cid, Cell, Weight) :-
    Cell = cell(Row,Col,_,_),
    cell(Crow,Ccol,Tid,Cid),
    cell_distance(Row,Col,Crow,Ccol,D),
    (0 = D, Weight is 0, !;
     Weight is abs(D)*1.6 + 10000).

% 弱固定スケジュールの制約
penalty('soft_fixed', Tid, Cid, Cell, Weight) :-
    Cell = cell(Row,Col,_,_),
    cell(Crow,Ccol,Tid,Cid),
    cell_distance(Row,Col,Crow,Ccol,D),
    (D = 0, Weight is 0, !;
     Weight is abs(D)*1.2 + 100).



%
%=============================================
%
%  *- CSP の解探索を行うための準備をする関数の記述
%     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%---------------------------------------------
% 
%
% prepare
prepare :-
    prepare_days,
    prepare_cells,
    prepare_chunks,
    prepare_constraints.

prepare_days :-
    (retractall(day(_,_,_,_)), !; true),
    get_schedule_span(FromYear,FromMonth,FromDay,ToYear,ToMonth,ToDay),
    forall(find_day(FromYear,FromMonth,FromDay,ToYear,ToMonth,ToDay,Year,Month,Day,DayOfTheWeek),
	   assert(day(Year,Month,Day,DayOfTheWeek))).

prepare_cells :-
    (retractall(cell(_,_,_,_)), !; true),
    get_cell_size('row',RowSize),
    get_cell_size('col',ColSize),
    forall(between(1,RowSize,Row),
	   forall(between(1,ColSize,Col),
		  (assert(cell(Row,Col,-,-)), !; true))).

prepare_chunks :-
    (retractall(chunk_size(_,_)), !; true),
    (retractall(chunk(_,_,_)), !; true),
    get_schedule_span(ScheduleFrom,_),
    get_day_span(DayFrom,_),
    StartTime is ScheduleFrom + floor(DayFrom/100)*3600 + min(ceil(DayFrom mod 100),60)*60,
    forall(task(Tid,_,ETP,Deadline,_),(
	       % 固定スケジュールが範囲外で存在する場合は無視する
	       (schedule(DateTime,Tid,true), date_time_stamp(DateTime,Timestamp),not(stamp_to_cell(Timestamp,_,_))), !, true;
	       % Deadline を超えたタスクは無視する
	       (Deadline \== '-', date_time_stamp(Deadline,Timestamp), Timestamp =< StartTime), !, true;
	       (
		  
		   % Deadline に間に合うタスクはチャンクに分割してアサート
		   ChunkSize is ceil(ETP / 10),
		   (ETP mod 10 =:= 0, LastLen is 10, !; LastLen is ETP mod 10),
		   assert(chunk_size(Tid,ChunkSize)),
		   (ChunkSize =:= 1, !, assert(chunk(Tid,1,LastLen));
		    1 < ChunkSize, assert(chunk(Tid,1,10)),
		    To is ChunkSize-1, forall(between(2,To,I), (assert(chunk(Tid,I,10)))),
		    assert(chunk(Tid,ChunkSize,LastLen)))
	       )
	  )).



% 制約の準備
prepare_constraints :-
    % 既存の制約をすべて削除
    (retractall(constraint(_,_,_,_)), !; true),
    % Deadline の制約
    forall(chunk(Tid,1,_),(
	       % 締切の取得
	       task(Tid,_,_,Deadline,_),
	       (
		   % Deadline が無ければ Deadline 制約は加えない
		   Deadline = '-', !, true;
		   % Deadline があれば Deadline 制約を加える
		   date_time_stamp(Deadline,Timestamp),
		   (
		       stamp_to_cell(Timestamp,Row,Col),
		       assert(constraint(Tid,1,'deadline',cell(Row,Col,-,-)))
		       ;
		       true
		   )
	       )
	  )),
    forall(chunk(Tid,1,_),(
	       % 依存タスクの取得
	       task(Tid,_,_,_,Deps),
	       % 依存タスクの制約を処理する
	       prepare_constraints('dependent',Tid,Deps)
	  )),
    % 分割されたタスクが連続する、という制約
    forall(chunk(Tid,Cid,_),(
	       PrevCid is Cid-1, chunk(Tid,PrevCid,Len), !, assert(constraint(Tid,Cid,'sequential',chunk(Tid,PrevCid,Len))); true
	  )),
    % 固定スケジュールの制約
    forall(schedule(DateTime,Tid,true),(
	       date_time_stamp(DateTime,Timestamp),
	       (stamp_to_cell(Timestamp,Row,Col), !, assert(constraint(Tid,1,'fixed',cell(Row,Col,-,-)));
		true)
	  )),
    % 今までのスケジュールをなるべく動かさない制約
    forall(schedule(DateTime,Tid,false),(
	       date_time_stamp(DateTime,Timestamp),
	       (stamp_to_cell(Timestamp,Row,Col), !, assert(constraint(Tid,1,'soft_fixed',cell(Row,Col,-,-)));
		true)
	  )).
prepare_constraints('dependent',_,[]) :- !.
prepare_constraints('dependent',Tid,[Dtid|Rest]) :-
    % 依存タスクの最後の分割の Cid (Chunk Id)
    chunk_size(Dtid,Dcid), !,
    % 依存タスクの最後の分割が存在することを確認
    chunk(Dtid,Dcid,Dlen),
    % 依存元タスク (自タスク) の最初の分割が依存タスクの最後の分割よりも後に来る制約を加える
    assert(constraint(Tid,1,'dependent',chunk(Dtid,Dcid,Dlen))),
    % 次の依存制約を処理
    prepare_constraints('dependent',Tid,Rest), !
    ;
    prepare_constraints('dependent',Tid,Rest).


% セルからスケジュールへ
apply_schedule :-
    (retractall(schedule(_,_,false)), !; true),
    forall(cell(Row,Col,Tid,1), (
	       (schedule(_,Tid,true), !, true;
		cell_to_stamp(Row,Col,Timestamp),
		stamp_to_date(Timestamp,Y,M,D),
		stamp_to_time(Timestamp,H,I,S),
		assert(schedule(date(Y,M,D,H,I,S,0,-,-),Tid,false)))
	  )).



%
%============================================
%
%  *- CSP の解を見つけるためのプログラムの記述
%     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%--------------------------------------------
% 
%
% 初期値の決定
init_csp :-
    count(chunk(_,_,_),ChunkNum),
    count(cell(_,_,_,_),CellNum),
    findall(chunk(Tid,Cid,Len),chunk(Tid,Cid,Len),Chunks),
    get_cell_size('row',RowSize),
    randset(ChunkNum, CellNum, PosList),
    init_csp(Chunks, PosList, RowSize).
init_csp([],_,_) :- !.
init_csp([Chunk|Rest1], [Pos|Rest2], RowSize) :-
    init_csp(Rest1,Rest2,RowSize),
    Row is (Pos mod RowSize) + 1,
    Col is ceil(Pos  /  RowSize),
    Chunk = chunk(Tid,Cid,_),
    set_cell(Row,Col,Tid,Cid).

% 制約を満たしていないセルのうち、ランダムに移動対象のセルを1つ決定する
select_move_cell(Lrow,Lcol,Row,Col,P) :-
    % 一時使用の述語を全削除（念のため）
    (retractall(p_of(_,_,_)), !; true),
    % 一つ前に移動させたセルがあれば確認
    (cell(Lrow,Lcol,Ltid,Lcid), !; Ltid = '-', Lcid = '-'),
    % 制約を満たしていないタスクチャンクをすべて取り出し、述語 p_of(Tid,Cid,P) でアサート
    forall(penalty(Tid,Cid,P), assert(p_of(Tid,Cid,P))),
    % ペナルティ(重み)順でソートされたリストを取得
    setof(p(P,Tid,Cid), (Tid,Cid)^p_of(Tid,Cid,P), Ps),
    reverse(Ps,Psr), write(Psr), nl,
    % 移動させるセルの決定
    select_move_cell_inner(Psr,Ltid,Lcid,Row,Col,P),
    % 一時使用の述語を全削除
    (retractall(p_of(_,_,_)), !; true).
select_move_cell_inner([],_,_,-1,-1,0) :- !.
select_move_cell_inner([X|Rest],Ltid,Lcid,Row,Col,P) :-
    % 選択肢がまだあるなら 1/2 の確率で次の選択肢へ
    Rest \== [], random(0,2,0), select_move_cell_inner(Rest,Ltid,Lcid,Row,Col,P), !;
    % 選択肢がまだあってこの選択肢が選ばれても、一つ前のループで移動したセルなら飛ばす
    Rest \== [], X = p(_,Ltid,Lcid), select_move_cell_inner(Rest,Ltid,Lcid,Row,Col,P), !;
    % この選択肢が選ばれた
    X = p(P,Tid,Cid), cell(Row,Col,Tid,Cid).

% セルの移動先を決定する
decide_move_to(FromRow,FromCol,FromP,ToRow,ToCol,Temperature,ChosenCost) :-
    % 一時使用の述語を全削除
    (retractall(cost_at(_,_,_)), !; true),
    % 移動元セルの周辺のセルについて、そこに移動（スワップ）した際に得られる相対コストを計算し、
    % 述語 cost_at としてアサート
    forall(candidate_move_to(FromRow,FromCol,ToRow,ToCol),(
	       cost(FromRow,FromCol,FromP,ToRow,ToCol,Cost),
	       assert(cost_at(ToRow,ToCol,Cost))
	  )),
    % コスト順でソートされたリストを取得
    setof(c(Cost,Row,Col), (Row,Col)^cost_at(Row,Col,Cost), Costs),
    % リストから Simulated Annealing により移動先のセルを選ぶ
    length(Costs,Len), Max is min(Len,Temperature),
    random(0,Max,Index), writef('TMP=[%t]  ',[Temperature]),
    nth(Costs,Index,Val),
    Val = c(ChosenCost,ToRow,ToCol).
    % 本来ならばここで一時使用の述語を削除するべきだが、後の実行経過表示に使うので残しておく
    %(retractall(cost_at(_,_,_)), !; true).

% 移動元セルの周辺にある（局所探索の対象となる）セルを取ってくる Generator
candidate_move_to(FromRow,FromCol,ToRow,ToCol) :-
    MaxDist is 10, MinDist is -10,
    between(MinDist,MaxDist,D), D =\= 0,
    cell_distance(FromRow,FromCol,ToRow,ToCol,D).

% セルを移動した際に評価値がどれだけ変わるかを返す
cost(FromRow,FromCol,FromP,ToRow,ToCol,Cost) :-
    % タスクチャンクを確認
    cell(FromRow,FromCol,Tid1,Cid1),
    cell(ToRow,ToCol,Tid2,Cid2),
    % 移動元セルがもともと評価値に与えるペナルティ(重み)をP1として取得
    %penalty_val(Tid1,Cid1,P1 ), % (ループ回数が多いので、引数 FromP として受け取る)
    P1 = FromP,
    % 移動先セルがもともと評価値に与えるペナルティ(重み)をP2として取得
    penalty_val(Tid2,Cid2,P2 ),
    % 一時的にセルをスワップ
    swap_cell(FromRow,FromCol,ToRow,ToCol),
    % 通常の CSP 解法アルゴリズムでは評価値を見るが、今回は制約の条件から
    % スワップ対象の2つのセルのみ考慮すればよいので、計算コストの掛かる
    % eval(Cost) は実行しないで、相対的なコストを算出する。
    %eval(Cost),
    % 移動した際のそれぞれのセルが評価値に与えるペナルティ(重み)を P1s, P2s として取得
    penalty_val(Tid1,Cid1,P1s),
    penalty_val(Tid2,Cid2,P2s),
    % 一時的な移動を元に戻す
    swap_cell(FromRow,FromCol,ToRow,ToCol),
    % 移動した際の相対コストを計算
    Cost is P1s-P1+P2s-P2.

% 局所探索により重み付き CSP の解を見つけるループ
solve_loop(RemItr,LastRow,LastCol,LastEval,DupCount,Temperature,FinalEval) :-
    0 < RemItr,
    % 今の評価値を計算
    eval(Eval),
    % 評価値が一つ前の評価値以上の場合はカウンタをインクリメント、減少した場合はカウンタをリセットする
    (Eval >= LastEval, NextDupCount is DupCount+1, !;
     NextDupCount is 0),
    % Simulated Annealing で使用する温度を決定
    NextTemperature is max(1,floor(Temperature*0.9)),
    location(1,1), cls_right,
    writef('Remaining Iteration: %t, Eval = %t, DupCount=%t',[RemItr,Eval,DupCount]), nl,
    (	%get_single_char(_), % FIXME: 各ステップでキーの入力をするときはコメントアウトを消す
   	% 動かすセルの決定
    	select_move_cell(LastRow,LastCol,FromRow,FromCol,FromP),
    	cell(FromRow,FromCol,Tid,Cid),
    	location(1,5),cls_right,writef('choose cell to move: (%t-%t) [%t,%t] (P=%t)',[Tid,Cid,FromRow,FromCol,FromP]),nl,
    	(
	    % ループの終了条件
	    Eval =\= 0, DupCount < 100,
	    % 移動先の検討
	    decide_move_to(FromRow,FromCol,FromP,ToRow,ToCol,Temperature,Cost),
	    print_cells, nl,
	    (
		% 相対コストが負の場合（評価値が下がるとき）は移動して、ループを回す
		Cost =< 0,
		nl,cls_right,writef('[%5r] moving [%t,%t] -> [%t,%t], (FromP=%t, Cost=%t)',[RemItr,FromRow,FromCol,ToRow,ToCol,FromP,Cost]),nl,
		swap_cell(FromRow,FromCol,ToRow,ToCol),
		NextRemItr is RemItr - 1, !,
		solve_loop(NextRemItr,ToRow,ToCol,Eval,NextDupCount,NextTemperature,FinalEval), !;
		% そうでないときは移動しないで、ループを回す
		NextRemItr is RemItr - 1, !,
		solve_loop(NextRemItr,FromRow,FromCol,Eval,NextDupCount,NextTemperature,FinalEval)
	    )
    	)
    	;
    	true
    ), !.

% 重み付き CSP の解を見つけるループを呼び出す関数
solve_csp :-
    % 前準備（タスクの分割など）
    prepare,
    % 初期値の決定
    init_csp,
    % 制約の表示
    writef('既存のスケジュール:'),nl,writef('---------------------------------------'),nl,listing(schedule),nl,
    writef('存在する制約:'),nl,writef('---------------------------------------'),nl,listing(constraint),nl,nl,
    writef('何かキーを押すと続行...'),nl,
    get_single_char(_),
    cls,
    % 最大ループ回数の設定
    MaxItr is 10000,
    % 解を見つけるループの開始
    solve_loop(MaxItr,-1,-1,-1,0,10,_),
    % ループを抜けたらスケジューリング結果の表示
    cls, location(1,1),
    write('スケジューリング結果:'),
    print_cells(false),nl,
    writef('何かキーを押すと続行...'),nl,
    get_single_char(_).


% print_cells
print_cells :- print_cells(true).
print_cells(Flg) :- get_cell_size('row',RowSize), get_cell_size('col',ColSize),
    forall(between(1,ColSize,Col), print_head(Flg,Col)),
    forall(between(1,RowSize,Row), print_left(Flg,Row)),
    forall(between(1,RowSize,Row), forall(between(1,ColSize,Col),(print_cell(Flg,Row,Col), !; true))).
print_cells_pos(true,Xoffset,Yoffset,X,Y) :- X is 3 + Xoffset, Y is 6 + Yoffset.
print_cells_pos(false,Xoffset,Yoffset,X,Y) :- X is 3 + Xoffset, Y is 2 + Yoffset.
print_head(Flg,Col) :- print_cells_pos(Flg,Col*10,0,X,Y), location(X,Y), writef('%10c',[Col]).
print_left(Flg,Row) :- print_cells_pos(Flg,-2,Row,X,Y), location(X,Y), writef('%3r',[Row]).
print_cell(Flg,Row,Col) :-
    cell(Row,Col,-,_), !, print_cells_pos(Flg,Col*10,Row,X,Y), location(X,Y),
    (constraint(Tid,_,'deadline',cell(Row,Col,_,_)), !, format(atom(Str),'<~w>',[Tid]),writef('%10c', [Str]), !;
     Flg = true, cost_at(Row,Col,Cost), format(atom(Str),'~g',[Cost]), writef('%10c',[Str]), !;
     writef('%10c',['-'])).
print_cell(Flg,Row,Col) :-
    cell(Row,Col,Tid,Cid), !, print_cells_pos(Flg,Col*10,Row,X,Y), location(X,Y),
    format(atom(Str),'[~w-~w]',[Tid,Cid]),writef('%10c',[Str]).





%
%============================================
%
%  *- コンソール画面制御に関する記述部分
%     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%--------------------------------------------
% ※ 以下メニュー、操作画面の出力に関する記述なので
%    説明を省く。
%

% terminal control
cls :- write('\e[2J').
cls_right :- write('\e[0K').
cls_left :- write('\e[1K').
cls_line :- write('\e[2K').
location(X,Y) :- write('\e['),write(Y),write(';'),write(X),write('H').
right(X) :- write('\e['),write(X),write('C').
left(X) :- write('\e['),write(X),write('D').
up(X) :- write('\e['),write(X),write('A').
down(X) :- write('\e['),write(X),write('B').

% symbol
symbol(I,R) :- NextR is R+1, symbol(NextR), location(2,I), write('->'), location(1,I).
symbol(2) :- !,location(2,2), write('  ').
symbol(R) :- !, 2 < R, location(2,R), write('  '), NextR is R-1, symbol(NextR).

% input
input(P,S,R) :-
    get_single_char(Input), !,
    proc_input(P,S,R,Input,N),
    (Input = 13, true; input(P,N,R)).

proc_input(P,S,_,13,S) :- !, proc(P,S).
proc_input(_,S,R,65,N) :- (3 =< S, N is S-1, symbol(N,R), !; N = S).
proc_input(_,S,R,66,N) :- (S =< R, N is S+1, symbol(N,R), !; N = S).
proc_input(_,S,_, _,S) :- !.

% proc
proc('main', 2) :- !, cls, location(1,1), reload.
proc('main', 3) :- !, cls, location(1,1), setting.
proc('main', 4) :- !, cls, location(1,1), reset_schedule.
proc('main', 5) :- !, cls, location(1,1), do_schedule.
proc('main', 6) :- !, cls, location(1,1), print_schedule.
proc('main', 7) :- !, cls, location(1,1), end.
proc('print', 2) :- !, cls, location(1,1), my_main(6).

% main
my_main :- my_main(2).
my_main(I) :-
    main_menu,
    symbol(I,6),
    input('main',I,6), !.

main_menu :- !,
    get_schedule_span(FromYear,FromMonth,FromDay,ToYear,ToMonth,ToDay),
    writef('スケジュール自動生成  (%t年%t月%t日 〜 %t年%t月%t日)', [FromYear,FromMonth,FromDay,ToYear,ToMonth,ToDay]),nl,
    writef('    リロード'), nl,
    writef('    期間設定'), nl,
    writef('    スケジュール初期化'), nl,
    writef('    スケジューリング'), nl,
    writef('    スケジュール表示'), nl,
    writef('    終わり').

% リロード
reload :-
    load,
    my_main(2).

% 期間設定
setting :-
    write('期間設定'), nl,
    write('  スケジューリング開始日を入力 [\'YYYY-MM-DD\'.]'), nl,
    read(StartTerm1),
    string_concat(StartTerm1, 'T00:00Z', StartTerm2),
    parse_time(StartTerm2, StartTimestamp),
    write('  スケジューリング終了日を入力 [\'YYYY-MM-DD\'.]'), nl,
    read(EndTerm1),
    string_concat(EndTerm1, 'T23:59Z', EndTerm2),
    parse_time(EndTerm2, EndTimeStamp),
    set_config('ScheduleFrom',StartTimestamp),
    set_config('ScheduleTo',EndTimeStamp),
    cls, location(1,1), my_main(3).

% スケジュール初期化
reset_schedule :-
    clear,
    cls, location(1,1), my_main(4).

% スケジューリング
do_schedule :-
    cls,
    solve_csp,
    apply_schedule,
    cls, location(1,1), my_main(5).
    
% スケジュール表示
print_schedule :-
    write('スケジュール'), nl,
    write('    戻る'), nl,
    forall(day(Y,M,D,W),(write('---------------------------------------------------------------'),nl,print_schedule(Y,M,D,W))),
    write('---------------------------------------------------------------'),nl,
    symbol(2,1),
    input('print',2,1).
print_schedule(Y,M,D,W) :-
    findall(schedule(date(Y,M,D,H,I,S,X1,X2,X3),Tid,Fixed),schedule(date(Y,M,D,H,I,S,X1,X2,X3),Tid,Fixed),Schedules),
    left(100),
    wstr(W,Wstr),writef('%t-%t-%t (%t)',[Y,M,D,Wstr]),nl,
    print_schedule(Schedules).
print_schedule([]) :- !.
print_schedule([Sc|Rest]) :-
    Sc = schedule(date(Y,M,D,H,I,S,_,_,_),Tid,Fixed),
    task(Tid,Description,ETP,_,_),
    date_time_stamp(date(Y,M,D,H,I,S,0,-,-),ST),
    ET is ST + ETP*60,
    stamp_to_time(ET,EH,EI,_),
    format(atom(StrTime),'~`0t~d~2+~|:~|~`0t~d~2+~|-~|~`0t~d~2+~|:~|~`0t~d~2+',[H,I,EH,EI]),
    writef('    %t -- (%t) %t',[StrTime,Tid,Description]),
    (Fixed, write(' (fixed)'), !; true), nl,
    print_schedule(Rest).

wstr(1,'Mon').
wstr(2,'Tue').
wstr(3,'Wed').
wstr(4,'Thu').
wstr(5,'Fri').
wstr(6,'Sat').
wstr(7,'Sun').

% 終わり
end :- save, !.

% go
go :- load, cls, location(1,1), prepare, my_main, !.
go :- write('異常終了.'), !.
