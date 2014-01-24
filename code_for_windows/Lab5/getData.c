#include "getData.h"
timeData detData(char portNumber1, char portNumber2)
{
	HANDLE Port;
	BOOL operationIsFinishedOk;
	DCB ComDCM;
	COMMTIMEOUTS CommTimeOuts;
	OVERLAPPED sync = {0};

	timeData realTime;

	unsigned long numberOfSuccessfulReadData = 0;
	unsigned char inBuff[BUFFER_SIZE] ;

	int timeout = 200;
	unsigned char buff = 0x00;
	unsigned long wait = 0, read = 0, state = 0, feedback;
	int i;

	char portNum[10] = {'\\','\\','.','\\','C','O','M', portNumber1, portNumber2, 0x00};


	CommTimeOuts.ReadIntervalTimeout = 0xFFFFFFFF;
 	CommTimeOuts.ReadTotalTimeoutMultiplier = 0;
 	CommTimeOuts.ReadTotalTimeoutConstant = timeout;
 	CommTimeOuts.WriteTotalTimeoutMultiplier = 0;
 	CommTimeOuts.WriteTotalTimeoutConstant = timeout;

	ComDCM.DCBlength = sizeof(DCB);
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

	SetCommState(Port, &ComDCM);
	SetCommTimeouts(Port,&CommTimeOuts);
	//  "\\\\.\\COM2"

	Port = CreateFile(portNum, GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, NULL);

	if (Port == INVALID_HANDLE_VALUE) 
	{
		realTime.uartStatus = 1;
		return realTime;
	}

	/*отправляем сигнал на мк*/
	operationIsFinishedOk = WriteFile(Port, &buff, 1, &feedback, NULL);

	if (!operationIsFinishedOk)
	{
		realTime.uartStatus = 2;
		CloseHandle(Port);
		return realTime;
	}

	/* Создаем объект синхронизации */
	sync.hEvent = CreateEvent(NULL,TRUE,FALSE,NULL);
 
	/* Устанавливаем маску на события порта */
	if(SetCommMask(Port,EV_RXCHAR)) 
	{
		/* Связываем порт и объект синхронизации*/
		WaitCommEvent(Port, &state, &sync);
		/* Начинаем ожидание данных*/
		wait = WaitForSingleObject(sync.hEvent, timeout);
		/* Данные получены */		
		if(wait == WAIT_OBJECT_0) 
		{
			/* Ждём пока все данные придут */
			Sleep(15); 
			/* Начинаем чтение данных */
			ReadFile(Port, &inBuff, BUFFER_SIZE, &read, &sync);
			/* Ждем завершения операции чтения */
			wait = WaitForSingleObject(sync.hEvent, timeout);
			/* Если все успешно завершено, узнаем какой объем данных прочитан */
			if(wait == WAIT_OBJECT_0)
			{
				GetOverlappedResult(Port, &sync, &numberOfSuccessfulReadData, FALSE);
			}
		}
	}
	CloseHandle(Port);

	if (numberOfSuccessfulReadData = BUFFER_SIZE)
	{
		for(i = 0; i < TIME_BUFFER_SIZE; i++)
		{
			realTime.timeValueBuff[i] = inBuff[i];
		}
		realTime.fatalErrorGSV = inBuff[17];
		realTime.fatalErrorZDA = inBuff[18];
		realTime.satteliteCatched = inBuff[19];
		realTime.uartStatus = 0;
	}
	else
	{
		realTime.uartStatus = 3;
	}
	return realTime;
}