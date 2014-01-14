
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8L
;Program type             : Application
;Clock frequency          : 7,372800 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8L
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _ouputBuffUartIterator=R5
	.DEF _UARTtransmitterIsBisy=R4

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_compa_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _int_rxc
	RJMP _int_empty_handler
	RJMP _int_txc
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 04.01.2014
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8L
;Program type            : Application
;AVR Core Clock frequency: 7,372800 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;//#include <delay.h>
;#define BUFFER_SIZE 18
;#define MAX_LENGH_NMEA_MESSAGE 100
;#define NUMBER_OF_NMEA_MESSAGE 5
;#define TRUE 0xFF
;#define FALSE 0x00
;#define NULL_CHAR 0x00
;
;typedef struct
;{
;    unsigned char buffArray[MAX_LENGH_NMEA_MESSAGE];
;    unsigned char isProced;
;    unsigned char numberOfBytes;
;    unsigned char newData;
;    unsigned char uartError;
;}   nmeaBuff;
;
;struct
;{
;    nmeaBuff arr [NUMBER_OF_NMEA_MESSAGE];
;    nmeaBuff * ArrInpt;
;	nmeaBuff * ArrProc;
;    unsigned char numberOfCurrentInpArr;
;    unsigned char numberOfCurrentParseArr;
;    unsigned char nmeaInptBuffIterator;
;    unsigned char isDollarSymbolCatched;
;    unsigned char dataToParse;
;}	circularInputBuff;
;
;
;unsigned char ouputBuffUartIterator;
;unsigned char inputBuffUart[BUFFER_SIZE];
;unsigned char ouputBuffUart[BUFFER_SIZE];
;unsigned char readyBuffUart[BUFFER_SIZE];
;unsigned char UARTtransmitterIsBisy;
;
;
;void UART_data_send (void)
; 0000 003F {

	.CSEG
_UART_data_send:
; 0000 0040     if (!UARTtransmitterIsBisy)
	TST  R4
	BRNE _0x3
; 0000 0041     {
; 0000 0042         int i;
; 0000 0043         PORTD.2 = !PORTD.2; // #del
	SBIW R28,2
;	i -> Y+0
	SBIS 0x12,2
	RJMP _0x4
	CBI  0x12,2
	RJMP _0x5
_0x4:
	SBI  0x12,2
_0x5:
; 0000 0044         UARTtransmitterIsBisy = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0045         for(i = 0; i < BUFFER_SIZE; i++)
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
_0x7:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,18
	BRGE _0x8
; 0000 0046         {
; 0000 0047             ouputBuffUart [i] = readyBuffUart [i];
	LD   R26,Y
	LDD  R27,Y+1
	SUBI R26,LOW(-_ouputBuffUart)
	SBCI R27,HIGH(-_ouputBuffUart)
	LD   R30,Y
	LDD  R31,Y+1
	SUBI R30,LOW(-_readyBuffUart)
	SBCI R31,HIGH(-_readyBuffUart)
	LD   R30,Z
	ST   X,R30
; 0000 0048         }
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0x7
_0x8:
; 0000 0049         UDR = ouputBuffUart [0];
	LDS  R30,_ouputBuffUart
	OUT  0xC,R30
; 0000 004A         ouputBuffUartIterator = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 004B         //разрешаем прерывания по пустому буфферу
; 0000 004C         UCSRB = (1<<RXEN)|(1<<TXEN)|(1<<RXCIE)|(1<<TXCIE)|(1<<UDRIE);
	LDI  R30,LOW(248)
	OUT  0xA,R30
; 0000 004D     }
	ADIW R28,2
; 0000 004E }
_0x3:
	RET
