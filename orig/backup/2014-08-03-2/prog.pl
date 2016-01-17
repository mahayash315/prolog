

%
% [ タスクの記述 ]
%  ~~~~~~~~~~~~~~
% 記述フォーマット:
%   task(TaskId, Description, ETP, Deadline, [TaskId1, TaskId2, ..., TaskIdN])
%                                            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%                                                        └ dependent tasks
%
% * ETP = Estimated Time to Process : 推定所要時間 (min)
% * Deadline : この日時までに終わってないといけないという日時。
%              ex. date(2014,07,15,17,00,00,0,-,-)
%              ex. - (時間固定タスク or 締め切りなし)
% ---
% date(Y,M,D,H,Mn,S,Off,TZ,DST)
%    We call this term a date-time structure. The first 5 fields are integers expressing the year,
%    month (1..12), day (1..31), hour (0..23) and minute (0..59). The S field holds the seconds
%    as a floating point number between 0.0 and 60.0. Off is an integer representing the offset
%    relative to UTC in seconds, where positive values are west of Greenwich. If converted from
%    local time (see stamp_date_time/3), TZ holds the name of the local timezone. If the timezone
%    is not known, TZ is the atom -. DST is true if daylight saving time applies to the current
%    time, false if daylight saving time is relevant but not effective, and - if unknown or
%    the timezone has no daylight saving time.
% ---
%
%task(t1, 'task1', 10, date(2014,07,15,17,00,00,0,-,-), []).
%task(t2, 'task2', 10, date(2014,07,15,17,00,00,0,-,-), [t1]).
%task(t3, 'task3', 10, date(2014,07,15,17,00,00,0,-,-), []).
%task(t4, 'task4', 10, date(2014,07,15,17,00,00,0,-,-), [t2,t3]).
%task(t5, 'task5', 10, -, []).


%
% [ スケジュールの記述 ]
%  ~~~~~~~~~~~~~~~~~~
% 記述フォーマット:
%  schedule(StartDateTime, TaskId, IsFixed)
%schedule(date(2014,07,15,17,00,00,0,-,-), t5, true).

%
% * date から TimeStamp への変換:
%     date_time_stamp(date(...), Timestamp).
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

% count
count(Cond, Count) :- (aggregate_all(count, Cond, Count), !; Count is 0).

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
    told,
    tell('schedules.dat'),
    write('% schedule(startTime,tid,isFixed)\n\n'),
    writeSchedules,
    told, !.

writeTasks([]).
writeTasks([T|Rest]) :-
    write(T), write('.'), nl,
    writeTasks(Rest).
writeTasks :-
    (setof(task(X1,X2,X3,X4,X5), task(X1,X2,X3,X4,X5), Set); Set=[]),
    writeTasks(Set).
writeSchedules([]).
writeSchedules([S|Rest]) :-
    write(S), write('.'), nl,
    writeSchedules(Rest).
writeSchedules :-
    write('% static schedules:\n'),
    (setof(schedule(X1,X2,true), schedule(X1,X2,true), Set); Set=[]),
    writeSchedules(Set),
    write('% dynamic schedules:\n'),
    (setof(schedule(X1,X2,false), schedule(X1,X2,false), Set); Set=[]),
    writeSchedules(Set).
    

% clear
clear :- (retract(schedule(_,_,false)), clear; true), !.
clear_all :- (retract(schedule(_,_,_)), clear_all; true), !.


% setSchedule
set_schedule(Tid, Timestamp, Fix) :-
    % すでにエントリが存在していたら削除
    (schedule(_, Tid, _), retract(schedule(_,Tid,_)); true), !,
    % エントリを追加
    stamp_date_time(Timestamp, DateTime, 0),
    assert(schedule(DateTime, Tid, Fix)).

% check_dependents_done : 依存するすべてのタスクが時間 Timestamp において完了しているか確認する
check_dependents_done(_,[]).
check_dependents_done(Timestamp, [Tid|Rest]) :-
    current_predicate(schedule/3),
    schedule(ScheduledDateTime, Tid, _),
    date_time_stamp(ScheduledDateTime, ScheduledTimestamp),
    task(Tid,_,ETP,_,_),
    ScheduledTimestamp + (ETP * 60) =< Timestamp,
    check_dependents_done(Timestamp, Rest).

