/* LCD module connections */
sbit LCD_RS at RE0_bit;
sbit LCD_EN at RE2_bit;
sbit LCD_D4 at RD4_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_RS_Direction at TRISE0_bit;
sbit LCD_EN_Direction at TRISE2_bit;
sbit LCD_D4_Direction at TRISD4_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D7_Direction at TRISD7_bit;
/* End LCD module connections */

/* Communicating with DS1307 */
unsigned short readFromRTC(unsigned short address) {
        unsigned short readValues;
        I2C1_Start();                          //Issue I2C start signal
        I2C1_Wr(0xD0);                         //DS1307 address (0x68) + Write (zero) = 0xD0
        I2C1_Wr(address);                //Adress of DS1307 location
        I2C1_Repeated_Start();        //Issue repeated start signal
        I2C1_Wr(0xD1);                         //Address 0x68 + Read (one) = 0xD1
        readValues=I2C1_Rd(0);         //Read 1 byte from DS1307, send not acknowledge
        I2C1_Stop();                         //Issue stop signal
        return(readValues);
}

void writeOnRTC(unsigned short address, unsigned short writeValues) {
        I2C1_Start();                         //Issue I2C start signal
        I2C1_Wr(0xD0);                         //DS1307 address (0x68) + Write (zero) = 0xD0
        I2C1_Wr(address);                 //Address of DS1307 location
        I2C1_Wr(writeValues);        //Send the data we want to write
        I2C1_Stop();                         //Issue stop signal
}

/* To display MSB and LSB of BCD number */
unsigned char MSBofBCD(unsigned char x) {
        return ((x >> 4) + '0');
}

unsigned char LSBofBCD(unsigned char x) {
        return ((x & 0x0F) + '0');
}

/* Changing the LED pattern for the alarm */
void alarmPattern(int choice){
        if (choice == 1) {
                PORTD.B0=1; PORTD.B1=0; PORTD.B2=1; PORTD.B3=0;
                Delay_ms(70);
                PORTD.B0=0; PORTD.B1=1; PORTD.B2=0; PORTD.B3=1;
                Delay_ms(70);
        }
        else if (choice == 2) {
                PORTD.B0=0; PORTD.B1=1; PORTD.B2=1; PORTD.B3=0;
                Delay_ms(70);
                PORTD.B0=1; PORTD.B1=0; PORTD.B2=0; PORTD.B3=1;
                Delay_ms(70);
        }
        else if (choice == 3) {
                PORTD.B0=1; PORTD.B1=1; PORTD.B2=1; PORTD.B3=1;
                Delay_ms(70);
                PORTD.B0=0; PORTD.B1=0; PORTD.B2=0; PORTD.B3=0;
                Delay_ms(70);
        }
}

/* Variables */
//For the real-time clock
int second; int minute; int hour;
int day; int month; int year;
short set; unsigned short setCounter = 0;

//For the alarm
int hr_alarm; int min_alarm;  int patt_alarm;
short setAlarm; unsigned short alarmCounter = 0;
short patternOfLed = 0; int display = 0;
int clearOneTime = 0;

//For printing on LCD
char time[] = "00:00:00";
char date[] = "00-00-00";
char alarm[] = "00:00";