;
;void NmeaReset (void)
; 0000 0051 {
_NmeaReset:
; 0000 0052     UCSRB = (0<<RXCIE);  //disable
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 0053     circularInputBuff.numberOfCurrentInpArr = 0;
	__PUTB1MN _circularInputBuff,524
; 0000 0054     circularInputBuff.isDollarSymbolCatched = 0;
	__PUTB1MN _circularInputBuff,527
; 0000 0055     circularInputBuff.dataToParse = 0;
	__PUTB1MN _circularInputBuff,528
; 0000 0056     UCSRB = (1<<RXCIE);  //enable
	LDI  R30,LOW(128)
	OUT  0xA,R30
; 0000 0057 }
	RET
;
;void indicationError(void)
; 0000 005A {
_indicationError:
; 0000 005B     PORTD = (1<<6);
	LDI  R30,LOW(64)
	OUT  0x12,R30
; 0000 005C }
	RET
;
;void nmeaParse (void)
; 0000 005F {
_nmeaParse:
; 0000 0060     while(circularInputBuff.dataToParse)
_0x9:
	__GETB1MN _circularInputBuff,528
	CPI  R30,0
	BRNE PC+2
	RJMP _0xB
; 0000 0061     {
; 0000 0062         char iinput;
; 0000 0063         char parrityControlGet;
; 0000 0064         char parrityControlCount;
; 0000 0065         char kouput = 0;
; 0000 0066         char symbolBuff;
; 0000 0067         char fatalErrorHappened;
; 0000 0068         char numOfBytes;
; 0000 0069 
; 0000 006A //        PORTD.6 = 0; //del
; 0000 006B 
; 0000 006C         if (circularInputBuff.dataToParse > NUMBER_OF_NMEA_MESSAGE) // circularInputBuff Overflow
	SBIW R28,7
	LDI  R30,LOW(0)
	STD  Y+3,R30
;	iinput -> Y+6
;	parrityControlGet -> Y+5
;	parrityControlCount -> Y+4
;	kouput -> Y+3
;	symbolBuff -> Y+2
;	fatalErrorHappened -> Y+1
;	numOfBytes -> Y+0
	__GETB2MN _circularInputBuff,528
	CPI  R26,LOW(0x6)
	BRLO _0xC
; 0000 006D         {
; 0000 006E             NmeaReset();
	RCALL _NmeaReset
; 0000 006F             indicationError();
	RCALL _indicationError
; 0000 0070             break;
	ADIW R28,7
	RJMP _0xB
; 0000 0071         }
; 0000 0072         while(kouput < NUMBER_OF_NMEA_MESSAGE)
_0xC:
_0xD:
	LDD  R26,Y+3
	CPI  R26,LOW(0x5)
	BRSH _0xF
; 0000 0073         {
; 0000 0074             circularInputBuff.ArrProc = &circularInputBuff.arr[circularInputBuff.numberOfCurrentParseArr];
	__GETB1MN _circularInputBuff,525
	LDI  R26,LOW(104)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_circularInputBuff)
	SBCI R31,HIGH(-_circularInputBuff)
	__PUTW1MN _circularInputBuff,522
; 0000 0075             circularInputBuff.numberOfCurrentParseArr++;
	__GETB1MN _circularInputBuff,525
	SUBI R30,-LOW(1)
	__PUTB1MN _circularInputBuff,525
	SUBI R30,LOW(1)
; 0000 0076             if(circularInputBuff.numberOfCurrentParseArr >= NUMBER_OF_NMEA_MESSAGE)
	__GETB2MN _circularInputBuff,525
	CPI  R26,LOW(0x5)
	BRLO _0x10
; 0000 0077             {
; 0000 0078                 circularInputBuff.numberOfCurrentParseArr = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _circularInputBuff,525
; 0000 0079             }
; 0000 007A             if(!circularInputBuff.ArrProc->isProced) break;
_0x10:
	__GETW2MN _circularInputBuff,522
	SUBI R26,LOW(-100)
	SBCI R27,HIGH(-100)
	LD   R30,X
	CPI  R30,0
	BREQ _0xF
; 0000 007B             kouput++;
	LDD  R30,Y+3
	SUBI R30,-LOW(1)
	STD  Y+3,R30
; 0000 007C         }
	RJMP _0xD
_0xF:
; 0000 007D         if(kouput >= NUMBER_OF_NMEA_MESSAGE)   //что-то совсем нехорошее: аппаратный сбой или переполнение кольцевого буффера
	LDD  R26,Y+3
	CPI  R26,LOW(0x5)
	BRLO _0x12
; 0000 007E         {
; 0000 007F             NmeaReset();
	RCALL _NmeaReset
; 0000 0080             indicationError();
	RCALL _indicationError
; 0000 0081             break;
	ADIW R28,7
	RJMP _0xB
; 0000 0082         }
; 0000 0083         kouput = 0;
_0x12:
	LDI  R30,LOW(0)
	STD  Y+3,R30
; 0000 0084         fatalErrorHappened = circularInputBuff.ArrProc->uartError;
	__GETW2MN _circularInputBuff,522
	SUBI R26,LOW(-103)
	SBCI R27,HIGH(-103)
	LD   R30,X
	STD  Y+1,R30
; 0000 0085         circularInputBuff.dataToParse--;
	__GETB1MN _circularInputBuff,528
	SUBI R30,LOW(1)
	__PUTB1MN _circularInputBuff,528
	SUBI R30,-LOW(1)
; 0000 0086         numOfBytes = circularInputBuff.ArrProc->numberOfBytes;
	__GETW2MN _circularInputBuff,522
	SUBI R26,LOW(-101)
	SBCI R27,HIGH(-101)
	LD   R30,X
	ST   Y,R30
; 0000 0087         circularInputBuff.ArrProc->newData = 0x00; //сбрасываем флаг
	__GETW2MN _circularInputBuff,522
	SUBI R26,LOW(-102)
	SBCI R27,HIGH(-102)
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0088 
; 0000 0089         if(circularInputBuff.ArrProc->buffArray[0] != 'G') return;
	__GETW2MN _circularInputBuff,522
	LD   R26,X
	CPI  R26,LOW(0x47)
	BRNE _0x2000001
; 0000 008A         if(circularInputBuff.ArrProc->buffArray[1] != 'P') return;
	__GETW1MN _circularInputBuff,522
	LDD  R26,Z+1
	CPI  R26,LOW(0x50)
	BRNE _0x2000001
; 0000 008B         if(circularInputBuff.ArrProc->buffArray[2] != 'Z') return;
	__GETW1MN _circularInputBuff,522
	LDD  R26,Z+2
	CPI  R26,LOW(0x5A)
	BRNE _0x2000001
; 0000 008C         if(circularInputBuff.ArrProc->buffArray[3] != 'D') return;
	__GETW1MN _circularInputBuff,522
	LDD  R26,Z+3
	CPI  R26,LOW(0x44)
	BRNE _0x2000001
; 0000 008D         if(circularInputBuff.ArrProc->buffArray[4] != 'A') return;
	__GETW1MN _circularInputBuff,522
	LDD  R26,Z+4
	CPI  R26,LOW(0x41)
	BRNE _0x2000001
; 0000 008E         if(circularInputBuff.ArrProc->buffArray[5] != ',') return;
	__GETW1MN _circularInputBuff,522
	LDD  R26,Z+5
	CPI  R26,LOW(0x2C)
	BREQ _0x18
_0x2000001:
	ADIW R28,7
	RET
; 0000 008F         parrityControlCount = 0x64;
_0x18:
	LDI  R30,LOW(100)
	STD  Y+4,R30
; 0000 0090 
; 0000 0091         for(iinput = 6; circularInputBuff.ArrProc->buffArray[iinput] != '*'; iinput++)
	LDI  R30,LOW(6)
	STD  Y+6,R30
_0x1A:
	__GETW2MN _circularInputBuff,522
	LDD  R30,Y+6
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0x2A)
	BREQ _0x1B
