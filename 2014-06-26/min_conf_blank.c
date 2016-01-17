// rep10: 第10回 演習課題レポート
// 2014年06月25日      by 24115113 名前: 林 政行
/*
  制約充足問題のプログラミング
   - N-queens問題のprologプログラムの性能評価実験

  [問題]
    以下の資料を参考にしてminimum-conflictアルゴリズムを理解し，C言語でN-queensを解くプログラムを作成すること．
    プログラム作成には、以下のサンプルプログラムを用いても構わない．
    サンプルプログラムを使用する場合には、コメントを参考にしてプログラムが適切に動作するように直すこと．
    各自が作成したソースについては，第三者が理解できるように適切なコメントを挿入するとともに，考察文で解説すること．
    また、minimum-conflictアルゴリズムについて考察すること．

    ＊従来のレポートと同様に実行例および考察を記載すること
    ＊コメントアウトはC言語のコメントアウトを使用すること

  [内容]
    本レポートの内容:
      - プログラム本体
      - 実行例
      - 考察
 */
//
// ===================================================================
//  1.プログラム本体 
// -------------------------------------------------------------------
//
//   ここからプログラム本体が始まる
/*

  a|b|c|d|e|f|g|h|
-+-+-+-+-+-+-+-+-+
1| | | | | | | | |
-+-+-+-+-+-+-+-+-+
2| | | | | | | | |
-+-+-+-+-+-+-+-+-+
3| | | | | | | | |
-+-+-+-+-+-+-+-+-+
4| | | | | | | | | 
-+-+-+-+-+-+-+-+-+
5| | | | | | | | |
-+-+-+-+-+-+-+-+-+
6| | | | | | | | |
-+-+-+-+-+-+-+-+-+
7| | | | | | | | |
-+-+-+-+-+-+-+-+-+
8| |*| | | | | | |
------------------

横方向に並んだ要素を行と呼び、縦方向に並んだ要素を列と呼ぶ。
つまり、上図において*マークは8行目のb列である。

*/

#include <stdio.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>

#define MAX_LOOP 10000 // 試行の回数


int nq;//クイーンの数

void swap_data(int* num1,int* num2);

int random(int max)//乱数nを生成 nは整数かつ0<=n<max
{
  int i = (int)(rand());
  return(i % max);
}

int get_conf(int queens[],int num)//num列目のクイーンがいくつ衝突しているか計算する関数
{
  int conf = 0;
  int i;
  int temp;

  // 斜め方向: ／
  for(i=0, temp=queens[num]+num; i<nq; i++, temp--)
    {
      if (queens[i] == temp && i !=num)
	{
	  conf++;
	}
    }

  // 斜め方向: ＼
  for(i=0, temp=queens[num]-num; i<nq; i++, temp++)
    {
      if (queens[i] == temp && i != num)
	{
	  conf++;
	}
    }
  
  return(conf);
}


void init_queens(int* queens)//クイーンをランダムに配置。但し、同じ行に2つ以上のクイーンがあってはいけない
{
  int i;
  
  // 重複がないように配列 queens の中身を初期化
  for(i=0;i<nq;i++)
    {
      queens[i] = i;
    }

  // 0≦x＜nq, 0≦y＜nq でランダムに queens[x], queens[y] を並び替え
  for(i=0;i<nq;i++)
    {
      swap_data(&queens[random(nq)], &queens[random(nq)]);
    }
}

void get_attack(int* queens, int* attacked)
{
  int i;
  for(i=0;i<nq;i++)
    {
      attacked[i] = get_conf(queens,i);
    }
}

int check_attack(int attack[])
{
  int i;
  for(i=0;i<nq;i++)
    {
      if(attack[i] != 0)
        {
          return(0);
        }
    }
  return(1);
}