% is_valid(Timestamp, Task) : タスク Task を Timestamp に行っても締め切り前に終わる
%                            なおかつ、そのタスクが依存するタスクがすべて終わっている
is_valid(_, Tid) :- task(Tid,_,_,-,_).
is_valid(Timestamp, Tid) :-
    task(Tid,_,ETP,Deadline,DepTids),
    Deadline \== '-',
    date_time_stamp(Deadline, Stamp),
    Timestamp + (ETP * 60) =< Stamp,
    check_dependents_done(Timestamp, DepTids).

% Timestamp の時刻に固定されたタスクがあるか確認
find_fixed_task(Timestamp, Tid) :-
    schedule(StartDateTime, Tid, true),
    task(Tid,_,ETP,_,_),
    date_time_stamp(StartDateTime, Stamp),
    Stamp =< Timestamp,
    Timestamp =< Stamp + (ETP * 60).

% Timestamp の時刻に締め切り前の非固定タスクをすべて取ってくる
find_task_list(Timestamp, Tids) :-
    (setof(Tid, is_valid(Timestamp, Tid), Tids); Tids=[]), !.

% Schedule 一覧を取得
find_schedule_list(Tids) :-
    (setof(Tid, X1^X3^schedule(X1,Tid,X3), Tids); Tids=[]), !.

% リストの差分を取得
find_diff_set(_,[],[]).
find_diff_set([],_,[]).
find_diff_set([X|L1],L2,L) :-
    is_member(X,L2), !,
    find_diff_set(L1,L2,L).
find_diff_set([X|L1],L2,[X|L]) :-
    find_diff_set(L1,L2,L).

% まだ決まっていないタスク一覧を取得
remaining_tasks(Timestamp, Tids) :-
    % 有効なタスク一覧を取得
    find_task_list(Timestamp, ValidTids),
    write('validTids '), write(ValidTids), write('\n'),
    % すでに決まってるタスク一覧を取得
    find_schedule_list(ScheduledTids),
    write('scheduledTids '), write(ScheduledTids), write('\n'),
    % 有効なタスクからすでに決まっているタスクを除外
    find_diff_set(ValidTids, ScheduledTids, Tids).

% 各時間のタスク決め
determine(Timestamp, Tid) :-
    % 時間固定タスクがその時間にあったらそれに決定。
    find_fixed_task(Timestamp, Tid), !.
determine(Timestamp, Tid) :-
    % 時間固定タスクがその時間に無い場合
    remaining_tasks(Timestamp, RemainingTids),
    write('determine '), write(RemainingTids), write('\n'),
    % オークションで日付 Timestamp に行うタスクを決定
    determine_task(Timestamp, RemainingTids, Tid),
    % スケジュール決定
    set_schedule(Tid, Timestamp, false), !.

% 特定の時間 Timestamp について、自由に動かせるタスク Tasks からタスク Task を決定する
determine_task(Timestamp, Tids, Tid) :-
    bid_all(Timestamp, Tids, Prices),
    get_max(Tids, Prices, Tid, _).

% get_max
get_max([Tid], [Price], Tid, Price).
get_max([_|TRest], [Price|PRest], MaxTid, MaxPrice) :-
    get_max(TRest, PRest, MaxTid, MaxPrice),
    Price < MaxPrice, !.
get_max([MaxTid|TRest], [MaxPrice|PRest], MaxTid, MaxPrice) :-
    get_max(TRest, PRest, _, PrevMaxPrice),
    PrevMaxPrice =< MaxPrice, !.

bid_all(_,[],[]).
bid_all(Timestamp, [Tid|Rest], [Price|PRest]) :-
    bid_all(Timestamp, Rest, PRest),
    decide_bid_price(Timestamp, Tid, Price).

decide_bid_price(Timestamp, Tid, Price) :-
    task(Tid, _, _, _, DepTids),
    calc_enthusiasm(Timestamp, DepTids, Enthusiasm),
    calc_impatience(Timestamp, Tid, Impatience),
    Price is Enthusiasm + Impatience,
    write('decide_bid_price '), write(Tid), write(' '), write(Price), write('\n').
    
