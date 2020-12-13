
_readFromRTC:

;EE366_Project.c,17 :: 		unsigned short readFromRTC(unsigned short address) {
;EE366_Project.c,19 :: 		I2C1_Start();  			//Issue I2C start signal
	CALL        _I2C1_Start+0, 0
;EE366_Project.c,20 :: 		I2C1_Wr(0xD0); 			//DS1307 address (0x68) + Write (zero) = 0xD0
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;EE366_Project.c,21 :: 		I2C1_Wr(address);		//Adress of DS1307 location
	MOVF        FARG_readFromRTC_address+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;EE366_Project.c,22 :: 		I2C1_Repeated_Start();	//Issue repeated start signal
	CALL        _I2C1_Repeated_Start+0, 0
;EE366_Project.c,23 :: 		I2C1_Wr(0xD1); 			//Address 0x68 + Read (one) = 0xD1
	MOVLW       209
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;EE366_Project.c,24 :: 		readValues=I2C1_Rd(0); 	//Read 1 byte from DS1307, send not acknowledge
	CLRF        FARG_I2C1_Rd_ack+0 
	CALL        _I2C1_Rd+0, 0
	MOVF        R0, 0 
	MOVWF       readFromRTC_readValues_L0+0 
;EE366_Project.c,25 :: 		I2C1_Stop(); 			//Issue stop signal
	CALL        _I2C1_Stop+0, 0
;EE366_Project.c,26 :: 		return(readValues);
	MOVF        readFromRTC_readValues_L0+0, 0 
	MOVWF       R0 
;EE366_Project.c,27 :: 		}
L_end_readFromRTC:
	RETURN      0
; end of _readFromRTC

_writeOnRTC:

;EE366_Project.c,29 :: 		void writeOnRTC(unsigned short address, unsigned short writeValues) {
;EE366_Project.c,30 :: 		I2C1_Start(); 			//Issue I2C start signal
	CALL        _I2C1_Start+0, 0
;EE366_Project.c,31 :: 		I2C1_Wr(0xD0); 			//DS1307 address (0x68) + Write (zero) = 0xD0
	MOVLW       208
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;EE366_Project.c,32 :: 		I2C1_Wr(address); 		//Address of DS1307 location
	MOVF        FARG_writeOnRTC_address+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;EE366_Project.c,33 :: 		I2C1_Wr(writeValues);	//Send the data we want to write
	MOVF        FARG_writeOnRTC_writeValues+0, 0 
	MOVWF       FARG_I2C1_Wr_data_+0 
	CALL        _I2C1_Wr+0, 0
;EE366_Project.c,34 :: 		I2C1_Stop(); 			//Issue stop signal
	CALL        _I2C1_Stop+0, 0
;EE366_Project.c,35 :: 		}
L_end_writeOnRTC:
	RETURN      0
; end of _writeOnRTC

_MSBofBCD:

;EE366_Project.c,38 :: 		unsigned char MSBofBCD(unsigned char x) {
;EE366_Project.c,39 :: 		return ((x >> 4) + '0');
	MOVF        FARG_MSBofBCD_x+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       48
	ADDWF       R0, 1 
;EE366_Project.c,40 :: 		}
L_end_MSBofBCD:
	RETURN      0
; end of _MSBofBCD

_LSBofBCD:

;EE366_Project.c,42 :: 		unsigned char LSBofBCD(unsigned char x) {
;EE366_Project.c,43 :: 		return ((x & 0x0F) + '0');
	MOVLW       15
	ANDWF       FARG_LSBofBCD_x+0, 0 
	MOVWF       R0 
	MOVLW       48
	ADDWF       R0, 1 
;EE366_Project.c,44 :: 		}
L_end_LSBofBCD:
	RETURN      0
; end of _LSBofBCD

_alarmPattern:

;EE366_Project.c,47 :: 		void alarmPattern(int choice){
;EE366_Project.c,48 :: 		if (choice == 1) {
	MOVLW       0
	XORWF       FARG_alarmPattern_choice+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__alarmPattern91
	MOVLW       1
	XORWF       FARG_alarmPattern_choice+0, 0 
L__alarmPattern91:
	BTFSS       STATUS+0, 2 
	GOTO        L_alarmPattern0
;EE366_Project.c,49 :: 		PORTD.B0=1; PORTD.B1=0; PORTD.B2=1; PORTD.B3=0;
	BSF         PORTD+0, 0 
	BCF         PORTD+0, 1 
	BSF         PORTD+0, 2 
	BCF         PORTD+0, 3 
;EE366_Project.c,50 :: 		Delay_ms(70);
	MOVLW       182
	MOVWF       R12, 0
	MOVLW       208
	MOVWF       R13, 0
L_alarmPattern1:
	DECFSZ      R13, 1, 1
	BRA         L_alarmPattern1
	DECFSZ      R12, 1, 1
	BRA         L_alarmPattern1
	NOP
;EE366_Project.c,51 :: 		PORTD.B0=0; PORTD.B1=1; PORTD.B2=0; PORTD.B3=1;
	BCF         PORTD+0, 0 
	BSF         PORTD+0, 1 
	BCF         PORTD+0, 2 
	BSF         PORTD+0, 3 
;EE366_Project.c,52 :: 		Delay_ms(70);
	MOVLW       182
	MOVWF       R12, 0
	MOVLW       208
	MOVWF       R13, 0
L_alarmPattern2:
	DECFSZ      R13, 1, 1
	BRA         L_alarmPattern2
	DECFSZ      R12, 1, 1
	BRA         L_alarmPattern2
	NOP
;EE366_Project.c,53 :: 		}
	GOTO        L_alarmPattern3
L_alarmPattern0:
;EE366_Project.c,54 :: 		else if (choice == 2) {
	MOVLW       0
	XORWF       FARG_alarmPattern_choice+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__alarmPattern92
	MOVLW       2
	XORWF       FARG_alarmPattern_choice+0, 0 
L__alarmPattern92:
	BTFSS       STATUS+0, 2 
	GOTO        L_alarmPattern4
;EE366_Project.c,55 :: 		PORTD.B0=0; PORTD.B1=1; PORTD.B2=1; PORTD.B3=0;
	BCF         PORTD+0, 0 
	BSF         PORTD+0, 1 
	BSF         PORTD+0, 2 
	BCF         PORTD+0, 3 
;EE366_Project.c,56 :: 		Delay_ms(70);
	MOVLW       182
	MOVWF       R12, 0
	MOVLW       208
	MOVWF       R13, 0
L_alarmPattern5:
	DECFSZ      R13, 1, 1
	BRA         L_alarmPattern5
	DECFSZ      R12, 1, 1
	BRA         L_alarmPattern5
	NOP
;EE366_Project.c,57 :: 		PORTD.B0=1; PORTD.B1=0; PORTD.B2=0; PORTD.B3=1;
	BSF         PORTD+0, 0 
	BCF         PORTD+0, 1 
	BCF         PORTD+0, 2 
	BSF         PORTD+0, 3 
;EE366_Project.c,58 :: 		Delay_ms(70);
	MOVLW       182
	MOVWF       R12, 0
	MOVLW       208
	MOVWF       R13, 0
L_alarmPattern6:
	DECFSZ      R13, 1, 1
	BRA         L_alarmPattern6
	DECFSZ      R12, 1, 1
	BRA         L_alarmPattern6
	NOP
;EE366_Project.c,59 :: 		}
	GOTO        L_alarmPattern7
L_alarmPattern4:
;EE366_Project.c,60 :: 		else if (choice == 3) {
	MOVLW       0
	XORWF       FARG_alarmPattern_choice+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__alarmPattern93
	MOVLW       3
	XORWF       FARG_alarmPattern_choice+0, 0 
L__alarmPattern93:
	BTFSS       STATUS+0, 2 
	GOTO        L_alarmPattern8
;EE366_Project.c,61 :: 		PORTD.B0=1; PORTD.B1=1; PORTD.B2=1; PORTD.B3=1;
	BSF         PORTD+0, 0 
	BSF         PORTD+0, 1 
	BSF         PORTD+0, 2 
	BSF         PORTD+0, 3 
;EE366_Project.c,62 :: 		Delay_ms(70);
	MOVLW       182
	MOVWF       R12, 0
	MOVLW       208
	MOVWF       R13, 0
L_alarmPattern9:
	DECFSZ      R13, 1, 1
	BRA         L_alarmPattern9
	DECFSZ      R12, 1, 1
	BRA         L_alarmPattern9
	NOP
;EE366_Project.c,63 :: 		PORTD.B0=0; PORTD.B1=0; PORTD.B2=0; PORTD.B3=0;
	BCF         PORTD+0, 0 
	BCF         PORTD+0, 1 
	BCF         PORTD+0, 2 
	BCF         PORTD+0, 3 
;EE366_Project.c,64 :: 		Delay_ms(70);
	MOVLW       182
	MOVWF       R12, 0
	MOVLW       208
	MOVWF       R13, 0
L_alarmPattern10:
	DECFSZ      R13, 1, 1
	BRA         L_alarmPattern10
	DECFSZ      R12, 1, 1
	BRA         L_alarmPattern10
	NOP
;EE366_Project.c,65 :: 		}
L_alarmPattern8:
L_alarmPattern7:
L_alarmPattern3:
;EE366_Project.c,66 :: 		}
L_end_alarmPattern:
	RETURN      0
; end of _alarmPattern

_main:

;EE366_Project.c,85 :: 		void main() {
;EE366_Project.c,87 :: 		ADCON1 = 0x0F; 				//IO -> digital
	MOVLW       15
	MOVWF       ADCON1+0 
;EE366_Project.c,88 :: 		TRISD.B0 = 0;				//PORTD (LED) -> output
	BCF         TRISD+0, 0 
;EE366_Project.c,89 :: 		TRISD.B1 = 0;
	BCF         TRISD+0, 1 
;EE366_Project.c,90 :: 		TRISD.B2 = 0;
	BCF         TRISD+0, 2 
;EE366_Project.c,91 :: 		TRISD.B3 = 0;
	BCF         TRISD+0, 3 
;EE366_Project.c,92 :: 		TRISA = 0xFF; 				//PORTA (buttons) -> input
	MOVLW       255
	MOVWF       TRISA+0 
;EE366_Project.c,93 :: 		OSCCON = 0x73; 				//8MHz internal oscillator
	MOVLW       115
	MOVWF       OSCCON+0 
;EE366_Project.c,94 :: 		I2C1_Init(100000);			//DS1307 I2C running at 100KHz
	MOVLW       20
	MOVWF       SSPADD+0 
	CALL        _I2C1_Init+0, 0
;EE366_Project.c,95 :: 		Lcd_Init();					//Initialize LCD
	CALL        _Lcd_Init+0, 0
;EE366_Project.c,96 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);   //LCD cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;EE366_Project.c,98 :: 		Lcd_out(1,1,"  Digital  Clock  ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_EE366_Project+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_EE366_Project+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;EE366_Project.c,99 :: 		Lcd_out(2,1," by:  Ruba & Nada ");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_EE366_Project+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_EE366_Project+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;EE366_Project.c,100 :: 		Delay_ms(500);
	MOVLW       6
	MOVWF       R11, 0
	MOVLW       19
	MOVWF       R12, 0
	MOVLW       173
	MOVWF       R13, 0
L_main11:
	DECFSZ      R13, 1, 1
	BRA         L_main11
	DECFSZ      R12, 1, 1
	BRA         L_main11
	DECFSZ      R11, 1, 1
	BRA         L_main11
	NOP
	NOP
