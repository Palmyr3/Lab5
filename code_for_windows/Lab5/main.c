#include <Windows.h>
#include <Winbase.h>
#include <stdio.h>
#define BUFF_SIZE 18

int main(void)
{
	HANDLE Port;
	BOOL operationIsFinishedOk;
	DCB ComDCM;
	COMMTIMEOUTS CommTimeOuts;
	OVERLAPPED sync = {0};

	static int TIMEOUT = 2000;
	const int timeout = 2000;
	unsigned char inBuff[BUFF_SIZE] ;
	unsigned char buff = 0x00;
	unsigned long feedback;
	unsigned long wait = 0, read = 0, state = 0;
	int i;


	//SYSTEMTIME st;
	//GetSystemTime(&st);
	//st.wHour = 0;
	//st.wMinute = 0;
	//st.wYear = 0x2014;
	//SetSystemTime(&st);
	//printf("The current timer value is %ld", biostime(0,0));


	
	/* settings*/
	CommTimeOuts.ReadIntervalTimeout = 0xFFFFFFFF;
 	CommTimeOuts.ReadTotalTimeoutMultiplier = 0;
 	CommTimeOuts.ReadTotalTimeoutConstant = TIMEOUT;
 	CommTimeOuts.WriteTotalTimeoutMultiplier = 0;
 	CommTimeOuts.WriteTotalTimeoutConstant = TIMEOUT;

	ComDCM.DCBlength = sizeof(DCB);
 	GetCommState(Port, &ComDCM);
 	ComDCM.BaudRate = 115200;
 	ComDCM.ByteSize = 8;
 	ComDCM.Parity = NOPARITY;
 	ComDCM.StopBits = ONESTOPBIT;
 	ComDCM.fAbortOnError = TRUE;
 	ComDCM.fDtrControl = DTR_CONTROL_DISABLE;
 	ComDCM.fRtsControl = RTS_CONTROL_DISABLE;
 	ComDCM.fBinary = TRUE;
 	ComDCM.fParity = FALSE;
 	ComDCM.fInX = FALSE;
    ComDCM.fOutX = FALSE;
 	ComDCM.XonChar = 0;
 	ComDCM.XoffChar = (unsigned char)0xFF;
 	ComDCM.fErrorChar = FALSE;
 	ComDCM.fNull = FALSE;
 	ComDCM.fOutxCtsFlow = FALSE;
 	ComDCM.fOutxDsrFlow = FALSE;
 	ComDCM.XonLim = 128;
 	ComDCM.XoffLim = 128;

	
	Port = CreateFile("\\\\.\\COM2", GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, NULL);
	//Port = CreateFile("\\\\.\\COM2", GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, NULL);
	if (Port == INVALID_HANDLE_VALUE) 
	{
		printf("Port Not Opened");
		getchar();
		return 1;
	}
	/*���������� ������ �� ��*/
	operationIsFinishedOk = WriteFile(Port, &buff, 1, &feedback, NULL);
	if (operationIsFinishedOk)
	{
		printf("Is OK\n");
	}
	else
	{
		printf("Not write");
		getchar();
	}

	/* ������� ������ ������������� */
	sync.hEvent = CreateEvent(NULL,TRUE,FALSE,NULL);
 
	/* ������������� ����� �� ������� ����� */
	if(SetCommMask(Port,EV_RXCHAR)) 
	{
		/* ��������� ���� � ������ �������������*/
		WaitCommEvent(Port, &state, &sync);
		/* �������� �������� ������*/
		wait = WaitForSingleObject(sync.hEvent, timeout);
		/* ������ �������� */		
		if(wait == WAIT_OBJECT_0) 
		{
			/* ��� ���� ��� ������ ������ */
			Sleep(15); 
			/* �������� ������ ������ */
			ReadFile(Port, &inBuff, 18, &read, &sync);
			/* ���� ���������� �������� ������ */
			wait = WaitForSingleObject(sync.hEvent, timeout);
			/* ���� ��� ������� ���������, ������ ����� ����� ������ �������� */
			if(wait == WAIT_OBJECT_0)
			{
				if(GetOverlappedResult(Port, &sync, &read, FALSE)) 
				{
					printf("Successfully reed: %d\n", read);
				}
			}
		}
	}
	/* ������� ������ */	
	for(i = 0; i < BUFF_SIZE; i++)
	{
		printf("%X | ", inBuff[i]);
	}
	CloseHandle(sync.hEvent);
	getchar();

	return 0;
}