% calc_enthusiasm : 最近終えたタスクに依存するタスクほど高い熱望を持つという考えのもと、熱望を計算
calc_enthusiasm(_,[],0).
calc_enthusiasm(Timestamp, [Tid|Rest], Enthusiasm) :-
    calc_enthusiasm(Timestamp, Rest, TmpEnthusiasm),
    % タスク Tid を終えた時刻を取ってくる
    schedule(ScheduledDateTime, Tid, _),
    date_time_stamp(ScheduledDateTime, ScheduledTimestamp),
    task(Tid,_,ETP,_,_),
    FinishedTimestamp is ScheduledTimestamp + (ETP * 60),
    % 依存タスクを終えた時刻 FinishedTimestamp から、このタスクに対する熱望 Enthusiasm を計算
    Diff is Timestamp - FinishedTimestamp,
    write('calc_enthusiasm '), write(Tid), write(' '), write(Diff), write('\n'),
    Enthusiasm is TmpEnthusiasm + (1/Diff).

% calc_impatience : 締め切りに近いタスクほど高い焦りを持つという考えのもと、焦りを計算
calc_impatience(_, Tid, 0) :- task(Tid,_,_,-,_), !.
calc_impatience(Timestamp, Tid, Impatience) :-
    % Deadline を取ってくる
    task(Tid,_,ETP,Deadline,_),
    date_time_stamp(Deadline, DeadTimestamp),
    RemainingTime is DeadTimestamp - (Timestamp + (ETP*60)),
    write('calc_impatience '), write(Tid), write(' '), write(RemainingTime), write('\n'),
    Impatience is 1 / RemainingTime.






%
% - 条件の変更
%  - タスクの ETP が変わる
%   - ETP 増加 --> チャンク増加
%   - ETP 減少 --> チャンク減少
%  - タスクの数が変わる
%   - タスク増加
%   - タスク減少
%
%  .i.i.i.i.i.i.
% /プログラム構成\
% ^^^^^^^^^^^^^^
% 述語の説明:
%  - schedule
%  - task
%  - chunk
%  - cell(i, j, task_name, chunk_num)
%  - constraint
%
% 手法:
%  - 重み付きCSP (評価値が小さい方がいい)
%
% 入力:
%  - 何日分のスケジュールか(セルの列数)   ex.7日間
%  - タスクを入れる時間(セルの行数)　　   ex.09:00-17:00


% @ satisfy: タスクチャンクが制約を満たすか調べる
%  入力:
%   - タスク名　　 name
%   - チャンク番号 num
%  出力:
%   - 評価値　　　 eval　　　 
%  処理:
%    bagof(constraint(name,num,X3,X4), constraint(name,num,X3,X4), constraints),
%    eval = 0
%    for each constraint(name,num,cons,val) in constrains
%      eval += satisfy(name,num,cons,val)
%    return eval

conflicts(Tid, Cid, Weight) :-
    findall(constraint(Tid,Cid,Type,Val), constraint(Tid,Cid,Type,Val), Constraints),
    conflicts(Constraints, Weight).
conflicts([],0) :- !.
conflicts([C|Rest], Weight) :-
    conflicts(Rest, Weight1),
    C = constraint(Tid,Cid,Type,Val),
    (satisfy(Type,Tid,Cid,Val,Weight2), !, Weight is Weight1 + Weight2;
     Weight is Weight1 + 10000).

% @ satisfy 'dependent': タスクチャンクが他のタスクに依存する条件を満たすか調べる
%  入力:
%   - タスク名　　　　 name
%   - チャンク番号　　 num
%   - 依存するタスク名 dt_name
%  出力:
%   - 評価値　　　　　 eval
%  処理:
%    // 自チャンクのセルを見つける
%    cell(I, J, name, num)
%    // 依存するタスクのチャンクの大きさを調べる
%    chunk_size(dt_name, Size)
%    // 依存するタスクの最後のチャンクのセルを見つける
%    cell(S, T, dt_name, Size)
%    // 距離の計算
%    d = (I-S)*1000 + (J-T)
%    if (0 < d)
%      return d
%    else
%      return UNSATISFIED

satisfy('dependent', Tid, Cid, Dtid, Weight) :-
    chunk_size(Dtid,Dcid),
    cell(Mrow,Mcol,Tid,Cid),
    cell(Drow,Dcol,Dtid,Dcid),
    D is (Mcol - Dcol)*1000 + (Mrow - Drow),
    0 < D, Weight = D.

