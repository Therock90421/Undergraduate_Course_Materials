#include<stdio.h>

#define LENGTH 8



int board[8][8] = {0};   //棋盘
int row_change[8] = {2,1,-1,-2,-2,-1,1,2};   //马走一步后的行变换量
int col_change[8] = {1,2,2,1,-1,-2,-2,-1};    //马走一步后的列变换量

struct Stack{
	int row;   //行坐标
	int col;   //列坐标
	int director; //方向
}STACK[100];



int top = -1;          //栈指针
void init(int x, int y); //初始化棋盘，读取起始位置
int try_next(int i, int j);   //尝试每个方向
void show();   //输出路径


void init(int x, int y)
{
	int row,col;
	top++;                //初始化时top为0
	board[x][y] = top + 1;   //给棋盘做标记
	STACK[top].row = x;
	STACK[top].col = y;
	STACK[top].director = -1;
	row = STACK[top].row;
	col = STACK[top].col;

	

	if(try_next(row,col))
		show();
	else printf("马不能遍历棋盘");

}

int try_next(int i, int j)
{
	int director,number,flag;
	int h,k,x,y,m,min,l,s;
	int a[8],row[8],col[8],next[8];
	
	while(top > -1)//栈非空时
	{
		for(h = 0;h < 8; h++)  //h表示下一步走到位置的代码
		{                      //用a【8】记录该节点下一步走到的位置的后面可走位置的个数
			number = 0;
			i = STACK[top].row + row_change[h];
			j = STACK[top].col + col_change[h];
			row[h] = i;
			col[h] = j;           //row[h]和col[h]表示下一步的横纵坐标
			if(board[i][j]==0&&i>=0&&i<8&&j>=0&&j<8) //如果找到了下一步可走的位置
			{
				for(k = 0;k<8;k++)//寻找下下个位置
				{
					x = row[h] + row_change[k];
					y = col[h] + col_change[k];
					if(board[x][y]==0&&x>=0&&x<8&&y>=0&&y<8)
						number++;
				}
				a[h] = number;
			}
		}
		for(h = 0; h<8 ;h++)       //对a【h】从小到大，给查询顺序排序,放到next【8】中
		{
			min = 9;
			for(k = 0; k<8; k++)
				if(min > a[k])
				{
					min = a[k];
					next[h] = k;
					m = k;
				}
				a[m] = 9;
		}
		director = STACK[top].director;
		
		

		if(top >= 63)
			return 1;


		flag = 0;
		for(h = director+1; h<8; h++)   //按排序顺序进行探索
		{
			i = STACK[top].row + row_change[next[h]];
			j = STACK[top].col + col_change[next[h]];
			if(board[i][j]==0&&i>=0&&i<8&&j>=0&&j<8)
			{
				flag = 1;  //找到了下个位置
				break;
			}
		}
		if(flag==1)                            //找到了下个位置
		{
			STACK[top].director = h;
			top++;                          //更新栈顶
			STACK[top].row = i;
			STACK[top].col = j;
			STACK[top].director = -1;
			board[i][j] = top+1;             //更新棋盘
			
		}
		else //无路可走
		{
			
			board[STACK[top].row][STACK[top].col] = 0; //清除
			top--;
		}
	}
	return 0;
}


void show()
{
	int i,j;
	i = 0;
	j = 0;
	for(i = 0; i< LENGTH; i++)
	{
		for(j = 0; j< LENGTH; j++)
			printf("\t%d",board[i][j]);
		printf("\n\n\n");
	}
	
}


int main()
{
	int i,j;
	int x,y;
	char s;
	
	
	for(i = 0;i < 8;i++)
		for(j = 0; j<8 ;j++)
			board[i][j] = 0;

	printf("请输入起始坐标（1 <= x <= 8）(1 <= y <= 8)\n");
	printf("x = ");
	scanf("%d",&x);
	while(x>7)
	{
		printf("请输入正确的横坐标\n");
		printf("x = ");
		scanf("%d",&x);
	}
	printf("y = ");
	scanf("%d",&y);
	while(y>7)
	{
		printf("请输入正确的纵坐标\n");
		printf("y = ");
		scanf("%d",&y);
	}
	printf("从 %d，%d开始跳跃\n",x,y);
	

	init(x-1,y-1);
	

	return 0;

}

	

