/*
自由課題レポート最終版 (〆切 8月 8日)
提出 8月 6日    by 24115113 林 政行


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
Remaining Iteration: 9965, Eval = 704.04, DupCount=3, SATemp=0.47401398881485163
[p(51.0,t4,5),p(50.6,t3,3),p(50.5,t3,4),p(50.5,t2,3),p(50.2,t4,4),p(26.119999999999997,t4,1)]999997,t4,1)](25.85,t4,1)](25.25,t4,1)]000003,t4,1)]

choose cell to move: (t4-5) [20,5] (P=51.0)

                 1         2         3         4         5         6         7    
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

[ 9966] moving [36,3] -> [30,3], (FromP=50.6, Cost=-50.6)
---------------------------------------------------------------------------------


    　スケジュール生成のために制約充足問題を局所探索によって解くが、その際に
    上記のような実行経過が表示される。

    　この途中経過で表示されている内容は、以下のようになっている

    　　１行目
           Remaining Iteration: 9965, Eval = 704.04, DupCount=3, SATemp=0.47401398881485163
           ~~~~~~~~~~~~~~~~~~~~~~~~~  ~~~~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~~~~~~~~~~~~~~~~~
                最大残りループ回数        現在の評価値       │         現在のSAの温度 (0〜1)
                　　　　　　　　　        　　　　　　       │
                　　　　　　　　　        　　　　　　       └評価値が変化していないとき増えるカウンタの値
    　　　　　　※ SA = Simulated Annealing

    　　２行目
    　　　　[p(51.0,t4,5),p(50.6,t3,3) ... ]

    　　　制約を満たしていないセル（タスクチャンク）の、評価値に与える影響値が多い順にソートされたリスト
    　　　このリストから SA の温度が高いとき程ランダムに、移動させるセルを選択する

    　　５行目
    　　　　choose cell to move: (t4-5) [20,5] (P=51.0)

    　　　選択した移動させるセル（タスクチャンク）と、それが評価値に与える影響値 P (CSPの重み)

    　　７行目以降
    　　　　現在のセル一覧が表示される。

                 -     <-- これはタスクチャンクを含まないセルを示す
    　　　　   [t4-1]   <-- これはタスクチャンク（TaskId t4 の 1 番目のチャンク）が当てられたセルを示す
               <t4>    <-- これはタスク（TaskId t4）の締切を示す

    　　　　また、移動対象のセルの周辺には局所探索の結果得られる、そのセルに移動した際に全体の評価値与える
    　　　　相対的なコストが表示される。

    　　最後の行
    　　　　移動対象セルの移動先と、移動した際に与える相対的なコストが表示される。このコストが負か0のときだけ
    　　　　移動し、そうでなければ移動しない。



    　実行経過を見ていると、ループが進むにつれ、現在の評価値 Eval が減っていき、Simulated Annealing の
    温度 SATemp も下がっていくことが見て取れる。この Eval が 0 になる、すなわち制約が充足されたときには
    解を求めるループを抜け、スケジューリング完了となる。ただ、後に考察で述べるが、重みの設定が上手くできず、
    制約を満たしているときに評価値が 0 にならない時もあるようで、この条件だけでは無限ループになってしまう
    ので、評価値が変化しないループが 100 回続いた場合も制約が満たされたと判断してループを抜けるようにした。

    　ただし、Remaining Iteration が 0 以下になった場合には、解が見つからなかったと判断する。この場合、
    異常終了と表示されて終了してしまう。




    　制約を満たす解が見つかると、以下のようにスケジューリング結果が表示される。


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


    　スケジューリングの動作の振る舞いは前述のようになっている。




    　スケジューリングを行う範囲を少なくすることもできる。
    具体的には、prolog のコンソール上で次の関数を実行する


 < スケジュール範囲の制限 >
---------------------------------------------------------------------------------
?- set_config('DayFrom',0900).
true.

?- set_config('DayTo',1200).
true.
---------------------------------------------------------------------------------

    すなわち、上記のようにして、スケジューリングを行う一日の開始時間と終了時間を
          0900 ( 09:00 ) 〜 1200 ( 12:00 )
    と制限することで、動作途中の縦方向の表示を抑えることができる。




    　上記スケジューリングの結果では、各セルとタスクチャンクの対応が示されているが、
    それらからスケジュールに置き換えた結果は、メインメニューの 5 つ目の項目
    「スケジュール表示」で見ることができる。
     　（※タスクチャンクが続かなかった場合は、そのタスクのスケジュールは
     　　　1 番目のタスクチャンクの開始日時とするようになっている）
    　
---------------------------------------------------------------------------------
(実行例): スケジュールの表示
---------------------------------------------------------------------------------
スケジュール
 -> 戻る
---------------------------------------------------------------
2014-8-6 (Wed)
---------------------------------------------------------------
2014-8-7 (Thu)
    09:00-09:22 -- (t2) task2
---------------------------------------------------------------
2014-8-8 (Fri)
    09:00-09:45 -- (t3) task3
    10:00-10:50 -- (t4) task4
---------------------------------------------------------------
2014-8-9 (Sat)
---------------------------------------------------------------
2014-8-10 (Sun)
---------------------------------------------------------------
2014-8-11 (Mon)
---------------------------------------------------------------
2014-8-12 (Tue)
    09:00-09:10 -- (t5) task5
---------------------------------------------------------------
---------------------------------------------------------------------------------


    　なお、この部分はあまり作り込んでいないので、実際のスケジュールは schedules.dat を
    見た方が良いかもしれない。



    　メインメニューの「終わり」の項目を進むと、メニューを終了して prolog コンソールに
    戻ることができる。このとき、スケジュール結果を schedules.dat に書き込むので、
    「終わり」を押して終わることで、次回プログラム起動時に今回の結果を引き継ぐことができる。




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
    - 磯村 厚誌、 伊藤 孝行、 大囿 忠親、 新谷 虎松 (2003)
      「ナーススケジューリングシステムにおける動的重み付きCSPに基づく再スケジューリング機能の実装」
      情報処理学会第66回全国大会

    - 「Stochastic Hill Climbing - Clever Algorithms: Nature-Inspired Programming Recipes」
       <http://www.cleveralgorithms.com/nature-inspired/stochastic/hill_climbing_search.html>
       (2014年8月6日 確認)

    - 「Min-Conflicts algorithm - Wikipedia the free encyclopedia」,
       <http://en.wikipedia.org/wiki/Min-conflicts_algorithm> (2014年8月6日 確認)
    
    - 「SWI-Prolog」
       <http://www.swi-prolog.org/> (2014年8月6日 確認)


      
(3) アルゴリズム／データ構造の説明

  [ アルゴリズムの説明 ]
  ~~~~~~~~~~~~~~~~~~~
    　今回実装したプログラムでは、タスクからスケジュールの生成を行う処理を、重み付き CSP (Valued CSP, VCSP) に変換し、
　　それを解くことで実現している。VCSP は、通常の制約充足問題の各制約に重みを加えたもので、

         P = (X,D,C)       X: 変数,  D: 値域,  C: 制約

    として与えられる CSP に、評価構造 S と評価関数φ を加えた

        VP = (X,D,C,S,φ)  X: 変数,  D: 値域,  C: 制約,  S: 評価構造,  φ: 評価関数

    という形で表現できる。

      今回の問題を VCSP に落とし込むために、変数として扱う単位「セル」と、値として用いる単位「タスクチャンク」を作った。
    セルはスケジューリング期間の日時を 10 分ごとに区切った 10 分間の時間とし、タスクチャンクはタスクを、そのタスクを終える
    までに掛かる時間について 10 分ごとに区切り、分割したとき、その1つの分割のこととした。従って、変数セルがタスクチャンクを
    値として持ち、セルの間に制約を設けることで CSP に落とし込むことにした。

    　また、評価構造として、次のような制約についての評価値（重み）を導入した
         'deadline'    : 締切よりも前にタスクを終えるための制約
         'dependent'   : 依存タスクよりも後で、かつなるべく近くにタスクを開始するための制約
         'sequential'  : タスクの分割単位タスクチャンクがなるべく連続して存在するための制約
         'fixed'       : 固定スケジュールが必ず生成スケジュールに反映されるための制約
         'soft_fixed'  : 動的スケジュールが前回の場所になるべくための制約
    その上で、評価関数は通常の加算を用いた。
      

      この VCSP を解くために、Min-Conflicts, Stochastic Hill Climbing に似たアルゴリズムを用い、具体的に次のようにして
    解いている。

      [solve_loop]
           input  : 最大移動数 MaxItr , VCSP
           output : VCSP の解 Solution

         SATemp <-- 1
         for itr < MaxItr
            現在の評価値を計算し、評価値 =< 0 ならループを抜ける;
            SATemp を少し下げる
            MoveFrom <-- select_move_cell(); // 制約を満たしていない変数(セル)の中から、ランダムに選択
            MoveTo <-- decide_move_to(); // セル MoveFrom の周りを局所探索し、できるだけ評価値が低くなるセルを選択
            if 移動したときの評価値の変化量 =< 0
                swap_cell(MoveFrom,MoveTo);（セル MoveFrom と MoveTo を入れ替える）

    この中でも、制約を満たしていない変数(セル)の中からランダムに変数を選択する際、および移動先を選ぶ際に、Simulated Annealing
    の方法を用いて、ループの序盤は温度 (SATemp) を高くすることでできるだけランダムに値を選び、ループが進むにつれて温度を低くする
    ことで、前者ではできるだけ評価値に与える影響度（制約違反の重み）が高い変数を、後者ではできるだけ評価値が小さくなる移動先を選ぶ
    ようにしている。この Simulated Annealing を使うことで、できるだけ局所解でなく最適解を求められるようにした。

            
            

  [ データ構造の説明 ]
  ~~~~~~~~~~~~~~~~~
    　このプログラムで VCSP を解くために用いてるデータ構造の、セル cell とタスクチャンク chunk に関して説明する。
    セルはスケジューリング期間を、10分ごとに区切ったとき、その1つの単位のことを差し、次のような述語で記述される:
        cell(Row,Col,Tid,Cid)
    このとき Row は行、Colは列を差し、スケジューリング期間内の Col 日目の Row 番目のセルを表す。また、このセルに
    タスクチャンクを当てはめることで、Col 日目の Row 番目の時間にそのタスクチャンクを実行するスケジュールが入っている
    ことを表す。次にそのタスクチャンクの述語を示す:
        chunk(Tid,Cid,Length)
    この Tid はタスク ID で、タスクの定義ファイルで定義されている TaskId と同じであり、Cid はタスクを10分ごとに区切った
    ときに、何番目の分割になるのかを表す整数である。Length はそのチャンクの長さ（分; 最大10分）を表す。

    　VCSP で用いる制約は次のような述語で表される:
        constraint(Tid,Cid,Type,Data)
    このとき、Tid,Cid はタスクチャンクを表す ID で、Type が制約の種類であり、Data は制約先を表すための項目で、cell(Row,Col,_,_)
    または chunk(Tid,Cid,_) のいずれかが格納されている。cell(_,_,Tid,Cid) が制約を満たしていないときに与える重みは、この
    constraint(Tid,Cid,Type,Data) から制約の種類 Type と制約先 Data を見ることで、与えられる。



      
(4) 述語の説明

  [ 基本的な述語 ]
  ~~~~~~~~~~~~~~
    - conc(L1,L2,L)
        リスト L1, L2 を結合したリストが L という関係を示す述語
    - is_member(X,L)
        リスト L に要素 X が含まれるという関係を示す述語
    - nth(L,Index,X)
        リスト L の Index 番目の要素 X を取り出す関数 ( Index = 0 〜 Lの大きさ-1 )
    - count(Cond, Count)
        述語 Cond の数を数え、Count に入れる関数
    - step(Low,High,Step,Int)
        Low から High までの整数を Step ずつ増やした値 Int を得る Generator
    - sum(L,Sum)
        リスト L の全要素の合計を計算し、Sum に入れる関数
  

  [ プログラムの動作に必要な述語 ]
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    - load
        タスク定義ファイル tasks.dat, スケジュール定義ファイル schedules.dat から定義を読み込む関数
        この処理のために使う、次の関数が定義されているが、重要でないため説明を省略する
          - retractAllTasks
          - retractAllSchedules
          - readTasks
          - readSchedules
          - procReadTasks
          - procReadSchedules
    - save
        タスク定義ファイル tasks.dat, スケジュール定義ファイル schedules.dat に現在の定義を保存する関数
        この処理のために使う、次の関数が定義されているが、重要でないため説明を省略する
          - writeTasks
          - writeSchedules
    - clear
        生成された動的スケジュールを削除する関数
    - clear_all
        静的スケジュールを含めてすべてのスケジュールを削除する関数
    - set_config(Key,Value)
        設定項目 Key の値を Value に設定する関数
    - get_config(Key,Value)
        設定項目 Key の値 Value を取得する関数
    - day_exists(Year,Month,Day,DayOfTheWeek)
        修正ユリウス暦カレンダーに Year 年 Month 月 Day 日が存在する場合は true, しない場合は false を返す
        関数。存在する場合は週の曜日 DayOfTheWeek が具体化される。
    - get_schedule_span(ScheduleFrom,ScheduleTo)
        スケジューリングを行う期間（日付）の開始、終了日のタイムスタンプを取得する関数
    - get_schedule_span(FromYear,FromMonth,FromDay,ToYear,ToMonth,ToDay)
        スケジューリングを行う期間（日付）の開始、終了日の日付を取得する関数
    - get_day_span(DayFrom,DayTo)
        スケジューリングを行う時間（一日の時間）の開始、終了時を ':' を省略した整数で取得する関数
    - get_cell_size(Key,Size)
        解を見つけるために使う cell の大きさを返す関数。Keyは 'row'（行）か 'col'（列）のいずれか。
    - stamp_to_date(Timestamp,Y,M,D)
        タイムスタンプの表す日付を取得する関数
    - stamp_to_time(Timestamp,H,I,S)
        タイムスタンプの表す時刻を取得する関数
    - set_schedule(Tid,Timestamp,Fix)
        スケジュールを表す述語 schedule(Timestamp,Tid,IsFixed) をアサートし、スケジュールを設定する関数
    - set_cell(Row,Col,Tid,Cid)
        セルを表す述語 cell(Row,Col,Tid,Cid) をアサートし、セルを設定する関数
    - swap_cell(FromRow,FromCol,ToRow,ToCol)
        セル cell(FromRow,FromCol,_,_) と cell(ToRow,ToCol,_,_) をスワップさせる（保持する Tid, Cidを入れ替える）関数
    - find_max(L,Max)
        リスト L の最大値 Max を取得する関数
    - find_min(L,Min)
        リスト L の最小値 Min を取得する関数
    - find_day(FromYear,FromMonth,FromDay,ToYear,ToMonth,ToDay, ...)
        日を表す述語 day(Year,Month,Day,DayOfTheWeek) を生成するために使う関数
    - count_rows(FromTime, ToTime, RowSize)
        ':' を省略した整数で記述された時間 FromTime と ToTime の間に存在するセルの数を数える関数
    - count_days(Y1,M1,D1,Y2,M2,D2,Count)
       Y1年M1月D1日 から Y2年M2月D2日 までの間に存在する日の数 Count を数える関数
    - stamp_to_cell(Timestamp,Row,Col)
       タイムスタンプが示すセル cell(Row,Col,_,_) を取り出すための関数
    - cell_to_stamp(Row,Col,Timestamp)
       セル cell(Row,Col,_,_) の始まりの時刻のタイムスタンプを取得する関数
    - cell_distance(Row1,Col1,Row2,Col2,D)
       セル cell(Row1,Col1,_,_) とセル cell(Row2,Col2,_,_) の距離（時間的な距離）が D であるという関係を示す述語(かつGenerator)


  [ CSP 関連の述語 ]
  ~~~~~~~~~~~~~~~~~
    - eval(Eval)
       現在の評価値を計算する関数
    - penalty_val(Tid,Cid,P)
       タスク Tid の Cid 番目のタスクチャンクが評価値に与える影響値（CSPの重み）P を求める関数。制約充足している場合は P=0 とする。
    - penalty(Tid,Cid,P)
       タスク Tid の Cid 番目のタスクチャンクが評価値に与える影響値（CSPの重み）P を求める関数。制約充足している場合は false を返す。
    - penalty(Type,Tid,Cid,Data,Weight)
       タスク Tid の Cid 番目のタスクチャンクが評価値に与える影響値（CSPの重み）Weight を求める関数。
       Type は制約の種類で、
         'deadline'    : 締切よりも前にタスクを終えるための制約
         'dependent'   : 依存タスクよりも後で、かつなるべく近くにタスクを開始するための制約
         'sequential'  : タスクの分割単位タスクチャンクがなるべく連続して存在するための制約
         'fixed'       : 固定スケジュールが必ず生成スケジュールに反映されるための制約
         'soft_fixed'  : 動的スケジュールが前回の場所になるべくための制約
       のどれかの値であり、それぞれの制約に合わせた CSP の重みを計算し、Weight に入れる。
    - prepare
       タスクの定義から CSP に落とし込む関数。次に挙げる関数を含む
         - prepare_days        : スケジューリング期間の日を表す述語を生成する。セルの生成に使う。
         - prepare_cells       : セルを生成する
         - prepare_chunks      : タスクを 10 分ごとに区切り、タスクチャンクに分割する
         - prepare_constraints : 各タスクの定義から制約を作る
    - apply_schedule
       CSP で使うセルからスケジュールを作る関数。
    - init_csp
       CSP を解くための初期値を設定する関数。
    - select_move_cell(SATemp,Lrow,Lcol,Row,Col,P,Pcount)
       制約を満たしていないセルから、ランダムに移動対象のセルを選択する関数。
       Simulated Annealing の温度 SATemp、 前回移動したセルの位置 Lrow, Lcol を引数として受け取り、
       ランダムに選択したセルの位置 Row, Col、そのセルが評価値に与える影響値 P, 制約を満たしていないセルの数 Pcount
       を具体化して返す。
    - decide_move_to(SATemp,FromRow,FromCol,FromP,ToRow,ToCol,ChosenCost)
       移動対象のセル FromRow, FromCol, ToRow, ToCol の移動先を決定する関数。
       Simulated Annealing の温度 SATemp、移動対象のセルの位置と影響度 FromRow, FromCol, FromP を引数で受け取り、
       決定した移動先のセルの位置 ToRow, ToCol、そのセルが評価値に与える影響度 ChosenCost を具体化して返す。
    - candidate_move_to(FromRow,FromCol,ToRow,ToCol)
       移動対象のセル cell(FromRow,FromCol,_,_) の移動先候補を作る Generator
    - cost(FromRow,FromCol,FromP,ToRow,ToCol,Cost)
       移動対象のセル cell(FromRow,FromCol,_,_) がセル cell(ToRow,ToCol,_,_) に移動した際に、
       全体の評価値に与える相対的な影響度 Cost を返す関数。
    - solve_loop(RemItr,SATemp,LastRow,LastCol,LastEval,DupCount,FinalEval)
       CSP を解くためのループの処理を行う関数。
       残りのループ可能数 RemItr、Simulated Annealing の温度 SATemp、前回のループで移動したセルの位置
       LastRow, LastCol、前回の評価値 LastEval、評価値が連続して変わっていないループ回数 DupCount を
       引数として受け取り、解を見つけた際には解の評価値 FinalEval を具体化して返す。
       解が見つからなかった場合は false を返す。
    - solve_csp
       CSP を解くための準備から解を見つけるまでの一連の処理を行う関数

  [ 画面出力関連の述語 ]
  ~~~~~~~~~~~~~~~~~~~
    セルの表示やメニューの表示などの画面出力のために、次の述語を定義してあるが、重要でないので説明を省く。
      - print_cells
      - cls, cls_{right,left,line}
      - location
      - right, left, up, down
      - symbol
      - input, proc_input
      - proc
      - my_main, main_menu
      - reload
      - setting
      - reset_schedule
      - do_schedule
      - print_schedule, wstr
      - end
      - go

      

(5) 考察

  [ 工夫したところ ]
  ~~~~~~~~~~~~~~~~
    　今回の課題では、与えられたタスク定義を、重み付き CSP を解くことでスケジュールに変換することを行った。
    その際に、「タスクに変更があっても、一度決めたスケジュールはあまり動かしたくない」という考えを反映する
    ために、CSP の制約に「チャンクが前回求めたスケジュールとなるべく同じ位置のセルに来るようにする」という
    制約をくわえ、それを解くことでスケジュールの大幅変更を抑えるような工夫をした。これは、参考文献[磯村 厚誌 他]
    を参考に考えたものである。

    　また、最後まで制約違反の重みを上手く設定できなかったが、そのために生じる無限ループを抑えるために、
    Simulated Annealing を用いて、初めはできるだけランダムに移動対象のセル、移動先のセルを選ぶように、
    ループ回数が増えたら、より制約違反の重みが大きいセルを移動対象に、より評価値の改善が大きいセルを移動先に
    選ぶようにする工夫を加えた。（最適解が得られないので、これは工夫とは言えないかもしれないが。）


  [ 工夫の結果 ]
  ~~~~~~~~~~~~~~~~
    　前述した工夫の結果、スケジューリングを行う際に、前回のスケジューリング結果となるべく変わらないようにする
    制約はそれなりに上手く動き、大抵のスケジューリングで前回のスケジューリング結果とほぼ同じ結果を得られる
    ようになった。

    　また、無限ループを抑えるために導入した Simulated Annealing により、制約が満たされないときにも
    解の収束をさせることはできたが、はじめにランダムな値の選択を多くする分、常に最良の値を選択する Min-
    Conflicts を使った時と比べ、解の収束に掛かる時間は大きく伸びてしまった。これは特に制約が少ないとき
    に顕著に差が出てしまうが、局所解になる確率を減らす、という意味では効果があるかもしれない。この部分は
    検証が足りていない。


  [ 問題点と改善点 ]
  ~~~~~~~~~~~~~~~~
      [*] 単方向の制約で良いのか
          　今回のプログラムでは各セルに持たせる制約は試行錯誤の結果最終的に単方向にしてある。
          タスクをタスクチャンクに分割したとき、できるだけそのチャンクは連続したセルに割り当てられるように、
          すなわち 1 つのタスクは始めたら最後まで続けてやり通すようなスケジュールを生成するようにしたいので、
          各チャンクには 1 つ前のチャンクに連続するという 'sequential' タイプの制約を与えている。このとき、
          初めは、後続のチャンクに対しても同様の制約を与えれば、「チャンクが連続する」という制約がより強くなり、
          その制約を満たす解が得られやすくなると考え、その制約を加えて単方向ではなく両方向の制約を持たせることを
          考えていた。このとき、連続する途中のチャンクが持つ制約は
             - 1 つ前のチャンクに後続するという制約　   (重み W1: 先行チャンクとの距離 * a + x)
             - 1 つ前のチャンクが先行するという制約   (重み W2: 先行チャンクとの距離 * b + y)
             - 1 つ後ろのチャンクが後続するという制約   (重み W3: 後続チャンクとの距離 * b + y)
             - 1 つ後ろのチャンクに先行するという制約   (重み W4: 後続チャンクとの距離 * a + x)
          の 4 つになるが、上記のように制約違反の重みが制約先のセルと制約元のセルとの間の距離を元に与えられる
          ことを考えると、連続する途中のチャンクを値として持つセルは、制約違反時に前方向、後ろ方向のどちらに動かしても、
          上記の 4 つの制約違反から与えられる重みの合計 W1+W2+W3+W4 の値は変化せず、評価値が変わらないため、
          移動先を決定できない。これは重みの与え方がセル間の距離に依存することが原因で、a,b,x,y が何であれ
          この重みの与え方では両方向の制約を持たせると解を見つけることができないことが分かった。

          　この結果を踏まえ、両方向の制約を持たせるのはやめ、単方向の制約、すなわち後続チャンクが先行チャンクに
          連続するという制約のみを与えることで、一意に評価値を減少させる方向にセルを移動させることができ、解を見つける
          ことができるようになった。

          　しかし、チャンクの連続性を保証するために、本来各チャンクに与えるべき制約は、「前のチャンクが先行する」、
          「後ろのチャンクが後続する」という両方向の制約だと思われ、前述した問題は制約違反の重みを工夫することで
          解決されるべきだと考えられる。

          
      [*] 重みの設定
          　各セルが制約を満たしていないときに、その制約違反のペナルティとして重みを与え、すべてのセルの
          重みの合計を全体の評価値としている。従って、すべてのセルが制約を満たしたときには、評価値が 0 に
          なるはずである。しかし、今回のプログラムでは、変数に割り当てる値が収束しても、その時の評価値が 0
          にならないことが多くなってしまっている。それが理由で Simulated Annealing を用いた最後には一意に
          収束選択するようにするランダムな移動対象の選択、およびランダムな移動先の選択を行い、全体の評価値に
          変化がない場合が続いたときには、現在の状態を解とするような、半ば強引な方法をとり、評価値が 0 に
          ならないがためにループ回数上限までループを繰り返すような状況を回避するようにしてある。本来は
          制約違反の重みを、早く最適解を見つけられるようにうまく設定しておけば、このような問題は起きず、
          最適解を見つけられるはずだが、今回は最後まで重みを上手く設定できないまま、時間の都合上、終えること
          になってしまった。


      [*] 局所解に至る
          　前述の通り、制約違反の重みの設定が上手くできなかったことが原因だと考えられるが、タスクの数が多いほど、
          また制約（依存タスクや締切、チャンクの連続）が多いほど、最適解を見つけられないまま、すなわち全体の評価値が
          0 にならないまま、局所解を求めて終了してしまうようになってしまった。この問題を解決するために、制約違反
          の重みをどのように与えればよいのか、よく考えて設計しなければならないと思われる。


  [ 感想 ]
  ~~~~~~~
    　今回作成したプログラムは、この講義の最終課題の一つ前の課題（N-Queen 問題を解く課題）で用いた手法に
    似た手法を使い、制約を満たす解を見つけるものであるが、そのとき作成した Prolog プログラムでは使っていなかった
    assert と retract を使い、より Prolog らしいプログラムを書くことができ、その書き方とそれの便利さを理解する
    ことができ、大変勉強になった。これが今回の課題で得られたものと考えられる。

    　また、CSP を解く手法について、（最後まであまり上手い解法が見つからず、試行錯誤していたこともあり）深く考え、
    近似アルゴリズムで CSP を解く難しさ、どこが問題なのかなど、よく考えることができた。加えて、スケジューリングを
    CSP で表現するときに加えるべき特有の制約（[工夫したところ]で記述した）などを知り、CSP が現実の問題を解くのに
    如何に有用なのかを改めて知ることができた。

    　しかし一方で、作成したプログラムは、前述したとおり重みの設定が悪いせいか、タスクの数やその制約が増えると
    局所解が求まってしまう上、そもそも解を見つけるまでに時間が掛かってしまうような、ひどいものになってしまった。
    これは、今回の CSP が持つべき制約と、それが上手く解けるように与えるべき重みの値をよく考えずに作り、最適解
    が求められない問題の本質(重み)を解決するよりも、無限ループを抑えるために評価値が変わらない状態が続けば途中
    でもやめ、それだけだと局所解が求まりやすいためランダムにセルの移動対象、移動先を決め、しかしそのままだと
    ランダムに値を決めるせいで評価値は変わらないが最適解とはほど遠いような解が求まってしまうため、Simulated
    Annealing を用いて後半は値を一意に決めるようにして・・・といった工夫をする方を重視したためであり、制約違反
    の重みは最後まで上手く設定できなかったので、結果として工夫は多いがプログラムの出来（最適なスケジュールを求める
    ことを考えたとき）は悪くなってしまった。プログラムを作り始める前に、その設計や理論を深く考え、上手く動作しない
    ときには、その問題の本質を考える、といった基本的な部分ができていなかったことが反省点である。



  -----------------------------------------------------------------------------

  [ 参考文献のリスト（参考にした他の人のレポートも含む） ]
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    - 磯村 厚誌、 伊藤 孝行、 大囿 忠親、 新谷 虎松 (2003),
      「ナーススケジューリングシステムにおける動的重み付きCSPに基づく再スケジューリング機能の実装」,
      情報処理学会第66回全国大会

    - 「Stochastic Hill Climbing - Clever Algorithms: Nature-Inspired Programming Recipes」,
       <http://www.cleveralgorithms.com/nature-inspired/stochastic/hill_climbing_search.html>
       (2014年8月6日 確認)

    - 「Min-Conflicts algorithm - Wikipedia the free encyclopedia」,
       <http://en.wikipedia.org/wiki/Min-conflicts_algorithm> (2014年8月6日 確認)
    
    - 「SWI-Prolog」,
       <http://www.swi-prolog.org/> (2014年8月6日 確認)





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

% is_member
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
    (get_config('DayFrom',DayFrom0), DayFrom is integer(DayFrom0), !; DayFrom is 900),
    (get_config('DayTo',DayTo0), DayTo is integer(DayTo0), !; DayTo is 1700).

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
    W0 is (D-ChunkSize),
    ( 0  < W0, Weight is 0, !;
     W0 =<  0, Weight is (-W0)*1.5 + 1000).

% 依存タスクの制約
penalty('dependent', Tid, 1, Chunk, Weight) :-
    Chunk = chunk(Dtid,Dcid,_),
    chunk_size(Dtid,Dchunksize),
    cell(Row,Col,Tid,1),
    cell(Drow,Dcol,Dtid,Dcid),
    cell_distance(Drow,Dcol,Row,Col,D),
    W0 is (D-1) - floor(Dchunksize/2),
    (W0 <  0, Weight is (-W0)*1.3 + 20, !;
     W0 =  0, Weight is 0, !;
      0 < W0, Weight is W0*0.03 + 10).

% 連続チャンクの制約
penalty('sequential', Tid, Cid, Chunk, Weight) :-
    Chunk = chunk(Ptid,Pcid,_),
    cell(Row,Col,Tid,Cid),
    cell(Prow,Pcol,Ptid,Pcid),
    (Cid = 1, !, cell_distance(Row,Col,Prow,Pcol,D); cell_distance(Prow,Pcol,Row,Col,D)),
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
	       1 < Cid, PrevCid is Cid-1, chunk(Tid,PrevCid,Len), !, assert(constraint(Tid,Cid,'sequential',chunk(Tid,PrevCid,Len)));
	       %Cid = 1, NextCid is Cid+1, chunk(Tid,NextCid,Len), !, assert(constraint(Tid,Cid,'sequential',chunk(Tid,NextCid,Len)));
	       true
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
select_move_cell(SATemp,Lrow,Lcol,Row,Col,P,Pcount) :-
    % 一時使用の述語を全削除（念のため）
    (retractall(p_of(_,_,_)), !; true),
    % 一つ前に移動させたセルがあれば確認
    (cell(Lrow,Lcol,Ltid,Lcid), !; Ltid = '-', Lcid = '-'),
    % 制約を満たしていないタスクチャンクをすべて取り出し、述語 p_of(Tid,Cid,P) でアサート
    forall(penalty(Tid,Cid,P), assert(p_of(Tid,Cid,P))),
    % ペナルティ(重み)順でソートされたリストを取得
    setof(p(P,Tid,Cid), (Tid,Cid)^p_of(Tid,Cid,P), Ps),
    reverse(Ps,Psr), write(Psr), nl,
    count(p_of(_,_,_), Pcount),
    % Simulated Annealing の温度をランダムに値を選択する確率に変換
    SAProb is max(min(0.5,SATemp),0),
    % 移動させるセルの決定
    select_move_cell_inner(SAProb,Psr,Ltid,Lcid,Row,Col,P),
    % 一時使用の述語を全削除
    (retractall(p_of(_,_,_)), !; true).
select_move_cell_inner(_,[],_,_,-1,-1,0) :- !.
select_move_cell_inner(SAProb,[X|Rest],Ltid,Lcid,Row,Col,P) :-
    % 選択肢がまだあるなら SATemp の確率で次の選択肢へ
    Rest \== [], maybe(SAProb), select_move_cell_inner(SAProb,Rest,Ltid,Lcid,Row,Col,P), !;
    % 選択肢がまだあってこの選択肢が選ばれても、一つ前のループで移動したセルなら飛ばす
    Rest \== [], X = p(_,Ltid,Lcid), select_move_cell_inner(SAProb,Rest,Ltid,Lcid,Row,Col,P), !;
    % この選択肢が選ばれた
    X = p(P,Tid,Cid), cell(Row,Col,Tid,Cid).

% セルの移動先を決定する
decide_move_to(SATemp,FromRow,FromCol,FromP,ToRow,ToCol,ChosenCost) :-
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
    length(Costs,Len), Max is max(min(Len,floor(SATemp*10)),1),
    random(0,Max,Index),
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
solve_loop(RemItr,SATemp,LastRow,LastCol,LastEval,DupCount,FinalEval) :-
    0 < RemItr,
    NextRemItr is RemItr - 1,
    % 今の評価値を計算
    eval(Eval),
    % 評価値が一つ前の評価値以上の場合はカウンタをインクリメント、減少した場合はカウンタをリセットする
    (Eval >= LastEval, NextDupCount is DupCount+1, !; NextDupCount is 0),
    location(1,1), cls_right, writef('Remaining Iteration: %t, Eval = %t, DupCount=%t, SATemp=%t',[RemItr,Eval,DupCount,SATemp]), nl,
    (	%get_single_char(_), % FIXME: 各ステップでキーの入力をするときはコメントアウトを消す
	location(1,2), cls_right, location(1,3), cls_right, location(1,4), cls_right, location(1,2),
	% ループの終了条件
	0 =< Eval, DupCount < 100,	
   	
	% 動かすセルの決定
    	select_move_cell(SATemp,LastRow,LastCol,FromRow,FromCol,FromP,Pcount),
    	cell(FromRow,FromCol,Tid,Cid),
    	location(1,5),cls_right,writef('choose cell to move: (%t-%t) [%t,%t] (P=%t)',[Tid,Cid,FromRow,FromCol,FromP]),nl,
	
	% 次のループで使う Simulated Annealing の温度を決定
	NextSATemp is min(1,( 0.9*SATemp+0.1*min(1,0.1*Pcount)) * 0.9),

	% 移動先の検討
	decide_move_to(SATemp,FromRow,FromCol,FromP,ToRow,ToCol,Cost),
	print_cells, nl,
	(
	    % 相対コストが負の場合（評価値が下がるとき）は移動して、ループを回す
	    Cost =< 0,
	    cls_right,writef('[%5r] moving [%t,%t] -> [%t,%t], (FromP=%t, Cost=%t)',[RemItr,FromRow,FromCol,ToRow,ToCol,FromP,Cost]),nl,
	    swap_cell(FromRow,FromCol,ToRow,ToCol),
	    !, solve_loop(NextRemItr,NextSATemp,ToRow,ToCol,Eval,NextDupCount,FinalEval), !;
	    
	    % そうでないときは移動しないで、ループを回す
	    !, solve_loop(NextRemItr,NextSATemp,FromRow,FromCol,Eval,NextDupCount,FinalEval)
	)
	;
	FinalEval = Eval, true
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
    solve_loop(MaxItr,1,-1,-1,-1,0,_),
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
print_cells_pos(true,Xoffset,Yoffset,X,Y) :- X is 3 + Xoffset, Y is 7 + Yoffset.
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