; 0000 0092         {
; 0000 0093             symbolBuff = circularInputBuff.ArrProc->buffArray[iinput];
	__GETW2MN _circularInputBuff,522
	LDD  R30,Y+6
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	STD  Y+2,R30
; 0000 0094             if (iinput >= numOfBytes) //(iinput >= MAX_LENGH_NMEA_MESSAGE)
	LD   R30,Y
	LDD  R26,Y+6
	CP   R26,R30
	BRLO _0x1C
; 0000 0095             {
; 0000 0096                 fatalErrorHappened |= 0xff;
	LDD  R30,Y+1
	ORI  R30,LOW(0xFF)
	STD  Y+1,R30
; 0000 0097                 break;
	RJMP _0x1B
; 0000 0098             }
; 0000 0099             parrityControlCount ^= symbolBuff;
_0x1C:
	LDD  R30,Y+2
	LDD  R26,Y+4
	EOR  R30,R26
	STD  Y+4,R30
; 0000 009A             if (symbolBuff == ',')
	LDD  R26,Y+2
	CPI  R26,LOW(0x2C)
	BREQ _0x19
; 0000 009B             {
; 0000 009C                 continue;
; 0000 009D             }
; 0000 009E             if (symbolBuff == '.')
	CPI  R26,LOW(0x2E)
	BREQ _0x19
; 0000 009F             {
; 0000 00A0                 continue;
; 0000 00A1             }
; 0000 00A2             symbolBuff &= 0x0f;   //from ACSII to BCD
	LDD  R30,Y+2
	ANDI R30,LOW(0xF)
	STD  Y+2,R30
; 0000 00A3             inputBuffUart[kouput] = symbolBuff;
	LDD  R30,Y+3
	LDI  R31,0
	SUBI R30,LOW(-_inputBuffUart)
	SBCI R31,HIGH(-_inputBuffUart)
	LDD  R26,Y+2
	STD  Z+0,R26
; 0000 00A4             kouput++;
	LDD  R30,Y+3
	SUBI R30,-LOW(1)
	STD  Y+3,R30
; 0000 00A5         }
_0x19:
	LDD  R30,Y+6
	SUBI R30,-LOW(1)
	STD  Y+6,R30
	RJMP _0x1A
