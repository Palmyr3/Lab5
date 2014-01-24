/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 04.01.2014
Author  : Palmyr3
Company : 
Comments: 


Chip type               : ATmega8L
Program type            : Application
AVR Core Clock frequency: 7,372800 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>

#define BUFFER_SIZE 20
#define TIME_BUFFER_SIZE 17
#define MAX_LENGH_NMEA_MESSAGE 100
#define NUMBER_OF_NMEA_MESSAGE 6

typedef struct
{
    unsigned char buffArray[MAX_LENGH_NMEA_MESSAGE];
    unsigned char isProced;
    unsigned char numberOfBytes;
    unsigned char newData;
    unsigned char uartError;  
}   nmeaBuff;

struct
{
    nmeaBuff arr [NUMBER_OF_NMEA_MESSAGE];
    nmeaBuff * ArrInpt;
	nmeaBuff * ArrProc;
    unsigned char numberOfCurrentInpArr;
    unsigned char numberOfCurrentParseArr;
    unsigned char nmeaInptBuffIterator;
    unsigned char isDollarSymbolCatched;
    unsigned char dataToParse;
}	circularInputBuff;

typedef struct
{
    unsigned char timeValueBuff[TIME_BUFFER_SIZE];
    unsigned char satteliteCatched;
    unsigned char fatalErrorZDA;
	unsigned char fatalErrorGSV;
}   nmeaTime;

nmeaTime inputNmeaTime;
nmeaTime readyNmeaTime;

unsigned char ouputBuffUartIterator;
unsigned char ouputBuffUart[BUFFER_SIZE];
unsigned char UARTtransmitterIsBisy;

void UART_data_send (void)
{
    if (!UARTtransmitterIsBisy)
    {   
        int i; 
        
        //PORTD.2 = !PORTD.2;
        
        UARTtransmitterIsBisy = 1;
        for(i = 0; i < TIME_BUFFER_SIZE; i++)
        { 
            ouputBuffUart [i] = readyNmeaTime.timeValueBuff [i];
        } 
        ouputBuffUart [17] = readyNmeaTime.fatalErrorZDA;
        ouputBuffUart [18] = readyNmeaTime.fatalErrorGSV;
        ouputBuffUart [19] = readyNmeaTime.satteliteCatched;
        UDR = ouputBuffUart [0];
        ouputBuffUartIterator = 1;
        //разрешаем прерывания по пустому буфферу
        UCSRB = (1<<RXEN)|(1<<TXEN)|(1<<RXCIE)|(1<<TXCIE)|(1<<UDRIE);
    }  
}

void NmeaReset (void)
{
    UCSRB = (0<<RXCIE);  //disable
    circularInputBuff.numberOfCurrentInpArr = 0;
    circularInputBuff.isDollarSymbolCatched = 0;
    circularInputBuff.dataToParse = 0;
    UCSRB = (1<<RXCIE);  //enable
}

void indicationError(void)
{
    PORTD = (1<<6);
}

