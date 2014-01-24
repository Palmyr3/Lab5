#include "setTime.h"

int setTime (timeData realTime, int skipError, int skipCheckNumberOfSatelitt)
{
	if (((!realTime.fatalErrorGSV)&&(!realTime.fatalErrorZDA))||skipError)
	{
		if ((realTime.satteliteCatched)||(skipError)||(skipCheckNumberOfSatelitt))
		{
			SYSTEMTIME st;
			st.wHour = (realTime.timeValueBuff[0]*10 + realTime.timeValueBuff[1]);
			st.wMinute = (realTime.timeValueBuff[2]*10 + realTime.timeValueBuff[3]);
			st.wSecond = (realTime.timeValueBuff[4]*10 + realTime.timeValueBuff[5]);
			st.wMilliseconds = (realTime.timeValueBuff[6]*100 + realTime.timeValueBuff[7]*10 + realTime.timeValueBuff[8]);
			st.wDay = (realTime.timeValueBuff[9]*10 + realTime.timeValueBuff[10]);
			st.wMonth = (realTime.timeValueBuff[11]*10 + realTime.timeValueBuff[12]);
			st.wYear = (realTime.timeValueBuff[13]*1000 + realTime.timeValueBuff[14]*10 + realTime.timeValueBuff[15]*10 + realTime.timeValueBuff[16]);

			if(SetSystemTime(&st))
			{
				return 0;
			}
			else
			{
				return 52;
			}
		}
		else
		{
			return 51;
		}
	}
	else 
	{
		return 50;
	}
}