void main() {
        /* Settings */
        ADCON1 = 0x0F;                                 //IO -> digital
        TRISD.B0 = 0;                                //PORTD (LED) -> output
        TRISD.B1 = 0;
        TRISD.B2 = 0;
        TRISD.B3 = 0;
        TRISA = 0xFF;                                 //PORTA (buttons) -> input
        OSCCON = 0x73;                                 //8MHz internal oscillator
        I2C1_Init(100000);                        //DS1307 I2C running at 100KHz
        Lcd_Init();                                        //Initialize LCD
        Lcd_Cmd(_LCD_CURSOR_OFF);   //LCD cursor off

        Lcd_out(1,1,"  Digital  Clock  ");
        Lcd_out(2,1," by:  Ruba & Nada ");
        Delay_ms(500);
        Lcd_Cmd(_LCD_CLEAR);

        while(1) {
                /* Setting the time */
                set = 0;
                if(PORTA.B1 == 0) { //SET btn is pressed
                        Delay_ms(30);
                        if(PORTA.B1 == 0) {
                                setCounter++;
                                if(setCounter >= 7)
                                        setCounter = 0;
                        }
                }
                if(setCounter) { //Any value but zero
                        if(PORTA.B3 == 0) {
                                Delay_ms(30);
                                if(PORTA.B3 == 0) //UP btn
                                        set = 1;
                        }
                        if(PORTA.B4 == 0) {
                                Delay_ms(30);
                                if(PORTA.B4 == 0) //DOWN btn
                                        set = -1;
                        }

                        if(setCounter && set) { //Any value but zero
                                switch(setCounter) {
                                        case 1: //Hours
                                        hour = readFromRTC(2);                        //Read hour from DS1307
                                        hour = Bcd2Dec(hour);                        //Convert reading to decimal
                                        hour = hour + set;                                //Increment or decrement
                                        if(hour >= 24)                                        //If at 23 and user increments
                                                hour = 0;                                        //Reset to 0 (midnight)
                                        else if(hour < 0)                                //If at 0 and user decrements
                                                hour = 23;                                        //Go back to 23
                                        hour = Dec2Bcd(hour);                        //Convert back to BCD
                                        writeOnRTC(2, hour);                        //Write hour on DS1307
                                        break;

                                        case 2: //Minutes
                                        minute = readFromRTC(1);                //Read minute from DS1307
                                        minute = Bcd2Dec(minute);                //Convert reading to decimal
                                        minute = minute + set;                        //Increment or decrement
                                        if(minute >= 60)                                //If at 59 and user increments
                                                minute = 0;                                        //Reset to 0
                                        if(minute < 0)                                        //If at 0 and user decrements
                                                minute = 59;                                //Go back to 59
                                        minute = Dec2Bcd(minute);                //Convert back to BCD
                                        writeOnRTC(1, minute);                        //Write hour on DS1307
                                        break;

                                        case 3: //Seconds
                                        second = readFromRTC(0);                //Read second from DS1307
                                        second = Bcd2Dec(second);                //Convert reading to decimal
                                        second = second + set;                        //Increment or decrement
                                        if(second >= 60)                                //If at 59 and user increments
                                                second = 0;                                        //Reset to 0
                                        if(second < 0)                                        //If at 0 and user decrements
                                                second = 59;                                //Go back to 59
                                        second = Dec2Bcd(second);                //Convert back to BCD
                                        writeOnRTC(0, second);                        //Write second on DS1307
                                        break;

                                        case 4: //Days
                                        day = readFromRTC(4);                        //Read day from DS1307
                                        day = Bcd2Dec(day);                                //Convert reading to decimal
                                        day = day + set;                                //Increment or decrement
                                        if(day >= 32)                                        //If at 31 and user increments
                                                day = 1;                                        //Reset to 1
                                        if(day <= 0)                                        //If at 1 and user decrements
                                                day = 31;                                        //Go back to 31
                                        day = Dec2Bcd(day);                                //Convert back to BCD
                                        writeOnRTC(4, day);                                //Write day on DS1307
                                        break;

                                        case 5: //Months
                                        month = readFromRTC(5);                        //Read month from DS1307
                                        month = Bcd2Dec(month);                        //Convert reading to decimal
                                        month = month + set;                        //Increment or decrement
                                        if(month > 12)                                        //If at 12 and user increments
                                                month = 1;                                        //Reset to 1
                                        if(month <= 0)                                        //If at 1 and user decrements
                                                month = 12;                                        //Go back to 12
                                        month = Dec2Bcd(month);                        //Convert back to BCD
                                        writeOnRTC(5,month);                        //Write month on DS1307
                                        break;

                                        case 6: //Years
                                        year = readFromRTC(6);                        //Read hour from DS1307
                                        year = Bcd2Dec(year);                        //Convert reading to decimal
                                        year = year + set;                                //Increment or decrement
                                        if(year < 15)
                                                year = 30;
                                        if(year >= 30)
                                                year = 15;
                                        year = Dec2Bcd(year);                        //Convert back to BCD
                                        writeOnRTC(6, year);                        //Write hour on DS1307
                                        break;
                                } /* end switch */
                        } /* end if(setCounter && set) */
                } /* end if(setCounter) */

                /* Setting the Alarm */
                setAlarm = 0;
                if(PORTA.B2 == 0) {        //ALARM btn
                        display = 1;
                        clearOneTime = 0;
                        if(PORTA.B2 == 0) {
                                alarmCounter++;
                                if(alarmCounter > 4)
                                alarmCounter = 0;
                        }
                }

                if(alarmCounter) { //Any value but zero
                        if(PORTA.B3 == 0) { //UP btn
                                Delay_ms(30);
                                if(PORTA.B3 == 0) {
                                        setAlarm = 1;
                                }
                        }
                        if(PORTA.B4 == 0) {
                                Delay_ms(30);
                                if(PORTA.B4 == 0) { //DOWN btn
                                        setAlarm = -1;
                                }
                        }
                }

                if(alarmCounter && setAlarm) { //Any value but zero
                        switch(alarmCounter) {
                                case 1: //Hours
                                hr_alarm = Bcd2Dec(hr_alarm);
                                hr_alarm = hr_alarm + setAlarm;
                                if(hr_alarm >= 24)
                                        hr_alarm = 0;
                                else if(hr_alarm < 0)
                                        hr_alarm = 23;
                                hr_alarm = Dec2Bcd(hr_alarm);
                                break;

                                case 2:        //Minutes
                                min_alarm = Bcd2Dec(min_alarm);
                                min_alarm = min_alarm + setAlarm;
                                if(min_alarm >= 60)
                                        min_alarm = 0;                                if(min_alarm < 0)
                                        min_alarm = 59;
                                min_alarm = Dec2Bcd(min_alarm);
                                break;

                                case 3:        //LED pattern
                                patternOfLed = patternOfLed + setAlarm;
                                        if (patternOfLed > 3)
                                                patternOfLed = 1;
                                        if (patternOfLed < 1)
                                                patternOfLed = 3;
                                        AlarmPattern(patternOfLed);
                                patt_alarm = patternOfLed;
                                break;

                                case 4:        //LED & LCD Display
                                display = 0;
                                PORTD.B0=0; PORTD.B1=0; PORTD.B2=0; PORTD.B3=0;
                                break;
                        } /* end alarm switch */
                } /* end if(alarmCounter) */

                /* What to display on LCD */
                switch (display) {
                        case 0: //Real-time
                        time[0] = MSBofBCD(hour);        //Arrange values to print
                        time[1] = LSBofBCD(hour);        //them on the LCD
                        time[3] = MSBofBCD(minute);
                        time[4] = LSBofBCD(minute);
                        time[6] = MSBofBCD(second);
                        time[7] = LSBofBCD(second);
                        date[0] = MSBofBCD(day);
                        date[1] = LSBofBCD(day);
                        date[3] = MSBofBCD(month);
                        date[4] = LSBofBCD(month);
                        date[6] = MSBofBCD(year);
                        date[7] = LSBofBCD(year);

                        /* Condition to activate alarm */
                        if((hour == hr_alarm) && (minute == min_alarm)) {
                                alarmPattern(patt_alarm);
                                Lcd_Cmd(_LCD_CLEAR);
                                Lcd_out(1,1,"     ALARM!     ");
                        }
                        else {
                                Lcd_out(1, 1, "Time:");
                                Lcd_out(2, 1, "Date:");
                                Lcd_out(1, 6, time);
                                Lcd_out(2, 6, date);
                                Delay_ms(100);
                        }
                        break;

                        case 1: //Alarm
                        if(clearOneTime == 0) {
                                Lcd_Cmd(_LCD_CLEAR);
                                clearOneTime = 1;
                        }
                        Lcd_out(1,1,"Alarm: ");
                        alarm[0] = MSBofBCD(hr_alarm);        //Arrange values to print
                        alarm[1] = LSBofBCD(hr_alarm);        //them on the LCD
                        alarm[3] = MSBofBCD(min_alarm);
                        alarm[4] = LSBofBCD(min_alarm);
                        Lcd_out(1, 8, alarm);
                        Delay_ms(200);
                        break;
                } /* end display switch */

                /* Read time from DS1307 */
                second = readFromRTC(0);
                minute = readFromRTC(1);
                hour = readFromRTC(2);
                day = readFromRTC(4);
                month = readFromRTC(5);
                year = readFromRTC(6);

        } /* end while */
} /* end main */