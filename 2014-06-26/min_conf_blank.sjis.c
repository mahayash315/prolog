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

�������ɕ��񂾗v�f���s�ƌĂсA�c�����ɕ��񂾗v�f���ƌĂԁB
�܂�A��}�ɂ�����*�}�[�N��8�s�ڂ�b��ł���B

*/

#include <stdio.h>
#include <string.h>
#include <time.h>

#define MAX_LOOP 10000 // ���s�̉�


int nq;//�N�C�[���̐�

void swap_data(int* num1,int* num2);

int random(int max)//����n�𐶐� n�͐�������0<=n<max
{
  int i = (int)(rand());
  return(i % max);
}

int get_conf(int queens[],int num)//num��ڂ̃N�C�[���������Փ˂��Ă��邩�v�Z����֐�
{
  int conf = 0;
  int i;
  int temp;

  for(i=0, temp=num; i<nq; i++, temp--)
    {
      if (queens[i] == queens[num]+temp ||  // �΂ߕ���: �^
	  queens[i] == queens[num]-temp)    // �΂ߕ���: �_
	{
	  conf++;
	}
    }
  
  return(conf);
}


void init_queens(int* queens)//�N�C�[���������_���ɔz�u�B�A���A�����s��2�ȏ�̃N�C�[���������Ă͂����Ȃ�
{
  int i;
  
  // �d�����Ȃ��悤�ɔz�� queens �̒��g��������
  for(i=0;i<nq;i++)
    {
      queens[i] = i;
    }

  // 0��x��nq, 0��y��nq �Ń����_���� queens[x], queens[y] ����ёւ�
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

int select_move_queen(int attack[])//�Փ˂�����N�C�[���̒�����1�A�ړ�������N�C�[����I��
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
  return (0<last) ? last : 0;
}

int get_min(int* data)//�n���ꂽ�f�[�^�̒�����ŏ��̂��̂̓Y������Ԃ�
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

void swap_data(int* num1,int* num2)//�n���ꂽ2�̃|�C���^�̒��g���X���b�v����
{
  int i;
  i = *num1;
  *num1 = *num2;
  *num2 = i;
}

void change_queen(int* queens,int* conf,int num)
{
// num�Ԗڂ̗�ɂ���N�C�[�����ړ�����  
// conf[i]:num�Ԗڂ̗�ɂ���N�C�[����i�s�ڂɈړ������Ƃ��̏Փː�
  
  int move = get_min(conf);//�ǂ̍s�Ɉړ�����ƏՓː����������Ȃ邩����
  int temp,i;
  
  // move��ڂɂ���N�C�[����T�� --> ���temp�ɓ����
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
      // �ړ���̍s�ɃN�C�[�������݂��Ȃ��ꍇ�̓��^�[��
      return;
    }

  swap_data(&queens[num],&queens[temp]);//num��ڂ�temp��ڂ̃N�C�[���̈ʒu������
}

int main(int argc, char *argv[])
{
  srand((unsigned int)time(NULL));//�����_���֐��̏�����

  
  nq = atoi(argv[1]);
  if(!(nq > 0 && nq < 1000))//������0~999�̐������^�����Ȃ������ꍇ�A8queen������
    {
      nq = 8;
    }
  
  int queens[1000];//�N�C�[���̈ʒu���i�[����z�� queens[i]�ɂ�i��ڂ̃N�C�[�������s�ڂɂ��邩�i�[����Ă���
  int conf[1000];//�R���t���N�g�̐����i�[����z�� 
  int attacked[1000];//�e�N�C�[���̏Փː����i�[����z�� attacked[i]�ɂ�i��ڂ̃N�C�[���������Փ˂��Ă��邩�i�[���Ă���
  int i,j;
  int num;
  int temp;
  
  //�e�N�C�[���̈ʒu�������_���ŏ�����
  init_queens(queens);

  get_attack(queens,attacked);//�ǂ̃N�C�[���������Փ˂��Ă��邩�v�Z

  for(i=0;i<MAX_LOOP;i++)
    {
      if(check_attack(attacked))
        {
          for(j=0;j<nq;j++)//���ʏo��
            {
              printf("%d ",queens[j]);
            }
          printf("end\n");
          return(0);
        }
      
      num = select_move_queen(attacked);//�ǂ̃N�C�[���𓮂������I��
      
      temp = queens[num];
      for(j=0;j<nq;j++)//queens[num]��j��ڂɂ���Ƃ��c�̃R���t���N�g���v�Z
        {
          //get_conf(queens,num)���g����conf[]�̊e�v�f���v�Z���邱��
	  queens[num] = j;
	  conf[j] = get_conf(queens,num);
          
        }
      queens[num] = temp;
      
      change_queen(queens,conf,num);
      get_attack(queens,attacked);
    }
  return(0);
}