void nmeaParse (void)
{
    while(circularInputBuff.dataToParse)
    {    
        char iinput; 
        char kouput = 0;
        char parrityControlGet;
        char parrityControlCount;
        char symbolBuff;
        char fatalErrorHappened;
        char numOfBytes; 
        
        if (circularInputBuff.dataToParse > NUMBER_OF_NMEA_MESSAGE) // circularInputBuff Overflow
        {
            NmeaReset();
            indicationError();
            break;
        }       
        while(kouput < NUMBER_OF_NMEA_MESSAGE)      
        { 
            circularInputBuff.ArrProc = &circularInputBuff.arr[circularInputBuff.numberOfCurrentParseArr];
            circularInputBuff.numberOfCurrentParseArr++;
            if(circularInputBuff.numberOfCurrentParseArr >= NUMBER_OF_NMEA_MESSAGE) 
            {
                circularInputBuff.numberOfCurrentParseArr = 0;
            }
            if(!circularInputBuff.ArrProc->isProced) break;
            kouput++;
        }
        if(kouput >= NUMBER_OF_NMEA_MESSAGE)   //something horrible: hard error or circularInputBuff Overflow
        {   
            NmeaReset();
            indicationError();
            break; 
        }
        kouput = 0;        
        fatalErrorHappened = circularInputBuff.ArrProc->uartError;
        circularInputBuff.dataToParse--;
        numOfBytes = circularInputBuff.ArrProc->numberOfBytes;
        circularInputBuff.ArrProc->newData = 0x00; //drop flag
        
        if(circularInputBuff.ArrProc->buffArray[0] != 'G') return;
        if(circularInputBuff.ArrProc->buffArray[1] != 'P') return; 
        
        if(circularInputBuff.ArrProc->buffArray[2] == 'Z') //return;                          
        {
            if(circularInputBuff.ArrProc->buffArray[3] != 'D') return;
            if(circularInputBuff.ArrProc->buffArray[4] != 'A') return;
            if(circularInputBuff.ArrProc->buffArray[5] != ',') return;
            parrityControlCount = 0x64;       
            
            for(iinput = 6; circularInputBuff.ArrProc->buffArray[iinput] != '*'; iinput++)
            {   
                symbolBuff = circularInputBuff.ArrProc->buffArray[iinput];
                if (iinput >= numOfBytes) //(iinput >= MAX_LENGH_NMEA_MESSAGE) 
                {
                    fatalErrorHappened |= 0xff;
                    break;
                }
                parrityControlCount ^= symbolBuff;
                if (symbolBuff == ',')
                {
                    continue;
                }
                if (symbolBuff == '.')
                {
                    continue;
                }
                symbolBuff &= 0x0f;   //from ACSII to BCD
                inputNmeaTime.timeValueBuff[kouput] = symbolBuff;
                kouput++;
            }
            
            // Control summ from ASCII to HEX
            iinput++; 
            parrityControlGet = circularInputBuff.ArrProc->buffArray[iinput]; 
            if(parrityControlGet & 0xC0) // if 0x4X
            {
                parrityControlGet += 9;
            }
            parrityControlGet &= 0x0f;
            parrityControlGet <<=4;
            iinput++;
            symbolBuff = circularInputBuff.ArrProc->buffArray[iinput];
            if(symbolBuff & 0xC0) // if 0x4X
            {
                symbolBuff += 9;
            }
            symbolBuff &= 0x0f;
            parrityControlGet |= symbolBuff;        
            if (parrityControlCount != parrityControlGet) fatalErrorHappened |= 0xff;
            fatalErrorHappened |= circularInputBuff.ArrProc->newData;
            
			inputNmeaTime.fatalErrorZDA = fatalErrorHappened; 
            
            if(fatalErrorHappened)   // убрать
            {
                indicationError();
            }                        // убрать
            
            readyNmeaTime.fatalErrorZDA = inputNmeaTime.fatalErrorZDA;
            readyNmeaTime.fatalErrorGSV = inputNmeaTime.fatalErrorGSV;
            readyNmeaTime.satteliteCatched = inputNmeaTime.satteliteCatched;
            for(iinput = 0; iinput < TIME_BUFFER_SIZE; iinput++)
            {   
                readyNmeaTime.timeValueBuff [iinput] = inputNmeaTime.timeValueBuff [iinput];
            }              
        }
        else
        {
			unsigned char j;
            if(circularInputBuff.ArrProc->buffArray[2] != 'G') return;
            if(circularInputBuff.ArrProc->buffArray[3] != 'S') return; 
            if(circularInputBuff.ArrProc->buffArray[4] != 'V') return;
            if(circularInputBuff.ArrProc->buffArray[5] != ',') return;
            //циф
            //,
            if(circularInputBuff.ArrProc->buffArray[8] == '1') 
            {
                inputNmeaTime.satteliteCatched = 0;    
            } 
            iinput = 12; // begin of description 1 satellite

			for( j = 0; j < 4; j++)
			{
				if(circularInputBuff.ArrProc->buffArray[iinput] == '*') 
				{
					break;
				}
				kouput = 0;
				while(kouput < 4)
				{
					if (iinput > numOfBytes) //(iinput >= MAX_LENGH_NMEA_MESSAGE) 
					{
						fatalErrorHappened |= 0xff;
						break;
					}
					if(circularInputBuff.ArrProc->buffArray[iinput] == ',') 
					{
						kouput++;
					}
					iinput++;
				}
				//iinput++;
				if((circularInputBuff.ArrProc->buffArray[iinput] != ',')&&(circularInputBuff.ArrProc->buffArray[iinput] != '*'))
				{
					if(circularInputBuff.ArrProc->buffArray[iinput] != '0') 
					{
						iinput++;
						inputNmeaTime.satteliteCatched++;
					}
					else
					{
						iinput++;
						if(circularInputBuff.ArrProc->buffArray[iinput] != '0')
						{
							inputNmeaTime.satteliteCatched++;
						}
					}
					iinput++;
				}
			}			
            fatalErrorHappened |= circularInputBuff.ArrProc->newData;

			if (iinput > numOfBytes) //(iinput >= MAX_LENGH_NMEA_MESSAGE) 
            {
				fatalErrorHappened |= 0xff;
            }
			inputNmeaTime.fatalErrorGSV = fatalErrorHappened;
			
			if(fatalErrorHappened)   // убрать
            {
                indicationError();
            }                        // убрать
        }
    }
}

