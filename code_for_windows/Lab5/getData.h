#ifndef getData_h
#define getData_h

#include <Windows.h>

#define TIME_BUFFER_SIZE 17
#define BUFFER_SIZE 20

typedef struct
{
	unsigned int uartStatus;
    unsigned char timeValueBuff[TIME_BUFFER_SIZE];
    unsigned char satteliteCatched;
    unsigned char fatalErrorZDA;
	unsigned char fatalErrorGSV;
}   timeData;

timeData detData(char portNumber1, char portNumber2);

#endif