_0x1B:
; 0000 00A6 
; 0000 00A7         // Control summ from ASCII to HEX
; 0000 00A8         iinput++;
	LDD  R30,Y+6
	SUBI R30,-LOW(1)
	STD  Y+6,R30
; 0000 00A9         parrityControlGet = circularInputBuff.ArrProc->buffArray[iinput];
	__GETW2MN _circularInputBuff,522
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	STD  Y+5,R30
; 0000 00AA         if(parrityControlGet & 0xC0) // if 0x4X
	ANDI R30,LOW(0xC0)
	BREQ _0x1F
; 0000 00AB         {
; 0000 00AC             parrityControlGet += 9;
	LDD  R30,Y+5
	SUBI R30,-LOW(9)
	STD  Y+5,R30
; 0000 00AD         }
; 0000 00AE         parrityControlGet &= 0x0f;
_0x1F:
	LDD  R30,Y+5
	ANDI R30,LOW(0xF)
	STD  Y+5,R30
; 0000 00AF         parrityControlGet <<=4;
	SWAP R30
	ANDI R30,0xF0
	STD  Y+5,R30
; 0000 00B0         iinput++;
	LDD  R30,Y+6
	SUBI R30,-LOW(1)
	STD  Y+6,R30
; 0000 00B1         symbolBuff = circularInputBuff.ArrProc->buffArray[iinput];
	__GETW2MN _circularInputBuff,522
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	STD  Y+2,R30
; 0000 00B2         if(symbolBuff & 0xC0) // if 0x4X
	ANDI R30,LOW(0xC0)
	BREQ _0x20
; 0000 00B3         {
; 0000 00B4             symbolBuff += 9;
	LDD  R30,Y+2
	SUBI R30,-LOW(9)
	STD  Y+2,R30
; 0000 00B5         }
; 0000 00B6         symbolBuff &= 0x0f;
_0x20:
	LDD  R30,Y+2
	ANDI R30,LOW(0xF)
	STD  Y+2,R30