interrupt [USART_RXC] void int_rxc(void)
{
    unsigned char udrBuff = UDR;
    unsigned char errorBuff = UCSRA;
    if(udrBuff == '$')
    {
        circularInputBuff.ArrInpt = &circularInputBuff.arr[circularInputBuff.numberOfCurrentInpArr];
        circularInputBuff.ArrInpt->uartError = 0x00;     
        circularInputBuff.ArrInpt->newData = 0xff;       
        circularInputBuff.nmeaInptBuffIterator = 0;
        circularInputBuff.numberOfCurrentInpArr++;
        if(circularInputBuff.numberOfCurrentInpArr >= NUMBER_OF_NMEA_MESSAGE) 
        {
            circularInputBuff.numberOfCurrentInpArr = 0;
        }
        circularInputBuff.isDollarSymbolCatched = 0xff;  
    }
    else
    {
        if((circularInputBuff.isDollarSymbolCatched)&&(circularInputBuff.nmeaInptBuffIterator < MAX_LENGH_NMEA_MESSAGE))
        {
            if(udrBuff == 0x0D)
            {
                circularInputBuff.ArrInpt->numberOfBytes = (circularInputBuff.nmeaInptBuffIterator - 3);
                circularInputBuff.ArrInpt->isProced = 0x00;
                circularInputBuff.isDollarSymbolCatched = 0x00;
                circularInputBuff.dataToParse++;
            }
            else
            {              
                circularInputBuff.ArrInpt->buffArray[circularInputBuff.nmeaInptBuffIterator] = udrBuff;
                circularInputBuff.nmeaInptBuffIterator++; 
            }
        }
    }
    errorBuff &= 0x18;
    circularInputBuff.ArrInpt->uartError |= errorBuff;      
}

interrupt [USART_DRE] void int_empty_handler(void)
{
    if(ouputBuffUartIterator < BUFFER_SIZE)
    {
        UDR = ouputBuffUart [ouputBuffUartIterator];
        ouputBuffUartIterator++;
    }
    else
    {           
        //запрещаем прерывания по пустому буфферу
        UCSRB = (1<<RXEN)|(1<<TXEN)|(1<<RXCIE)|(1<<TXCIE)|(0<<UDRIE); //проверить!!  
        //юарт свободен
        UARTtransmitterIsBisy = 0;
    }    
}

interrupt [USART_TXC] void int_txc(void)
{
    //запрещаем прерывания по пустому буфферу
    UCSRB = (1<<RXEN)|(1<<TXEN)|(1<<RXCIE)|(1<<TXCIE)|(0<<UDRIE); //проверить!!  
    //юарт свободен
    UARTtransmitterIsBisy = 0; 
}

// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
    if(GIFR &= 0x80)  //if ext interrupt 1 flag is true
    { 
        UART_data_send();
        //GIFR = 0<<INTF1; 
    }
}


void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=Out Func5=In Func4=In Func3=In Func2=Out Func1=In Func0=In 
// State7=T State6=0 State5=T State4=T State3=T State2=1 State1=T State0=T 
PORTD=0x04;
DDRD=0x44;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 7,200 kHz
// Mode: CTC top=OCR1A
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x0D;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x07;
OCR1AL=0x08;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT1 Mode: Falling Edge
GICR|=0x00;
MCUCR=0x08;
GIFR=0x80;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x10;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 115200
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x03;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

//readyBuff.hourH1 = 0x01;
//readyBuff.hourL2 = 0x06;
//readyBuff.minuteH1 = 0x02;
//readyBuff.minuteL2 = 0x06;
//readyBuff.secondH1 = 0x03;
//readyBuff.secondL2 = 0xff;

circularInputBuff.numberOfCurrentInpArr = 0;

// Global enable interrupts
#asm("sei");


while (1)
      {
        nmeaParse();
      }
}