% @ satisfy 'sequential': タスクチャンクが連続している
%  入力:
%   - タスク名　　　　 name
%   - チャンク番号　　 num
%  出力:
%   - 評価値　　　　　 eval
%  処理:
%    // 自チャンクのセルを見つける
%    cell(I, J, name, num)
%    // 一つ前のチャンクのセルを見つける
%    cell(S, T, name, num-1)
%    if (S == I)
%      if (T+1 == J)
%        return 0
%      else UNSATISFIED
%    else if (S+1 == I)
%      if (J == 1)
%        return 10
%    else
%      return UNSATISFIED

satisfy('sequential', Tid, Cid, _, Weight) :-
    Pcid is Cid - 1,
    cell(Crow,Ccol,Tid,Cid),
    cell(Prow,Pcol,Tid,Pcid),
    get_cell_size('row',RowSize),
    (Prow  <  RowSize, Pcol =:= Ccol, Prow + 1 =:= Crow, !, Weight is 0;
     Prow =:= RowSize, Pcol + 1 =:= Ccol, Crow =:= 1, Weight is 10).

% @ prepare_chunks: タスクをタスクチャンクに区切る
%  入力:
%   - セルの単位(分): unit
%  処理:
%    clear_all_chunks()
%    for each task t
%      num = ceil(t.ETP / unit) // 分割数を計算
%      last_len = t.ETP % unit  // 最後の分割の長さ
%      assert(chunk_size(t.name, num))               // chunk_size を知識ベースに入れる
%      if t.dependent_tasks exists
%        for each depenent_task dt
%          assert(constraint(t.name, i, 'dependent', dt.name)) // 他のタスクに依存するという制約
%      for i = 1 : num-1
%        assert(chunk(t.name, i, unit))                        // chunk を知識ベースに入れる
%        assert(constraint(t.name, i, 'sequential', -))        // 前のチャンクに続くという制約
%      assert(chunk(t.name, num, last_len))                    // 最後の chunk を知識ベースに入れる
%      if 1 < num
%        assert(constraint(t.name, num, 'sequential', -))      // 前のチャンクに続くという制約
%

prepare_chunks :-
    (retractall(chunk(_,_,_)), !; true),
    (retractall(constraint(_,_,_,_)), !; true),
    forall(task(Tid,_,ETP,_,Deps),(
	       ChunkSize is ceil(ETP / 10),
	       (ETP mod 10 =:= 0, LastLen is 10, !; LastLen is ETP mod 10),
	       assert(chunk_size(Tid,ChunkSize)),
	       (ChunkSize =:= 1, assert(chunk(Tid,1,LastLen));
		assert(chunk(Tid,1,10)),
		To is ChunkSize-1, forall(between(2,To,I), (assert(chunk(Tid,I,10)), assert(constraint(Tid,I,'sequential',-)))),
		assert(chunk(Tid,ChunkSize,LastLen))),
	       prepare_chunks('dependent',Tid,Deps)
	  )).
prepare_chunks('dependent',_,[]).
prepare_chunks('dependent',Tid,[Dep|Rest]) :-
    assert(constraint(Tid,1,'dependent',Dep)),
    prepare_chunks('dependent',Tid,Rest), !.



%
% @ process: 一連の処理を行う
%  入力:
%   - セルの列数
%   - セルの行数
%   - タスクチャンク
%
%  CSP の定式化
%  ~~~~~~~~~~~
%   変数　　: セル
%   ドメイン: タスクチャンク
%   制約　　: 
%             - チャンクが重複しない
%             - 
%
% +--+--+--+--+--+--+--+
% |  |  |  |  |  |  |  |
% +--+--+--+--+--+--+--+
% |  |  |  |  |  |  |  |
% +--+--+--+--+--+--+--+
% |  |  |  |  |  |  |  |
% +--+--+--+--+--+--+--+
% |  |  |  |  |  |  |  |
% +--+--+--+--+--+--+--+
% |  |  |  |  |  |  |  |
% +--+--+--+--+--+--+--+
% |  |  |  |  |  |  |  |
% +--+--+--+--+--+--+--+
% |  |  |  |  |  |  |  |
% +--+--+--+--+--+--+--+
%
%
%
%  処理:
%    prepare_cells()                  // セルをすべて削除し、必要な分のセル(述語 cell(...))をアサート
%    prepare_chunks()                 // タスクをタスクチャンクに分割する
%    apply_schedule()                 // 現在の schedule をセルに反映
%    solve_csp()                      // 重み付きCSP問題を解く
%
%

set_cell(Row,Col,Tid,Cid) :-
    (retractall(cell(Row,Col,_,_)), !; true),
    assert(cell(Row,Col,Tid,Cid)).