int select_move_queen(int attack[])//衝突があるクイーンの中から1つ、移動させるクイーンを選ぶ
{
  int i;
  int last = 0;
  for(i=0;i<nq;i++)
    {
      if (attack[i] != 0)
	{
	  last = i;
	  if(random(2) == 1)
	    {
	      return i;
	    }
	}
    }
  return ((0<last) ? last : 0);
}

int get_min(int* data)//渡されたデータの中から最小のものの添え字を返す
{
  int i;
  int point,num;
  int list[nq];
  
  point = data[0];
  list[0] = 0;
  num = 1;
  
  for(i=1;i<nq;i++)
    {
      if(data[i] == point)
        {
          list[num] = i;
          num++;
        }
      if(data[i] < point)
        {
          point = data[i];
          num = 1;
          list[0] = i;
        }
    }
  return(list[random(num)]);
}

void swap_data(int* num1,int* num2)//渡された2つのポインタの中身をスワップする
{
  int i;
  i = *num1;
  *num1 = *num2;
  *num2 = i;
}

void change_queen(int* queens,int* conf,int num)
{
// num番目の列にあるクイーンを移動する  
// conf[i]:num番目の列にあるクイーンがi行目に移動したときの衝突数
  
  int move = get_min(conf);//どの行に移動すると衝突数が小さくなるか判定
  int temp,i;
  
  // move列目にあるクイーンを探す --> 列をtempに入れる
  temp=-1;
  for(i=0;i<nq;++i)
    {
      if(queens[i] == move)
	{
	  temp = i;
	  break;
	}
    }
  if (temp < 0)
    {
      // 移動先の行にクイーンが存在しない場合はリターン
      return;
    }

  swap_data(&queens[num],&queens[temp]);//num列目とtemp列目のクイーンの位置を交換
}

int main(int argc, char *argv[])
{
  srand((unsigned int)time(NULL));//ランダム関数の初期化

  if (argc <= 1)
    {
      printf("Usage: %s [num of queens]\n", argv[0]);
      return(0);
    }
  
  nq = atoi(argv[1]);
  if(!(nq > 0 && nq < 1000))//引数に0~999の数字が与えられなかった場合、8queenを解く
    {
      nq = 8;
    }
  
  int queens[1000];//クイーンの位置を格納する配列 queens[i]にはi列目のクイーンが何行目にあるか格納されている
  int conf[1000];//コンフリクトの数を格納する配列 
  int attacked[1000];//各クイーンの衝突数を格納する配列 attacked[i]にはi列目のクイーンがいくつ衝突しているか格納している
  int i,j;
  int num;
  int temp;
  char succeeded = 0;
  struct timeval tv1, tv2;
  
  // 時間計測開始
  gettimeofday(&tv1, NULL);

  //各クイーンの位置をランダムで初期化
  init_queens(queens);

  get_attack(queens,attacked);//どのクイーンがいくつ衝突しているか計算

  for(i=0;i<MAX_LOOP;i++)
    {
      if(check_attack(attacked))
        {
          for(j=0;j<nq;j++)//結果出力
            {
              printf("%d ",queens[j]);
            }
          printf("end\n");
	  succeeded = 1;
	  break;
        }
      
      num = select_move_queen(attacked);//どのクイーンを動かすか選択
      
      temp = queens[num];
      for(j=0;j<nq;j++)//queens[num]がj列目にあるとき…のコンフリクトを計算
        {
          //get_conf(queens,num)を使ってconf[]の各要素を計算すること
	  queens[num] = j;
	  conf[j] = get_conf(queens,num);
        }
      queens[num] = temp;
      
      change_queen(queens,conf,num);
      get_attack(queens,attacked);
    }

  if (!succeeded)
    {
      printf("FOUND NO ANSWER\n");
    }

  // 時間計測終了
  gettimeofday(&tv2, NULL);

  printf("exec time: %d[usec]\n",
	 (tv2.tv_sec - tv1.tv_sec)*1000*1000+(tv2.tv_usec - tv1.tv_usec));
  return(0);
}
//  ここまでプログラム本体
//
// ===================================================================
//  2. 実行例 
// -------------------------------------------------------------------
//
//  以下に実行例を記載する
/*

 (実行例 1)
cjh15113@cse:~/prolog/2014-06-26> ./a.out 8
7 1 4 2 0 6 3 5 end
exec time: 107[usec]

cjh15113@cse:~/prolog/2014-06-26> ./a.out 8
7 1 4 2 0 6 3 5 end
exec time: 143[usec]

cjh15113@cse:~/prolog/2014-06-26> ./a.out 8
5 7 1 3 0 6 4 2 end
exec time: 95[usec]

cjh15113@cse:~/prolog/2014-06-26> ./a.out 8
3 7 4 2 0 6 1 5 end
exec time: 131[usec]


 (実行例 2)
cjh15113@cse:~/prolog/2014-06-26> ./a.out 99
51 40 31 90 75 87 4 82 32 72 15 38 98 78 60 70 39 55 65 93 1 22 79 23 46 9 13 81 36 33 47 44 74 25 48 28 52 57 91 3 96 37 5 54 6 80 56 24 69 89 18 2 8 94 61 49 10 12 88 62 7 26 14 21 73 77 97 92 59 95 85 68 41 17 35 11 19 66 50 53 20 30 42 71 86 67 45 29 83 34 43 76 58 63 84 27 0 64 16 end
exec time: 342131[usec]

cjh15113@cse:~/prolog/2014-06-26> ./a.out 99
FOUND NO ANSWER
exec time: 1342837[usec]

 */
