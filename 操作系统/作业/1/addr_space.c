#include <stdio.h>

#include <stdlib.h>


char *myname="Chen Mingyu";

char gdata[128];

char bdata[16] = {1,2,3,4};

main() 
{

	char * ldata[16];
	
	char * ddata;


	ddata = malloc(16);

	printf("gdata: %llX\nbdata:%llX\nldata:%llx\nddata:%llx\n",
		gdata,bdata,ldata,ddata);

	free(ddata);

}
