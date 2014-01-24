#include <Windows.h>
#include <stdio.h>

#include "getData.h"
#include "setTime.h"


int main(int argc, char **argv)
{
	timeData realTime;
	int i;
	int skipError = 0;
	int skipCheckNumberOfSatelitt = 0;
	int printOnly = 0;
	int outStatuse;
	char portNumber1 = 0x00; 
	char portNumber2 = 0x00;

	if((argc != 2)&&(argc != 3))
	{
		printf("usage: GPStime -port [-f | -a | -p]");
		printf("\n-f - skip all errors");
		printf("\n-p - only ptint gps time");
		printf("\n-a - set time, even when satellite not catched");
		printf("\n-port - number of UART/USART/COM port");
		getchar();
		return 30;
	}

	if(argc == 3)
	{
		if((*argv[2] == '-')&&(*(argv[2]+1)== 'f'))
		{
			skipError = 1;
		}
		if((*argv[2] == '-')&&(*(argv[2]+1)== 'p'))
		{
			printOnly = 1;
		}
		if((*argv[2] == '-')&&(*(argv[2]+1)== 'a'))
		{
			skipCheckNumberOfSatelitt = 1;
		}
	}
	if(*argv[1] == '-')
	{
		portNumber1 = *(argv[1]+1);
		portNumber2 = *(argv[1]+2);
	}
	
	realTime = detData(portNumber1, portNumber2);

	if (realTime.uartStatus)
	{
		switch (realTime.uartStatus)
		{
			case 1:
				printf("Port Not Opened");
				break;
			case 2:
				printf("Not write");
				break;
			case 3:
				printf("Data not receive");
				break;
			default :
				printf("Unknown error");
				break;
		}
		getchar();
		return realTime.uartStatus;
	}

	if (printOnly)
	{
		printf("%d%d:%d%d:%d%d.%d%d%d   ",realTime.timeValueBuff[0], realTime.timeValueBuff[1], realTime.timeValueBuff[2], realTime.timeValueBuff[3],
			realTime.timeValueBuff[4], realTime.timeValueBuff[5], realTime.timeValueBuff[6], realTime.timeValueBuff[7],realTime.timeValueBuff[8]);
		printf("%d%d.%d%d.%d%d%d%d\n", realTime.timeValueBuff[9], realTime.timeValueBuff[10], realTime.timeValueBuff[11], realTime.timeValueBuff[12],
			realTime.timeValueBuff[13], realTime.timeValueBuff[14], realTime.timeValueBuff[15], realTime.timeValueBuff[17]); 
		printf("Satellite catched: %d", realTime.satteliteCatched);
		printf("\nFatal Error ZDA: %X", realTime.fatalErrorZDA);
		printf("\nFatal Error GSV: %X", realTime.fatalErrorGSV);	
		getchar();
	}
	else
	{
		outStatuse = setTime (realTime, skipError, skipCheckNumberOfSatelitt);
		if (outStatuse)
		{
			switch (outStatuse)
			{
				case 50:
					printf("GPS receiver fatal error");
					break;
				case 51:
					printf("No satellite catched");
					break;
				case 52:
					printf("Time not set. You need administrator right");
					break;
				default :
					printf("Unknown error");
					break;
			}
			getchar();
			return outStatuse;
		}		
	}
	return 0;	
}