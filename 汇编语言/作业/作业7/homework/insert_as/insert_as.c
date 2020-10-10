#include<stdio.h>


unsigned int shld(unsigned int a,
       unsigned int b);

int main(){
	unsigned int a,b=0;
	a = 1;
	b = 4294967295;
	
	printf("%d\n",shld(a,b));
	return 0;
}





unsigned int shld(unsigned int a,
       unsigned int b)
{
    unsigned int result;
    
    asm("shl   $5,%%eax\n\t"
        "shr   $27,%%ebx\n\t"
        "or    %%eax,%%ebx"
        :"=b"(result)
        :"a"(a), "b"(b));
    return result;
}