swap_cell(FromRow,FromCol,ToRow,ToCol) :-
    cell(FromRow,FromCol,Tid1,Cid1),
    cell(ToRow,ToCol,Tid2,Cid2), !,
    set_cell(FromRow,FromCol,Tid2,Cid2),
    set_cell(ToRow,ToCol,Tid1,Cid1).
    

count_conflicts_by_col(Conflicts) :-
    get_cell_size('row',RowSize),
    get_cell_size('col',ColSize),
    setof(Row,between(1,RowSize,Row),Rows),
    setof(Col,between(1,ColSize,Col),Cols),
    count_conflicts_by_col(Rows, Cols, Conflicts).
count_conflicts_by_col(_,[],[]) :- !.
count_conflicts_by_col(Rows, [Col|Rest1], [Count|Rest2]) :-
    count_conflicts_by_col(Rows,Rest1,Rest2),
    count_conflicts_by_col_row(Rows,Col,Count).
count_conflicts_by_col_row([],_,0) :- !.
count_conflicts_by_col_row([Row|Rest],Col,Count) :-
    count_conflicts_by_col_row(Rest,Col,Count1),
    cell(Row,Col,Tid,Cid),
    (Tid = '-', Cid = '-', !, Count is Count1;
     conflicts(Tid,Cid,Count2), Count is Count1 + Count2).

count_conflicts_at_col(Col,Conflicts) :-
    get_cell_size('row',RowSize),
    bagof(R,between(1,RowSize,R),Rows),
    count_conflicts_at_col(Rows,Col,Conflicts).
count_conflicts_at_col([],_,[]) :- !.
count_conflicts_at_col([Row|Rest1],Col,[Count|Rest2]) :-
    count_conflicts_at_col(Rest1,Col,Rest2),
    cell(Row,Col,Tid,Cid),
    (Tid = '-', Cid = '-', !, Count is 0;
     conflicts(Tid,Cid,Count)).

count_moved_conflicts(Row,Col,Counts) :-
    get_cell_size('row',RowSize),
    bagof(R,between(1,RowSize,R),Rows),
    count_moved_conflicts_by_col(Row,Col,Rows,Counts).
count_moved_conflicts(Row,Col,[Row|Rest1],[Count|Rest2]) :- !,
    count_moved_conflicts(Row,Col,Rest1,Rest2),
    cell(Row,Col,Tid,Cid),
    (Tid = '-', Cid = '-', !, Count is 0;
     conflicts(Tid,Cid,Count)).
count_moved_conflicts(Row1,Col,[Row2|Rest1],[Count|Rest2]) :-
    count_moved_conflicts(Row1,Col,Rest1,Rest2),
    swap_cell(Row1,Col,Row2,Col),
    cell(Row1,Col,Tid,Cid),
    (Tid = '-', Cid = '-', !, Count is 0;
     conflicts(Tid,Cid,Count)),
    swap_cell(Row1,Col,Row2,Col).

for_all([], _) :- !.
for_all([X|R], V) :- not(not(X = V)), for_all(R).

find_max(List,MaxPtr,MaxVal) :- find_max(List,1,MaxPtr,MaxVal).
find_max([X],_,-1,X) :- !.
find_max([X|R],Ptr,MaxPtr,Val) :-
    Ptr1 is Ptr + 1, find_max(R,Ptr1,MaxPtr1,Val1),
    (Val1 < X, !, MaxPtr = Ptr, Val = X; MaxPtr = MaxPtr1, Val = Val1).

find_min(List,MinPtr,MinVal) :- find_min(List,1,MinPtr,MinVal).
find_min([X],_,-1,X) :- !.
find_min([X|R],Ptr,MinPtr,Val) :-
    Ptr1 is Ptr + 1, find_max(R,Ptr1,MinPtr1,Val1),
    (X < Val1, !, MinPtr = Ptr, Val = X; MinPtr = MinPtr1, Val = Val1).


select_move_cell(Row,Col) :-
    select_move_col(Col,_),
    select_move_row(Row,Col,Conf),
    0 < Conf.

select_move_col(Col,Conf) :-
    count_conflicts_by_col(Confs),
    find_max(Confs,Col,Conf).

select_move_row(Row,Col,Conf) :-
    count_conflicts_at_col(Col, Confs),
    find_max(Confs,Row,Conf).

