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

#define MAX_LOOP 10000 // 試行の回数


int nq;//クイーンの数

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

//
//ここにプログラムを書きくわえる
//
  
  return(conf);
}


void init_queens(int* queens)//クイーンをランダムに配置。但し、同じ行に2つ以上のクイーンがあってはいけない
{
  
//
//ここにプログラムを書きくわえる
//
  
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

//
//ここにプログラムを書きくわえる
//
  
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

void chenge_queen(int* queens,int* conf,int num)
{
// num番目の列にあるクイーンを移動する  
// conf[i]:num番目の列にあるクイーンがi行目に移動したときの衝突数
  
  int move = get_min(conf);//どの行に移動すると衝突数が小さくなるか判定
  int temp,i;

//
//ここにプログラムを書きくわえる
//
  
  swap_data(&queens[num],&queens[temp]);//num列目とtemp列目のクイーンの位置を交換
}

int main(int argc, char *argv[])
{
  srand((unsigned int)time(NULL));//ランダム関数の初期化

  
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
          return(0);
        }
      
      num = select_move_queen(attacked);//どのクイーンを動かすか選択
      
      temp = queens[num];
      for(j=0;j<nq;j++)//queens[num]がj列目にあるとき…のコンフリクトを計算
        {
          //get_conf(queens,num)を使ってconf[]の各要素を計算すること

//
//ここにプログラムを書きくわえる
//
          
        }
      queens[num] = temp;
      
      chenge_queen(queens,conf,num);
      get_attack(queens,attacked);
    }
  return(0);
}