; 0000 00B7         parrityControlGet |= symbolBuff;
	LDD  R26,Y+5
	OR   R30,R26
	STD  Y+5,R30
; 0000 00B8         if (parrityControlCount != parrityControlGet) fatalErrorHappened |= 0xff;
	LDD  R26,Y+4
	CP   R30,R26
	BREQ _0x21
	LDD  R30,Y+1
	ORI  R30,LOW(0xFF)
	STD  Y+1,R30
; 0000 00B9         fatalErrorHappened |= circularInputBuff.ArrProc->newData;
_0x21:
	__GETW2MN _circularInputBuff,522
	SUBI R26,LOW(-102)
	SBCI R27,HIGH(-102)
	LD   R30,X
	LDD  R26,Y+1
	OR   R30,R26
	STD  Y+1,R30
; 0000 00BA 
; 0000 00BB         if(fatalErrorHappened)   // убрать
	CPI  R30,0
	BREQ _0x22
; 0000 00BC         {
; 0000 00BD             indicationError();
	RCALL _indicationError
; 0000 00BE             inputBuffUart[17] = 0xff;
	LDI  R30,LOW(255)
	__PUTB1MN _inputBuffUart,17
; 0000 00BF         }                        // убрать
; 0000 00C0 
; 0000 00C1         if(!fatalErrorHappened)
_0x22:
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x23
; 0000 00C2         {
; 0000 00C3             inputBuffUart[17] = 0x00;
	LDI  R30,LOW(0)
	__PUTB1MN _inputBuffUart,17
; 0000 00C4             for(iinput = 0; iinput < BUFFER_SIZE; iinput++)
	STD  Y+6,R30
_0x25:
	LDD  R26,Y+6
	CPI  R26,LOW(0x12)
	BRSH _0x26
; 0000 00C5             {
; 0000 00C6                 readyBuffUart [iinput] = inputBuffUart[iinput];
	LDI  R27,0
	SUBI R26,LOW(-_readyBuffUart)
	SBCI R27,HIGH(-_readyBuffUart)
	LDD  R30,Y+6
	LDI  R31,0
	SUBI R30,LOW(-_inputBuffUart)
	SBCI R31,HIGH(-_inputBuffUart)
	LD   R30,Z
	ST   X,R30
; 0000 00C7             }
	LDD  R30,Y+6
	SUBI R30,-LOW(1)
	STD  Y+6,R30
	RJMP _0x25
_0x26:
; 0000 00C8         }
; 0000 00C9     }
_0x23:
	ADIW R28,7
	RJMP _0x9
_0xB:
; 0000 00CA }
	RET
;
;interrupt [USART_RXC] void int_rxc(void)
; 0000 00CD {
_int_rxc:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00CE     unsigned char udrBuff = UDR;
; 0000 00CF     unsigned char errorBuff = UCSRA;
; 0000 00D0     if(udrBuff == '$')
	RCALL __SAVELOCR2
;	udrBuff -> R17
;	errorBuff -> R16
	IN   R17,12
	IN   R16,11
	CPI  R17,36
	BRNE _0x27
; 0000 00D1     {
; 0000 00D2         circularInputBuff.ArrInpt = &circularInputBuff.arr[circularInputBuff.numberOfCurrentInpArr];
	__GETB1MN _circularInputBuff,524
	LDI  R26,LOW(104)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_circularInputBuff)
	SBCI R31,HIGH(-_circularInputBuff)
	__PUTW1MN _circularInputBuff,520
; 0000 00D3         circularInputBuff.ArrInpt->uartError = 0x00;
	__GETW2MN _circularInputBuff,520
	SUBI R26,LOW(-103)
	SBCI R27,HIGH(-103)
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00D4         circularInputBuff.ArrInpt->newData = 0xff;
	__GETW2MN _circularInputBuff,520
	SUBI R26,LOW(-102)
	SBCI R27,HIGH(-102)
	LDI  R30,LOW(255)
	ST   X,R30
; 0000 00D5         circularInputBuff.nmeaInptBuffIterator = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _circularInputBuff,526
; 0000 00D6         circularInputBuff.numberOfCurrentInpArr++;
	__GETB1MN _circularInputBuff,524
	SUBI R30,-LOW(1)
	__PUTB1MN _circularInputBuff,524
	SUBI R30,LOW(1)
; 0000 00D7         if(circularInputBuff.numberOfCurrentInpArr >= NUMBER_OF_NMEA_MESSAGE)
	__GETB2MN _circularInputBuff,524
	CPI  R26,LOW(0x5)
	BRLO _0x28
; 0000 00D8         {
; 0000 00D9             circularInputBuff.numberOfCurrentInpArr = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _circularInputBuff,524
; 0000 00DA         }
; 0000 00DB         circularInputBuff.isDollarSymbolCatched = 0xff;
_0x28:
	LDI  R30,LOW(255)
	__PUTB1MN _circularInputBuff,527
; 0000 00DC     }
; 0000 00DD     else
	RJMP _0x29