solve_loop(EndItr) :-
    % 動かすセルの決定
    select_move_cell(Row,Col),
    count_moved_conflicts(Row,Col,Counts).
    
    
    
	   

solve_csp :-
    (get_config('MaxItr',MaxItr), !; MaxItr is 10000),
    init_csp,
    solve_loop(MaxItr).




get_config(Key,Value) :-
    current_predicate(my_config/2),
    my_config(Key,Value).

get_schedule_span(ScheduleFrom, ScheduleTo) :-
    (get_config('ScheduleFrom',ScheduleFrom), !; get_time(ScheduleFrom)),
    (get_config('ScheduleTo',ScheduleTo), !; ScheduleTo is ScheduleFrom + 604800).
get_schedule_span(FromYear,FromMonth,FromDay,ToYear,ToMonth,ToDay) :-
    get_schedule_span(From, To),
    stamp_date_time(From, DateFrom, 'UTC'),
    stamp_date_time(To, DateTo, 'UTC'),
    DateFrom = date(FromYear, FromMonth, FromDay,_,_,_,_,_,_),
    DateTo = date(ToYear, ToMonth, ToDay,_,_,_,_,_,_).

get_day_span(DayFrom, DayTo) :-
    (get_config('DayFrom',DayFrom), !; DayFrom = 800),
    (get_config('DayTo',DayTo), !; DayTo = 900). % FIXME

get_cell_size('row',RowSize) :-
    get_day_span(DayFrom,DayTo),
    RowSize is (DayTo - DayFrom) / 10.
get_cell_size('col',ColSize) :-
    count(day(_,_,_,_), ColSize).

day_exists(Year,Month,Day,DayOfTheWeek) :-
    (is_member(Month, [1,3,5,7,9,11]), between(1,31,Day);
     is_member(Month, [4,6,8,10,12]), between(1,30,Day);
     Month = 2, ((Year mod 4 =:= 0, Year mod 100 =\= 0;  is_member(Year mod 900, [200, 600]), between(1,30,Day));
		 between(1,29,Day))),
    day_of_the_week(date(Year,Month,Day),DayOfTheWeek), !.
    


prepare :-
    prepare_days,
    prepare_cells,
    prepare_chunks.

prepare_days :-
    (retractall(day(_,_,_,_)); true), !,
    get_schedule_span(FromYear,FromMonth,FromDay,ToYear,ToMonth,ToDay),
    forall(prepare_days(FromYear,FromMonth,FromDay,ToYear,ToMonth,ToDay,Year,Month,Day,DayOfTheWeek),
	   assert(day(Year,Month,Day,DayOfTheWeek))).
    
prepare_days(FromYear,FromMonth,FromDay,ToYear,ToMonth,ToDay,Year,Month,Day,DayOfTheWeek) :-
    between(FromYear,ToYear,Year),
    (FromYear =:= Year, Year =:= ToYear, prepare_days(FromMonth,FromDay,ToMonth,ToDay,Year,Month,Day,DayOfTheWeek);
     FromYear =:= Year, Year  <  ToYear, prepare_days(FromMonth,FromDay,     13,ToDay,Year,Month,Day,DayOfTheWeek);
     FromYear  <  Year, Year  <  ToYear, prepare_days(        0,FromDay,     13,ToDay,Year,Month,Day,DayOfTheWeek);
     FromYear  <  Year, Year =:= ToYear, prepare_days(        0,FromDay,ToMonth,ToDay,Year,Month,Day,DayOfTheWeek)).
prepare_days(FromMonth,FromDay,ToMonth,ToDay,Year,Month,Day,DayOfTheWeek) :-
    between(FromMonth,ToMonth,Month), between(1,12,Month),
    (FromMonth =:= Month, Month =:= ToMonth, prepare_days(FromDay,ToDay,Year,Month,Day,DayOfTheWeek);
     FromMonth =:= Month, Month  <  ToMonth, prepare_days(FromDay,   32,Year,Month,Day,DayOfTheWeek);
     FromMonth  <  Month, Month  <  ToMonth, prepare_days(      0,   32,Year,Month,Day,DayOfTheWeek);
     FromMonth  <  Month, Month =:= ToMonth, prepare_days(      0,ToDay,Year,Month,Day,DayOfTheWeek)).