//
// ===================================================================
//  3.考察
// -------------------------------------------------------------------
//
/*
  今回は制約充足問題の完全アルゴリズム、近似アルゴリズムによる解法を学び、
  CSP の一例である 8-Queens 問題を局所探索（近似アルゴリズム）による解法で
  解く方法を C 言語で実装した。

  CSP の解法に関しては、何度か他の授業でも学んでいたため、アルゴリズムはある程度
  知っていたが、どれほどの計算量が必要なのか、アルゴリズムによる計算量の差はどうなのか
  といった部分は、理解していなかった。
  
  今回の講義を通して、CSP 問題において、近似アルゴリズムでない場合 NP 問題となり、
  計算量が大きいということがわかった。CSP 問題を計算機で解くのは、完全アルゴリズム
  はできていても、計算量の面で困難であり、代わりに近似アルゴリズムを用いることで、
  少ない計算量で求めることができることもある、ということが分かった。また、実際に
  航空機のフライトスケジューリング、ハッブル宇宙望遠鏡の観測スケジューリングなどで
  この近似アルゴリズムが利用さているということを知り、現実では CSP 問題の変数の数
  が多いことが多いため、完全アルゴリズムよりも近似アルゴリズムの方が実用的であることが
  よく分かった。

  計算時間に関して、(実行例 1) を見ると、同じ 8 個の変数に値を割り当てる CSP 問題
  なのにもかかわらず、初期値の違い、実行中にランダムに選ばれる値の違いにより実行時間が
  異なっていることが見て取れる。この実行時間の違いは (実行例 2) で顕著に表れ、
  99 個の変数に値を割り当てる CSP 問題で、0.3 秒ほどで解が見つかる場合もあれば、
  衝突クイーンの移動を 10000 回繰り返しても、制約を満たす解が得られず、1 秒以上掛かって
  解が得られないまま終了してしまう場合も再現された。

  これらの実行時間の違いを見ると、初期値を如何に上手く設定するのか、（今回の CSP 問題に
  ついては）衝突数 #Conf が同じであるが故に、クイーンの移動先の候補が複数存在するときに、
  早く解が見つかるような移動先を如何に見つけるか、といった部分で工夫をすることで、解の発見
  を高速化することができるのかもしれないと思った。

 */