_0x27:
; 0000 00DE     {
; 0000 00DF         if((circularInputBuff.isDollarSymbolCatched)&&(circularInputBuff.nmeaInptBuffIterator < MAX_LENGH_NMEA_MESSAGE))
	__GETB1MN _circularInputBuff,527
	CPI  R30,0
	BREQ _0x2B
	__GETB2MN _circularInputBuff,526
	CPI  R26,LOW(0x64)
	BRLO _0x2C
_0x2B:
	RJMP _0x2A
_0x2C:
; 0000 00E0         {
; 0000 00E1             if(udrBuff == 0x0D)
	CPI  R17,13
	BRNE _0x2D
; 0000 00E2             {
; 0000 00E3                 circularInputBuff.ArrInpt->numberOfBytes = (circularInputBuff.nmeaInptBuffIterator - 3);
	__GETW2MN _circularInputBuff,520
	SUBI R26,LOW(-101)
	SBCI R27,HIGH(-101)
	__GETB1MN _circularInputBuff,526
	LDI  R31,0
	SBIW R30,3
	ST   X,R30
; 0000 00E4                 circularInputBuff.ArrInpt->isProced = 0x00;
	__GETW2MN _circularInputBuff,520
	SUBI R26,LOW(-100)
	SBCI R27,HIGH(-100)
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00E5                 circularInputBuff.isDollarSymbolCatched = 0x00;
	__PUTB1MN _circularInputBuff,527
; 0000 00E6                 circularInputBuff.dataToParse++;
	__GETB1MN _circularInputBuff,528
	SUBI R30,-LOW(1)
	__PUTB1MN _circularInputBuff,528
	RJMP _0x36
; 0000 00E7             }
; 0000 00E8             else
_0x2D:
; 0000 00E9             {
; 0000 00EA                 circularInputBuff.ArrInpt->buffArray[circularInputBuff.nmeaInptBuffIterator] = udrBuff;
	__GETW2MN _circularInputBuff,520
	__GETB1MN _circularInputBuff,526
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0000 00EB                 circularInputBuff.nmeaInptBuffIterator++;
	__GETB1MN _circularInputBuff,526
	SUBI R30,-LOW(1)
	__PUTB1MN _circularInputBuff,526
_0x36:
	SUBI R30,LOW(1)
; 0000 00EC             }
; 0000 00ED         }
; 0000 00EE     }
_0x2A:
_0x29:
; 0000 00EF     errorBuff &= 0x18;
	ANDI R16,LOW(24)
; 0000 00F0     circularInputBuff.ArrInpt->uartError |= errorBuff;
	__GETW2MN _circularInputBuff,520
	SUBI R26,LOW(-103)
	SBCI R27,HIGH(-103)
	LD   R30,X
	OR   R30,R16
	ST   X,R30