prepare_days(FromDay,ToDay,Year,Month,Day,DayOfTheWeek) :-
    between(FromDay,ToDay,Day), between(1,31,Day),
    day_exists(Year,Month,Day,DayOfTheWeek).

prepare_cells :-
    (retractall(cell(_,_,_,_)), !; true),
    get_cell_size('row',RowSize),
    get_cell_size('col',ColSize),
    forall(between(1,RowSize,Row),
	   forall(between(1,ColSize,Col),
		  (assert(cell(Row,Col,-,-)), !; true))).



print_cells :-
    get_cell_size('row',RowSize),
    get_cell_size('col',ColSize),
    forall(between(1,RowSize,Row),
	   forall(between(1,ColSize,Col),
		  (print_cell(Row,Col), !; true))).
print_cell(Row,Col) :-
    cell(Row,Col,-,_), !,
    X is Col , Y is 3 + integer(Row / 6),
    location(X,Y),
    write('.').
    %write(X),write(','),write(Y),write(' '),write('. '),nl.
print_cell(Row,Col) :-
    cell(Row,Col,Tid,_), !,
    X is Col , Y is 3 + integer(Row / 6),
    location(X,Y),
    write(Tid).
    %write(X),write(','),write(Y),write(' '),write(Tid),nl.
    






solve :-
    
















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
symbol(I,R) :-
    NextR is R+1,
    symbol(NextR),
    location(2,I), write('->'),
    location(1,I).
symbol(2) :- !,
    location(2,2), write('  ').
symbol(R) :- !,
    2 < R,
    location(2,R), write('  '),
    NextR is R-1,
    symbol(NextR).

% input
input(P,S,R) :-
    get_single_char(Input), !,
    proc_input(P,S,R,Input,N),
    (Input = 13, true; input(P,N,R)).

proc_input(P,S,_,13,S) :- !, proc(P,S).
proc_input(_,S,R,65,N) :- (3 =< S, N is S-1, symbol(N,R), !; N = S).
proc_input(_,S,R,66,N) :- (S =< R, N is S+1, symbol(N,R), !; N = S).
proc_input(_,S,_, _,S) :- !.

% main
my_main :- my_main(2).
my_main(I) :-
    main_menu,
    symbol(I,5),
    input('main',I,5), !.

main_menu :- !,
    write('スケジュール自動生成  '),
    get_schedule_span(FromYear,FromMonth,FromDay,ToYear,ToMonth,ToDay),
    write('('),
    write(FromYear),write('年'),write(FromMonth),write('月'),write(FromDay),write('日'),write('〜'),
    write(ToYear),write('年'),write(ToMonth),write('月'),write(ToDay),write('日'),
    write(')'), nl,
    write('    リロード'), nl,
    write('    期間設定'), nl,
    write('    スケジューリング'), nl,
    write('    スケジュール表示'), nl,
    write('    終わり').

proc('main', 2) :- !, cls, location(1,1), reload.
proc('main', 3) :- !, cls, location(1,1), setting.
proc('main', 4) :- !, cls, location(1,1), do_schedule.
proc('main', 5) :- !, cls, location(1,1), print_schedule.
proc('main', 6) :- !, cls, location(1,1), end.


% リロード
reload :-
    load,
    my_main(2).

% 期間設定
setting :-
    write('期間設定'), nl,
    write('  スケジューリング開始日を入力 [\'YYYY-MM-DD\'.]'), nl,
    read(StartTerm),
    parse_time(StartTerm, StartTimestamp),
    write('  スケジューリング終了日を入力 [\'YYYY-MM-DD\'.]'), nl,
    read(EndTerm),
    parse_time(EndTerm, EndTimeStamp),
    (retractall(my_config('ScheduleFrom',_)); true),
    assert(my_config('ScheduleFrom',StartTimestamp)),
    (retractall(my_config('ScheduleTo',_)); true),
    assert(my_config('ScheduleTo',EndTimeStamp)),
    prepare,
    cls, location(1,1), my_main(3).
    
    

% スケジューリング
do_schedule :-
    cls,
    % TODO
    my_main.
    
% スケジュール表示
print_schedule :-
    write('スケジュール'), nl,
    write('    戻る'), nl,
    print_cells,
    symbol(2,1),
    input('print',2,1).

proc('print', 2) :- !, cls, location(1,1), my_main(5).

% 終わり
end :- save, !.

% go
go :- load, cls, location(1,1), prepare, my_main, !.
go :- write('異常終了.'), !.