;EE366_Project.c,101 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;EE366_Project.c,103 :: 		while(1) {
L_main12:
;EE366_Project.c,105 :: 		set = 0;
	CLRF        _set+0 
;EE366_Project.c,106 :: 		if(PORTA.B1 == 0) { //SET btn is pressed
	BTFSC       PORTA+0, 1 
	GOTO        L_main14
;EE366_Project.c,107 :: 		Delay_ms(30);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_main15:
	DECFSZ      R13, 1, 1
	BRA         L_main15
	DECFSZ      R12, 1, 1
	BRA         L_main15
;EE366_Project.c,108 :: 		if(PORTA.B1 == 0) {
	BTFSC       PORTA+0, 1 
	GOTO        L_main16
;EE366_Project.c,109 :: 		setCounter++;
	INCF        _setCounter+0, 1 
;EE366_Project.c,110 :: 		if(setCounter >= 7)
	MOVLW       7
	SUBWF       _setCounter+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_main17
;EE366_Project.c,111 :: 		setCounter = 0;
	CLRF        _setCounter+0 
L_main17:
;EE366_Project.c,112 :: 		}
L_main16:
;EE366_Project.c,113 :: 		}
L_main14:
;EE366_Project.c,114 :: 		if(setCounter) { //Any value but zero
	MOVF        _setCounter+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main18
;EE366_Project.c,115 :: 		if(PORTA.B3 == 0) {
	BTFSC       PORTA+0, 3 
	GOTO        L_main19
;EE366_Project.c,116 :: 		Delay_ms(30);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_main20:
	DECFSZ      R13, 1, 1
	BRA         L_main20
	DECFSZ      R12, 1, 1
	BRA         L_main20
;EE366_Project.c,117 :: 		if(PORTA.B3 == 0) //UP btn
	BTFSC       PORTA+0, 3 
	GOTO        L_main21
;EE366_Project.c,118 :: 		set = 1;
	MOVLW       1
	MOVWF       _set+0 
L_main21:
;EE366_Project.c,119 :: 		}
L_main19:
;EE366_Project.c,120 :: 		if(PORTA.B4 == 0) {
	BTFSC       PORTA+0, 4 
	GOTO        L_main22
;EE366_Project.c,121 :: 		Delay_ms(30);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_main23:
	DECFSZ      R13, 1, 1
	BRA         L_main23
	DECFSZ      R12, 1, 1
	BRA         L_main23
;EE366_Project.c,122 :: 		if(PORTA.B4 == 0) //DOWN btn
	BTFSC       PORTA+0, 4 
	GOTO        L_main24
;EE366_Project.c,123 :: 		set = -1;
	MOVLW       255
	MOVWF       _set+0 
L_main24:
;EE366_Project.c,124 :: 		}
L_main22:
;EE366_Project.c,126 :: 		if(setCounter && set) { //Any value but zero
	MOVF        _setCounter+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main27
	MOVF        _set+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main27
L__main85:
;EE366_Project.c,127 :: 		switch(setCounter) {
	GOTO        L_main28
;EE366_Project.c,128 :: 		case 1: //Hours
L_main30:
;EE366_Project.c,129 :: 		hour = readFromRTC(2);			//Read hour from DS1307
	MOVLW       2
	MOVWF       FARG_readFromRTC_address+0 
	CALL        _readFromRTC+0, 0
	MOVF        R0, 0 
	MOVWF       _hour+0 
	MOVLW       0
	MOVWF       _hour+1 
;EE366_Project.c,130 :: 		hour = Bcd2Dec(hour);			//Convert reading to decimal
	MOVF        _hour+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	MOVWF       _hour+0 
	MOVLW       0
	MOVWF       _hour+1 
;EE366_Project.c,131 :: 		hour = hour + set;				//Increment or decrement
	MOVF        _set+0, 0 
	ADDWF       _hour+0, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       _set+0, 7 
	MOVLW       255
	ADDWFC      _hour+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _hour+0 
	MOVF        R2, 0 
	MOVWF       _hour+1 
;EE366_Project.c,132 :: 		if(hour >= 24)					//If at 23 and user increments
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main95
	MOVLW       24
	SUBWF       R1, 0 
L__main95:
	BTFSS       STATUS+0, 0 
	GOTO        L_main31
;EE366_Project.c,133 :: 		hour = 0;					//Reset to 0 (midnight)
	CLRF        _hour+0 
	CLRF        _hour+1 
	GOTO        L_main32
L_main31:
;EE366_Project.c,134 :: 		else if(hour < 0)				//If at 0 and user decrements
	MOVLW       128
	XORWF       _hour+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main96
	MOVLW       0
	SUBWF       _hour+0, 0 
L__main96:
	BTFSC       STATUS+0, 0 
	GOTO        L_main33
;EE366_Project.c,135 :: 		hour = 23;					//Go back to 23
	MOVLW       23
	MOVWF       _hour+0 
	MOVLW       0
	MOVWF       _hour+1 
L_main33:
L_main32:
;EE366_Project.c,136 :: 		hour = Dec2Bcd(hour);			//Convert back to BCD
	MOVF        _hour+0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _hour+0 
	MOVLW       0
	MOVWF       _hour+1 
;EE366_Project.c,137 :: 		writeOnRTC(2, hour);			//Write hour on DS1307
	MOVLW       2
	MOVWF       FARG_writeOnRTC_address+0 
	MOVF        _hour+0, 0 
	MOVWF       FARG_writeOnRTC_writeValues+0 
	CALL        _writeOnRTC+0, 0
;EE366_Project.c,138 :: 		break;
	GOTO        L_main29
;EE366_Project.c,140 :: 		case 2: //Minutes
L_main34:
;EE366_Project.c,141 :: 		minute = readFromRTC(1);		//Read minute from DS1307
	MOVLW       1
	MOVWF       FARG_readFromRTC_address+0 
	CALL        _readFromRTC+0, 0
	MOVF        R0, 0 
	MOVWF       _minute+0 
	MOVLW       0
	MOVWF       _minute+1 
;EE366_Project.c,142 :: 		minute = Bcd2Dec(minute);		//Convert reading to decimal
	MOVF        _minute+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	MOVWF       _minute+0 
	MOVLW       0
	MOVWF       _minute+1 
;EE366_Project.c,143 :: 		minute = minute + set;			//Increment or decrement
	MOVF        _set+0, 0 
	ADDWF       _minute+0, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       _set+0, 7 
	MOVLW       255
	ADDWFC      _minute+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _minute+0 
	MOVF        R2, 0 
	MOVWF       _minute+1 
;EE366_Project.c,144 :: 		if(minute >= 60)				//If at 59 and user increments
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main97
	MOVLW       60
	SUBWF       R1, 0 
L__main97:
	BTFSS       STATUS+0, 0 
	GOTO        L_main35
;EE366_Project.c,145 :: 		minute = 0;					//Reset to 0
	CLRF        _minute+0 
	CLRF        _minute+1 
L_main35:
;EE366_Project.c,146 :: 		if(minute < 0)					//If at 0 and user decrements
	MOVLW       128
	XORWF       _minute+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main98
	MOVLW       0
	SUBWF       _minute+0, 0 
L__main98:
	BTFSC       STATUS+0, 0 
	GOTO        L_main36
;EE366_Project.c,147 :: 		minute = 59;				//Go back to 59
	MOVLW       59
	MOVWF       _minute+0 
	MOVLW       0
	MOVWF       _minute+1 
L_main36:
;EE366_Project.c,148 :: 		minute = Dec2Bcd(minute);		//Convert back to BCD
	MOVF        _minute+0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _minute+0 
	MOVLW       0
	MOVWF       _minute+1 
;EE366_Project.c,149 :: 		writeOnRTC(1, minute);			//Write hour on DS1307
	MOVLW       1
	MOVWF       FARG_writeOnRTC_address+0 
	MOVF        _minute+0, 0 
	MOVWF       FARG_writeOnRTC_writeValues+0 
	CALL        _writeOnRTC+0, 0
;EE366_Project.c,150 :: 		break;
	GOTO        L_main29
;EE366_Project.c,152 :: 		case 3: //Seconds
L_main37:
;EE366_Project.c,153 :: 		second = readFromRTC(0);		//Read second from DS1307
	CLRF        FARG_readFromRTC_address+0 
	CALL        _readFromRTC+0, 0
	MOVF        R0, 0 
	MOVWF       _second+0 
	MOVLW       0
	MOVWF       _second+1 
;EE366_Project.c,154 :: 		second = Bcd2Dec(second);		//Convert reading to decimal
	MOVF        _second+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	MOVWF       _second+0 
	MOVLW       0
	MOVWF       _second+1 
;EE366_Project.c,155 :: 		second = second + set;			//Increment or decrement
	MOVF        _set+0, 0 
	ADDWF       _second+0, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       _set+0, 7 
	MOVLW       255
	ADDWFC      _second+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _second+0 
	MOVF        R2, 0 
	MOVWF       _second+1 
;EE366_Project.c,156 :: 		if(second >= 60)				//If at 59 and user increments
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main99
	MOVLW       60
	SUBWF       R1, 0 
L__main99:
	BTFSS       STATUS+0, 0 
	GOTO        L_main38
;EE366_Project.c,157 :: 		second = 0;					//Reset to 0
	CLRF        _second+0 
	CLRF        _second+1 
L_main38:
;EE366_Project.c,158 :: 		if(second < 0)					//If at 0 and user decrements
	MOVLW       128
	XORWF       _second+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main100
	MOVLW       0
	SUBWF       _second+0, 0 
L__main100:
	BTFSC       STATUS+0, 0 
	GOTO        L_main39
;EE366_Project.c,159 :: 		second = 59;				//Go back to 59
	MOVLW       59
	MOVWF       _second+0 
	MOVLW       0
	MOVWF       _second+1 
L_main39:
;EE366_Project.c,160 :: 		second = Dec2Bcd(second);		//Convert back to BCD
	MOVF        _second+0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _second+0 
	MOVLW       0
	MOVWF       _second+1 
;EE366_Project.c,161 :: 		writeOnRTC(0, second);			//Write second on DS1307
	CLRF        FARG_writeOnRTC_address+0 
	MOVF        _second+0, 0 
	MOVWF       FARG_writeOnRTC_writeValues+0 
	CALL        _writeOnRTC+0, 0
;EE366_Project.c,162 :: 		break;
	GOTO        L_main29
;EE366_Project.c,164 :: 		case 4: //Days
L_main40:
;EE366_Project.c,165 :: 		day = readFromRTC(4);			//Read day from DS1307
	MOVLW       4
	MOVWF       FARG_readFromRTC_address+0 
	CALL        _readFromRTC+0, 0
	MOVF        R0, 0 
	MOVWF       _day+0 
	MOVLW       0
	MOVWF       _day+1 
;EE366_Project.c,166 :: 		day = Bcd2Dec(day);				//Convert reading to decimal
	MOVF        _day+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	MOVWF       _day+0 
	MOVLW       0
	MOVWF       _day+1 
;EE366_Project.c,167 :: 		day = day + set;				//Increment or decrement
	MOVF        _set+0, 0 
	ADDWF       _day+0, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       _set+0, 7 
	MOVLW       255
	ADDWFC      _day+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _day+0 
	MOVF        R2, 0 
	MOVWF       _day+1 
;EE366_Project.c,168 :: 		if(day >= 32)					//If at 31 and user increments
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main101
	MOVLW       32
	SUBWF       R1, 0 
L__main101:
	BTFSS       STATUS+0, 0 
	GOTO        L_main41
;EE366_Project.c,169 :: 		day = 1;					//Reset to 1
	MOVLW       1
	MOVWF       _day+0 
	MOVLW       0
	MOVWF       _day+1 
L_main41:
;EE366_Project.c,170 :: 		if(day <= 0)					//If at 1 and user decrements
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _day+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main102
	MOVF        _day+0, 0 
	SUBLW       0
L__main102:
	BTFSS       STATUS+0, 0 
	GOTO        L_main42
;EE366_Project.c,171 :: 		day = 31;					//Go back to 31
	MOVLW       31
	MOVWF       _day+0 
	MOVLW       0
	MOVWF       _day+1 
L_main42:
;EE366_Project.c,172 :: 		day = Dec2Bcd(day);				//Convert back to BCD
	MOVF        _day+0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _day+0 
	MOVLW       0
	MOVWF       _day+1 
;EE366_Project.c,173 :: 		writeOnRTC(4, day);				//Write day on DS1307
	MOVLW       4
	MOVWF       FARG_writeOnRTC_address+0 
	MOVF        _day+0, 0 
	MOVWF       FARG_writeOnRTC_writeValues+0 
	CALL        _writeOnRTC+0, 0
;EE366_Project.c,174 :: 		break;
	GOTO        L_main29
;EE366_Project.c,176 :: 		case 5: //Months
L_main43:
;EE366_Project.c,177 :: 		month = readFromRTC(5);			//Read month from DS1307
	MOVLW       5
	MOVWF       FARG_readFromRTC_address+0 
	CALL        _readFromRTC+0, 0
	MOVF        R0, 0 
	MOVWF       _month+0 
	MOVLW       0
	MOVWF       _month+1 
;EE366_Project.c,178 :: 		month = Bcd2Dec(month);			//Convert reading to decimal
	MOVF        _month+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	MOVWF       _month+0 
	MOVLW       0
	MOVWF       _month+1 
;EE366_Project.c,179 :: 		month = month + set;			//Increment or decrement
	MOVF        _set+0, 0 
	ADDWF       _month+0, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       _set+0, 7 
	MOVLW       255
	ADDWFC      _month+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _month+0 
	MOVF        R2, 0 
	MOVWF       _month+1 
;EE366_Project.c,180 :: 		if(month > 12)					//If at 12 and user increments
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main103
	MOVF        R1, 0 
	SUBLW       12
L__main103:
	BTFSC       STATUS+0, 0 
	GOTO        L_main44
;EE366_Project.c,181 :: 		month = 1;					//Reset to 1
	MOVLW       1
	MOVWF       _month+0 
	MOVLW       0
	MOVWF       _month+1 
L_main44:
;EE366_Project.c,182 :: 		if(month <= 0)					//If at 1 and user decrements
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _month+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main104
	MOVF        _month+0, 0 
	SUBLW       0
L__main104:
	BTFSS       STATUS+0, 0 
	GOTO        L_main45
;EE366_Project.c,183 :: 		month = 12;					//Go back to 12
	MOVLW       12
	MOVWF       _month+0 
	MOVLW       0
	MOVWF       _month+1 
L_main45:
;EE366_Project.c,184 :: 		month = Dec2Bcd(month);			//Convert back to BCD
	MOVF        _month+0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _month+0 
	MOVLW       0
	MOVWF       _month+1 
;EE366_Project.c,185 :: 		writeOnRTC(5,month);			//Write month on DS1307
	MOVLW       5
	MOVWF       FARG_writeOnRTC_address+0 
	MOVF        _month+0, 0 
	MOVWF       FARG_writeOnRTC_writeValues+0 
	CALL        _writeOnRTC+0, 0
;EE366_Project.c,186 :: 		break;
	GOTO        L_main29
;EE366_Project.c,188 :: 		case 6: //Years
L_main46:
;EE366_Project.c,189 :: 		year = readFromRTC(6);			//Read hour from DS1307
	MOVLW       6
	MOVWF       FARG_readFromRTC_address+0 
	CALL        _readFromRTC+0, 0
	MOVF        R0, 0 
	MOVWF       _year+0 
	MOVLW       0
	MOVWF       _year+1 
;EE366_Project.c,190 :: 		year = Bcd2Dec(year);			//Convert reading to decimal
	MOVF        _year+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	MOVWF       _year+0 
	MOVLW       0
	MOVWF       _year+1 
;EE366_Project.c,191 :: 		year = year + set;				//Increment or decrement
	MOVF        _set+0, 0 
	ADDWF       _year+0, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       _set+0, 7 
	MOVLW       255
	ADDWFC      _year+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _year+0 
	MOVF        R2, 0 
	MOVWF       _year+1 
;EE366_Project.c,192 :: 		if(year < 15)
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main105
	MOVLW       15
	SUBWF       R1, 0 
L__main105:
	BTFSC       STATUS+0, 0 
	GOTO        L_main47
;EE366_Project.c,193 :: 		year = 30;
	MOVLW       30
	MOVWF       _year+0 
	MOVLW       0
	MOVWF       _year+1 
L_main47:
;EE366_Project.c,194 :: 		if(year >= 30)
	MOVLW       128
	XORWF       _year+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main106
	MOVLW       30
	SUBWF       _year+0, 0 
L__main106:
	BTFSS       STATUS+0, 0 
	GOTO        L_main48
;EE366_Project.c,195 :: 		year = 15;
	MOVLW       15
	MOVWF       _year+0 
	MOVLW       0
	MOVWF       _year+1 
L_main48:
;EE366_Project.c,196 :: 		year = Dec2Bcd(year);			//Convert back to BCD
	MOVF        _year+0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _year+0 
	MOVLW       0
	MOVWF       _year+1 
;EE366_Project.c,197 :: 		writeOnRTC(6, year);			//Write hour on DS1307
	MOVLW       6
	MOVWF       FARG_writeOnRTC_address+0 
	MOVF        _year+0, 0 
	MOVWF       FARG_writeOnRTC_writeValues+0 
	CALL        _writeOnRTC+0, 0
;EE366_Project.c,198 :: 		break;
	GOTO        L_main29
;EE366_Project.c,199 :: 		} /* end switch */
L_main28:
	MOVF        _setCounter+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_main30
	MOVF        _setCounter+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_main34
	MOVF        _setCounter+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_main37
	MOVF        _setCounter+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_main40
	MOVF        _setCounter+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_main43
	MOVF        _setCounter+0, 0 
	XORLW       6
	BTFSC       STATUS+0, 2 
	GOTO        L_main46
L_main29:
;EE366_Project.c,200 :: 		} /* end if(setCounter && set) */
L_main27:
;EE366_Project.c,201 :: 		} /* end if(setCounter) */
L_main18:
;EE366_Project.c,204 :: 		setAlarm = 0;
	CLRF        _setAlarm+0 
;EE366_Project.c,205 :: 		if(PORTA.B2 == 0) {	//ALARM btn
	BTFSC       PORTA+0, 2 
	GOTO        L_main49
;EE366_Project.c,206 :: 		display = 1;
	MOVLW       1
	MOVWF       _display+0 
	MOVLW       0
	MOVWF       _display+1 
;EE366_Project.c,207 :: 		clearOneTime = 0;
	CLRF        _clearOneTime+0 
	CLRF        _clearOneTime+1 
;EE366_Project.c,208 :: 		if(PORTA.B2 == 0) {
	BTFSC       PORTA+0, 2 
	GOTO        L_main50
;EE366_Project.c,209 :: 		alarmCounter++;
	INCF        _alarmCounter+0, 1 
;EE366_Project.c,210 :: 		if(alarmCounter > 4)
	MOVF        _alarmCounter+0, 0 
	SUBLW       4
	BTFSC       STATUS+0, 0 
	GOTO        L_main51
;EE366_Project.c,211 :: 		alarmCounter = 0;
	CLRF        _alarmCounter+0 
L_main51:
;EE366_Project.c,212 :: 		}
L_main50:
;EE366_Project.c,213 :: 		}
L_main49:
;EE366_Project.c,215 :: 		if(alarmCounter) { //Any value but zero
	MOVF        _alarmCounter+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main52
;EE366_Project.c,216 :: 		if(PORTA.B3 == 0) { //UP btn
	BTFSC       PORTA+0, 3 
	GOTO        L_main53
;EE366_Project.c,217 :: 		Delay_ms(30);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_main54:
	DECFSZ      R13, 1, 1
	BRA         L_main54
	DECFSZ      R12, 1, 1
	BRA         L_main54
;EE366_Project.c,218 :: 		if(PORTA.B3 == 0) {
	BTFSC       PORTA+0, 3 
	GOTO        L_main55
;EE366_Project.c,219 :: 		setAlarm = 1;
	MOVLW       1
	MOVWF       _setAlarm+0 
;EE366_Project.c,220 :: 		}
L_main55:
;EE366_Project.c,221 :: 		}
L_main53:
;EE366_Project.c,222 :: 		if(PORTA.B4 == 0) {
	BTFSC       PORTA+0, 4 
	GOTO        L_main56
;EE366_Project.c,223 :: 		Delay_ms(30);
	MOVLW       78
	MOVWF       R12, 0
	MOVLW       235
	MOVWF       R13, 0
L_main57:
	DECFSZ      R13, 1, 1
	BRA         L_main57
	DECFSZ      R12, 1, 1
	BRA         L_main57
;EE366_Project.c,224 :: 		if(PORTA.B4 == 0) { //DOWN btn
	BTFSC       PORTA+0, 4 
	GOTO        L_main58
;EE366_Project.c,225 :: 		setAlarm = -1;
	MOVLW       255
	MOVWF       _setAlarm+0 
;EE366_Project.c,226 :: 		}
L_main58:
;EE366_Project.c,227 :: 		}
L_main56:
;EE366_Project.c,228 :: 		}
L_main52:
;EE366_Project.c,230 :: 		if(alarmCounter) { //Any value but zero
	MOVF        _alarmCounter+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main59
;EE366_Project.c,231 :: 		switch(alarmCounter) {
	GOTO        L_main60
;EE366_Project.c,232 :: 		case 1: //Hours
L_main62:
;EE366_Project.c,233 :: 		hr_alarm = Bcd2Dec(hr_alarm);
	MOVF        _hr_alarm+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	MOVWF       _hr_alarm+0 
	MOVLW       0
	MOVWF       _hr_alarm+1 
;EE366_Project.c,234 :: 		hr_alarm = hr_alarm + setAlarm;
	MOVF        _setAlarm+0, 0 
	ADDWF       _hr_alarm+0, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       _setAlarm+0, 7 
	MOVLW       255
	ADDWFC      _hr_alarm+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _hr_alarm+0 
	MOVF        R2, 0 
	MOVWF       _hr_alarm+1 
;EE366_Project.c,235 :: 		if(hr_alarm >= 24)
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main107
	MOVLW       24
	SUBWF       R1, 0 
L__main107:
	BTFSS       STATUS+0, 0 
	GOTO        L_main63
;EE366_Project.c,236 :: 		hr_alarm = 0;
	CLRF        _hr_alarm+0 
	CLRF        _hr_alarm+1 
	GOTO        L_main64
L_main63:
;EE366_Project.c,237 :: 		else if(hr_alarm < 0)
	MOVLW       128
	XORWF       _hr_alarm+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main108
	MOVLW       0
	SUBWF       _hr_alarm+0, 0 
L__main108:
	BTFSC       STATUS+0, 0 
	GOTO        L_main65
;EE366_Project.c,238 :: 		hr_alarm = 23;
	MOVLW       23
	MOVWF       _hr_alarm+0 
	MOVLW       0
	MOVWF       _hr_alarm+1 
L_main65:
L_main64:
;EE366_Project.c,239 :: 		hr_alarm = Dec2Bcd(hr_alarm);
	MOVF        _hr_alarm+0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _hr_alarm+0 
	MOVLW       0
	MOVWF       _hr_alarm+1 
;EE366_Project.c,240 :: 		break;
	GOTO        L_main61
;EE366_Project.c,242 :: 		case 2:	//Minutes
L_main66:
;EE366_Project.c,243 :: 		min_alarm = Bcd2Dec(min_alarm);
	MOVF        _min_alarm+0, 0 
	MOVWF       FARG_Bcd2Dec_bcdnum+0 
	CALL        _Bcd2Dec+0, 0
	MOVF        R0, 0 
	MOVWF       _min_alarm+0 
	MOVLW       0
	MOVWF       _min_alarm+1 
;EE366_Project.c,244 :: 		min_alarm = min_alarm + setAlarm;
	MOVF        _setAlarm+0, 0 
	ADDWF       _min_alarm+0, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       _setAlarm+0, 7 
	MOVLW       255
	ADDWFC      _min_alarm+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _min_alarm+0 
	MOVF        R2, 0 
	MOVWF       _min_alarm+1 
;EE366_Project.c,245 :: 		if(min_alarm >= 60)
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main109
	MOVLW       60
	SUBWF       R1, 0 
L__main109:
	BTFSS       STATUS+0, 0 
	GOTO        L_main67
;EE366_Project.c,246 :: 		min_alarm = 0;
	CLRF        _min_alarm+0 
	CLRF        _min_alarm+1 
L_main67:
;EE366_Project.c,247 :: 		if(min_alarm < 0)
	MOVLW       128
	XORWF       _min_alarm+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main110
	MOVLW       0
	SUBWF       _min_alarm+0, 0 
L__main110:
	BTFSC       STATUS+0, 0 
	GOTO        L_main68
;EE366_Project.c,248 :: 		min_alarm = 59;
	MOVLW       59
	MOVWF       _min_alarm+0 
	MOVLW       0
	MOVWF       _min_alarm+1 
L_main68:
;EE366_Project.c,249 :: 		min_alarm = Dec2Bcd(min_alarm);
	MOVF        _min_alarm+0, 0 
	MOVWF       FARG_Dec2Bcd_decnum+0 
	CALL        _Dec2Bcd+0, 0
	MOVF        R0, 0 
	MOVWF       _min_alarm+0 
	MOVLW       0
	MOVWF       _min_alarm+1 
;EE366_Project.c,250 :: 		break;
	GOTO        L_main61
;EE366_Project.c,252 :: 		case 3:	//LED pattern
L_main69:
;EE366_Project.c,253 :: 		patternOfLed = patternOfLed + setAlarm;
	MOVF        _setAlarm+0, 0 
	ADDWF       _patternOfLed+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       _patternOfLed+0 
;EE366_Project.c,254 :: 		if (patternOfLed > 3)
	MOVLW       128
	XORLW       3
	MOVWF       R0 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main70
;EE366_Project.c,255 :: 		patternOfLed = 1;
	MOVLW       1
	MOVWF       _patternOfLed+0 
L_main70:
;EE366_Project.c,256 :: 		if (patternOfLed < 1)
	MOVLW       128
	XORWF       _patternOfLed+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       1
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main71
;EE366_Project.c,257 :: 		patternOfLed = 3;
	MOVLW       3
	MOVWF       _patternOfLed+0 
L_main71:
;EE366_Project.c,258 :: 		AlarmPattern(patternOfLed);
	MOVF        _patternOfLed+0, 0 
	MOVWF       FARG_alarmPattern_choice+0 
	MOVLW       0
	BTFSC       _patternOfLed+0, 7 
	MOVLW       255
	MOVWF       FARG_alarmPattern_choice+1 
	CALL        _alarmPattern+0, 0
;EE366_Project.c,259 :: 		patt_alarm = patternOfLed;
	MOVF        _patternOfLed+0, 0 
	MOVWF       _patt_alarm+0 
	MOVLW       0
	BTFSC       _patternOfLed+0, 7 
	MOVLW       255
	MOVWF       _patt_alarm+1 
;EE366_Project.c,260 :: 		break;
	GOTO        L_main61
;EE366_Project.c,262 :: 		case 4:	//LED & LCD Display
L_main72:
;EE366_Project.c,263 :: 		display = 0;
	CLRF        _display+0 
	CLRF        _display+1 
;EE366_Project.c,264 :: 		PORTD.B0=0; PORTD.B1=0; PORTD.B2=0; PORTD.B3=0;
	BCF         PORTD+0, 0 
	BCF         PORTD+0, 1 
	BCF         PORTD+0, 2 
	BCF         PORTD+0, 3 
;EE366_Project.c,265 :: 		break;
	GOTO        L_main61
;EE366_Project.c,266 :: 		} /* end alarm switch */
L_main60:
	MOVF        _alarmCounter+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_main62
	MOVF        _alarmCounter+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_main66
	MOVF        _alarmCounter+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_main69
	MOVF        _alarmCounter+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_main72
L_main61:
;EE366_Project.c,267 :: 		} /* end if(alarmCounter) */
L_main59:
;EE366_Project.c,270 :: 		switch (display) {
	GOTO        L_main73
;EE366_Project.c,271 :: 		case 0: //Real-time
L_main75:
;EE366_Project.c,272 :: 		time[0] = MSBofBCD(hour);	//Arrange values to print
	MOVF        _hour+0, 0 
	MOVWF       FARG_MSBofBCD_x+0 
	CALL        _MSBofBCD+0, 0
	MOVF        R0, 0 
	MOVWF       _time+0 
;EE366_Project.c,273 :: 		time[1] = LSBofBCD(hour);	//them on the LCD
	MOVF        _hour+0, 0 
	MOVWF       FARG_LSBofBCD_x+0 
	CALL        _LSBofBCD+0, 0
	MOVF        R0, 0 
	MOVWF       _time+1 
;EE366_Project.c,274 :: 		time[3] = MSBofBCD(minute);
	MOVF        _minute+0, 0 
	MOVWF       FARG_MSBofBCD_x+0 
	CALL        _MSBofBCD+0, 0
	MOVF        R0, 0 
	MOVWF       _time+3 
;EE366_Project.c,275 :: 		time[4] = LSBofBCD(minute);
	MOVF        _minute+0, 0 
	MOVWF       FARG_LSBofBCD_x+0 
	CALL        _LSBofBCD+0, 0
	MOVF        R0, 0 
	MOVWF       _time+4 
;EE366_Project.c,276 :: 		time[6] = MSBofBCD(second);
	MOVF        _second+0, 0 
	MOVWF       FARG_MSBofBCD_x+0 
	CALL        _MSBofBCD+0, 0
	MOVF        R0, 0 
	MOVWF       _time+6 
;EE366_Project.c,277 :: 		time[7] = LSBofBCD(second);
	MOVF        _second+0, 0 
	MOVWF       FARG_LSBofBCD_x+0 
	CALL        _LSBofBCD+0, 0
	MOVF        R0, 0 
	MOVWF       _time+7 
;EE366_Project.c,278 :: 		date[0] = MSBofBCD(day);
	MOVF        _day+0, 0 
	MOVWF       FARG_MSBofBCD_x+0 
	CALL        _MSBofBCD+0, 0
	MOVF        R0, 0 
	MOVWF       _date+0 
;EE366_Project.c,279 :: 		date[1] = LSBofBCD(day);
	MOVF        _day+0, 0 
	MOVWF       FARG_LSBofBCD_x+0 
	CALL        _LSBofBCD+0, 0
	MOVF        R0, 0 
	MOVWF       _date+1 
;EE366_Project.c,280 :: 		date[3] = MSBofBCD(month);
	MOVF        _month+0, 0 
	MOVWF       FARG_MSBofBCD_x+0 
	CALL        _MSBofBCD+0, 0
	MOVF        R0, 0 
	MOVWF       _date+3 
;EE366_Project.c,281 :: 		date[4] = LSBofBCD(month);
	MOVF        _month+0, 0 
	MOVWF       FARG_LSBofBCD_x+0 
	CALL        _LSBofBCD+0, 0
	MOVF        R0, 0 
	MOVWF       _date+4 
;EE366_Project.c,282 :: 		date[6] = MSBofBCD(year);
	MOVF        _year+0, 0 
	MOVWF       FARG_MSBofBCD_x+0 
	CALL        _MSBofBCD+0, 0
	MOVF        R0, 0 
	MOVWF       _date+6 
;EE366_Project.c,283 :: 		date[7] = LSBofBCD(year);
	MOVF        _year+0, 0 
	MOVWF       FARG_LSBofBCD_x+0 
	CALL        _LSBofBCD+0, 0
	MOVF        R0, 0 
	MOVWF       _date+7 
;EE366_Project.c,286 :: 		if((hour == hr_alarm) && (minute == min_alarm)) {
	MOVF        _hour+1, 0 
	XORWF       _hr_alarm+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main111
	MOVF        _hr_alarm+0, 0 
	XORWF       _hour+0, 0 
L__main111:
	BTFSS       STATUS+0, 2 
	GOTO        L_main78
	MOVF        _minute+1, 0 
	XORWF       _min_alarm+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main112
	MOVF        _min_alarm+0, 0 
	XORWF       _minute+0, 0 
L__main112:
	BTFSS       STATUS+0, 2 
	GOTO        L_main78
L__main84:
;EE366_Project.c,287 :: 		alarmPattern(patt_alarm);
	MOVF        _patt_alarm+0, 0 
	MOVWF       FARG_alarmPattern_choice+0 
	MOVF        _patt_alarm+1, 0 
	MOVWF       FARG_alarmPattern_choice+1 
	CALL        _alarmPattern+0, 0
;EE366_Project.c,288 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;EE366_Project.c,289 :: 		Lcd_out(1,1,"     ALARM!     ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_EE366_Project+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_EE366_Project+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;EE366_Project.c,290 :: 		}
	GOTO        L_main79
L_main78:
;EE366_Project.c,292 :: 		Lcd_out(1, 1, "Time:");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_EE366_Project+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_EE366_Project+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;EE366_Project.c,293 :: 		Lcd_out(2, 1, "Date:");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_EE366_Project+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_EE366_Project+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;EE366_Project.c,294 :: 		Lcd_out(1, 6, time);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _time+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_time+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;EE366_Project.c,295 :: 		Lcd_out(2, 6, date);
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _date+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_date+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;EE366_Project.c,296 :: 		Delay_ms(100);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main80:
	DECFSZ      R13, 1, 1
	BRA         L_main80
	DECFSZ      R12, 1, 1
	BRA         L_main80
	DECFSZ      R11, 1, 1
	BRA         L_main80
	NOP
;EE366_Project.c,297 :: 		}
L_main79:
;EE366_Project.c,298 :: 		break;
	GOTO        L_main74
;EE366_Project.c,300 :: 		case 1: //Alarm
L_main81:
;EE366_Project.c,301 :: 		if(clearOneTime == 0) {
	MOVLW       0
	XORWF       _clearOneTime+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main113
	MOVLW       0
	XORWF       _clearOneTime+0, 0 
L__main113:
	BTFSS       STATUS+0, 2 
	GOTO        L_main82
;EE366_Project.c,302 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;EE366_Project.c,303 :: 		clearOneTime = 1;
	MOVLW       1
	MOVWF       _clearOneTime+0 
	MOVLW       0
	MOVWF       _clearOneTime+1 
;EE366_Project.c,304 :: 		}
L_main82:
;EE366_Project.c,305 :: 		Lcd_out(1,1,"Alarm: ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_EE366_Project+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_EE366_Project+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;EE366_Project.c,306 :: 		alarm[0] = MSBofBCD(hr_alarm);	//Arrange values to print
	MOVF        _hr_alarm+0, 0 
	MOVWF       FARG_MSBofBCD_x+0 
	CALL        _MSBofBCD+0, 0
	MOVF        R0, 0 
	MOVWF       _alarm+0 
;EE366_Project.c,307 :: 		alarm[1] = LSBofBCD(hr_alarm);	//them on the LCD
	MOVF        _hr_alarm+0, 0 
	MOVWF       FARG_LSBofBCD_x+0 
	CALL        _LSBofBCD+0, 0
	MOVF        R0, 0 
	MOVWF       _alarm+1 
;EE366_Project.c,308 :: 		alarm[3] = MSBofBCD(min_alarm);
	MOVF        _min_alarm+0, 0 
	MOVWF       FARG_MSBofBCD_x+0 
	CALL        _MSBofBCD+0, 0
	MOVF        R0, 0 
	MOVWF       _alarm+3 
;EE366_Project.c,309 :: 		alarm[4] = LSBofBCD(min_alarm);
	MOVF        _min_alarm+0, 0 
	MOVWF       FARG_LSBofBCD_x+0 
	CALL        _LSBofBCD+0, 0
	MOVF        R0, 0 
	MOVWF       _alarm+4 
;EE366_Project.c,310 :: 		Lcd_out(1, 8, alarm);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       8
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _alarm+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_alarm+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;EE366_Project.c,311 :: 		Delay_ms(200);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main83:
	DECFSZ      R13, 1, 1
	BRA         L_main83
	DECFSZ      R12, 1, 1
	BRA         L_main83
	DECFSZ      R11, 1, 1
	BRA         L_main83
;EE366_Project.c,312 :: 		break;
	GOTO        L_main74
;EE366_Project.c,313 :: 		} /* end display switch */
L_main73:
	MOVLW       0
	XORWF       _display+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main114
	MOVLW       0
	XORWF       _display+0, 0 
L__main114:
	BTFSC       STATUS+0, 2 
	GOTO        L_main75
	MOVLW       0
	XORWF       _display+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main115
	MOVLW       1
	XORWF       _display+0, 0 
L__main115:
	BTFSC       STATUS+0, 2 
	GOTO        L_main81
L_main74:
;EE366_Project.c,316 :: 		second = readFromRTC(0);
	CLRF        FARG_readFromRTC_address+0 
	CALL        _readFromRTC+0, 0
	MOVF        R0, 0 
	MOVWF       _second+0 
	MOVLW       0
	MOVWF       _second+1 
;EE366_Project.c,317 :: 		minute = readFromRTC(1);
	MOVLW       1
	MOVWF       FARG_readFromRTC_address+0 
	CALL        _readFromRTC+0, 0
	MOVF        R0, 0 
	MOVWF       _minute+0 
	MOVLW       0
	MOVWF       _minute+1 
;EE366_Project.c,318 :: 		hour = readFromRTC(2);
	MOVLW       2
	MOVWF       FARG_readFromRTC_address+0 
	CALL        _readFromRTC+0, 0
	MOVF        R0, 0 
	MOVWF       _hour+0 
	MOVLW       0
	MOVWF       _hour+1 
;EE366_Project.c,319 :: 		day = readFromRTC(4);
	MOVLW       4
	MOVWF       FARG_readFromRTC_address+0 
	CALL        _readFromRTC+0, 0
	MOVF        R0, 0 
	MOVWF       _day+0 
	MOVLW       0
	MOVWF       _day+1 
;EE366_Project.c,320 :: 		month = readFromRTC(5);
	MOVLW       5
	MOVWF       FARG_readFromRTC_address+0 
	CALL        _readFromRTC+0, 0
	MOVF        R0, 0 
	MOVWF       _month+0 
	MOVLW       0
	MOVWF       _month+1 
;EE366_Project.c,321 :: 		year = readFromRTC(6);
	MOVLW       6
	MOVWF       FARG_readFromRTC_address+0 
	CALL        _readFromRTC+0, 0
	MOVF        R0, 0 
	MOVWF       _year+0 
	MOVLW       0
	MOVWF       _year+1 
;EE366_Project.c,323 :: 		} /* end while */
	GOTO        L_main12
;EE366_Project.c,324 :: 		} /* end main */
L_end_main:
	GOTO        $+0
; end of _main