; 0000 00F1 }
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;interrupt [USART_DRE] void int_empty_handler(void)
; 0000 00F4 {
_int_empty_handler:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00F5     if(ouputBuffUartIterator < BUFFER_SIZE)
	LDI  R30,LOW(18)
	CP   R5,R30
	BRSH _0x2F
; 0000 00F6     {
; 0000 00F7         UDR = ouputBuffUart [ouputBuffUartIterator];
	MOV  R30,R5
	LDI  R31,0
	SUBI R30,LOW(-_ouputBuffUart)
	SBCI R31,HIGH(-_ouputBuffUart)
	LD   R30,Z
	OUT  0xC,R30
; 0000 00F8         ouputBuffUartIterator++;
	INC  R5
; 0000 00F9     }
; 0000 00FA     else
	RJMP _0x30
_0x2F:
; 0000 00FB     {
; 0000 00FC         //запрещаем прерывания по пустому буфферу
; 0000 00FD         UCSRB = (1<<RXEN)|(1<<TXEN)|(1<<RXCIE)|(1<<TXCIE)|(0<<UDRIE); //проверить!!
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 00FE         //юарт свободен
; 0000 00FF         UARTtransmitterIsBisy = 0;
	CLR  R4
; 0000 0100     }
_0x30:
; 0000 0101 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;interrupt [USART_TXC] void int_txc(void)
; 0000 0104 {
_int_txc:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0105     //запрещаем прерывания по пустому буфферу
; 0000 0106     UCSRB = (1<<RXEN)|(1<<TXEN)|(1<<RXCIE)|(1<<TXCIE)|(0<<UDRIE); //проверить!!
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0107     //юарт свободен
; 0000 0108     UARTtransmitterIsBisy = 0;
	CLR  R4
; 0000 0109 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 010D {
_timer1_compa_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 010E     if(GIFR &= 0x80)  //if ext interrupt 1 flag is true
	IN   R30,0x3A
	ANDI R30,LOW(0x80)
	OUT  0x3A,R30
	CPI  R30,0
	BREQ _0x31
; 0000 010F     {
; 0000 0110         UART_data_send();
	RCALL _UART_data_send
; 0000 0111         //GIFR = 0<<INTF1;
; 0000 0112     }
; 0000 0113 }
_0x31:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;
;void main(void)
; 0000 0117 {
_main:
; 0000 0118 // Declare your local variables here
; 0000 0119 
; 0000 011A // Input/Output Ports initialization
; 0000 011B // Port B initialization
; 0000 011C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 011D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 011E PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 011F DDRB=0x00;
	OUT  0x17,R30
; 0000 0120 
; 0000 0121 // Port C initialization
; 0000 0122 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0123 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0124 PORTC=0x00;
	OUT  0x15,R30
; 0000 0125 DDRC=0x00;
	OUT  0x14,R30
; 0000 0126 
; 0000 0127 // Port D initialization
; 0000 0128 // Func7=In Func6=Out Func5=In Func4=In Func3=In Func2=Out Func1=In Func0=In
; 0000 0129 // State7=T State6=0 State5=T State4=T State3=T State2=1 State1=T State0=T
; 0000 012A PORTD=0x04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 012B DDRD=0x44;
	LDI  R30,LOW(68)
	OUT  0x11,R30
; 0000 012C 
; 0000 012D // Timer/Counter 0 initialization
; 0000 012E // Clock source: System Clock
; 0000 012F // Clock value: Timer 0 Stopped
; 0000 0130 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0131 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0132 
; 0000 0133 // Timer/Counter 1 initialization
; 0000 0134 // Clock source: System Clock
; 0000 0135 // Clock value: 7,200 kHz
; 0000 0136 // Mode: CTC top=OCR1A
; 0000 0137 // OC1A output: Discon.
; 0000 0138 // OC1B output: Discon.
; 0000 0139 // Noise Canceler: Off
; 0000 013A // Input Capture on Falling Edge
; 0000 013B // Timer1 Overflow Interrupt: Off
; 0000 013C // Input Capture Interrupt: Off
; 0000 013D // Compare A Match Interrupt: On
; 0000 013E // Compare B Match Interrupt: Off
; 0000 013F TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0140 TCCR1B=0x0D;
	LDI  R30,LOW(13)
	OUT  0x2E,R30
; 0000 0141 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0142 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0143 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0144 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0145 OCR1AH=0x07;
	LDI  R30,LOW(7)
	OUT  0x2B,R30
; 0000 0146 OCR1AL=0x08;
	LDI  R30,LOW(8)
	OUT  0x2A,R30
; 0000 0147 OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 0148 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0149 
; 0000 014A // Timer/Counter 2 initialization
; 0000 014B // Clock source: System Clock
; 0000 014C // Clock value: Timer2 Stopped
; 0000 014D // Mode: Normal top=0xFF
; 0000 014E // OC2 output: Disconnected
; 0000 014F ASSR=0x00;
	OUT  0x22,R30
; 0000 0150 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0151 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0152 OCR2=0x00;
	OUT  0x23,R30
; 0000 0153 
; 0000 0154 // External Interrupt(s) initialization
; 0000 0155 // INT0: Off
; 0000 0156 // INT1: Off
; 0000 0157 // INT1 Mode: Falling Edge
; 0000 0158 GICR|=0x00;
	IN   R30,0x3B
	OUT  0x3B,R30
; 0000 0159 MCUCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x35,R30
; 0000 015A GIFR=0x80;
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 015B 
; 0000 015C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 015D TIMSK=0x10;
	LDI  R30,LOW(16)
	OUT  0x39,R30
; 0000 015E 
; 0000 015F // USART initialization
; 0000 0160 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0161 // USART Receiver: On
; 0000 0162 // USART Transmitter: On
; 0000 0163 // USART Mode: Asynchronous
; 0000 0164 // USART Baud Rate: 115200
; 0000 0165 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0166 UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0167 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0168 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0169 UBRRL=0x03;
	LDI  R30,LOW(3)
	OUT  0x9,R30
; 0000 016A 
; 0000 016B // Analog Comparator initialization
; 0000 016C // Analog Comparator: Off
; 0000 016D // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 016E ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 016F SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0170 
; 0000 0171 // ADC initialization
; 0000 0172 // ADC disabled
; 0000 0173 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0174 
; 0000 0175 // SPI initialization
; 0000 0176 // SPI disabled
; 0000 0177 SPCR=0x00;
	OUT  0xD,R30
; 0000 0178 
; 0000 0179 // TWI initialization
; 0000 017A // TWI disabled
; 0000 017B TWCR=0x00;
	OUT  0x36,R30
; 0000 017C 
; 0000 017D //readyBuff.hourH1 = 0x01;
; 0000 017E //readyBuff.hourL2 = 0x06;
; 0000 017F //readyBuff.minuteH1 = 0x02;
; 0000 0180 //readyBuff.minuteL2 = 0x06;
; 0000 0181 //readyBuff.secondH1 = 0x03;
; 0000 0182 //readyBuff.secondL2 = 0xff;
; 0000 0183 
; 0000 0184 circularInputBuff.numberOfCurrentInpArr = 0;
	__PUTB1MN _circularInputBuff,524
; 0000 0185 
; 0000 0186 // Global enable interrupts
; 0000 0187 #asm("sei");
	sei
; 0000 0188 
; 0000 0189 
; 0000 018A while (1)
_0x32:
; 0000 018B       {
; 0000 018C         nmeaParse();
	RCALL _nmeaParse
; 0000 018D       }
	RJMP _0x32
; 0000 018E }
_0x35:
	RJMP _0x35

	.DSEG
_circularInputBuff:
	.BYTE 0x211
_inputBuffUart:
	.BYTE 0x12
_ouputBuffUart:
	.BYTE 0x12
_readyBuffUart:
	.BYTE 0x12

	.CSEG

	.CSEG
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
