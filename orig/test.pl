entry(1,a).
entry(1,b).
entry(1,date(2014,5,6,0,0,0,0,-,-)).

task(t1, 'task1', 10, date(2014,07,15,17,00,00,0,-,-), []).
task(t2, 'task2', 10, date(2014,07,15,17,00,00,0,-,-), [t1]).
task(t3, 'task3', 10, date(2014,07,15,17,00,00,0,-,-), []).
task(t4, 'task4', 10, date(2014,07,15,17,00,00,0,-,-), [t2,t3]).
task(t5, 'task5', 10, -, []).

is_valid(_, Tid) :- task(Tid,_,_,-,_).
is_valid(Timestamp, Tid) :-
    task(Tid,_,ETP,Deadline,DepTids),
    Deadline \== '-',
    date_time_stamp(Deadline, Stamp),
    Timestamp =< Stamp + (ETP * 60).
