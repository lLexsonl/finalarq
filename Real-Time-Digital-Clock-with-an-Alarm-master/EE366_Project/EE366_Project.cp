#line 1 "C:/Users/rubab/OneDrive/Desktop/Second Semester/Microcontroller/Projrct/EE366_Project/EE366_Project.c"

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



unsigned short readFromRTC(unsigned short address) {
 unsigned short readValues;
 I2C1_Start();
 I2C1_Wr(0xD0);
 I2C1_Wr(address);
 I2C1_Repeated_Start();
 I2C1_Wr(0xD1);
 readValues=I2C1_Rd(0);
 I2C1_Stop();
 return(readValues);
}

void writeOnRTC(unsigned short address, unsigned short writeValues) {
 I2C1_Start();
 I2C1_Wr(0xD0);
 I2C1_Wr(address);
 I2C1_Wr(writeValues);
 I2C1_Stop();
}


unsigned char MSBofBCD(unsigned char x) {
 return ((x >> 4) + '0');
}

unsigned char LSBofBCD(unsigned char x) {
 return ((x & 0x0F) + '0');
}


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



int second; int minute; int hour;
int day; int month; int year;
short set; unsigned short setCounter = 0;


int hr_alarm; int min_alarm; int patt_alarm;
short setAlarm; unsigned short alarmCounter = 0;
short patternOfLed = 0; int display = 0;
int clearOneTime = 0;


char time[] = "00:00:00";
char date[] = "00-00-00";
char alarm[] = "00:00";

void main() {

 ADCON1 = 0x0F;
 TRISD.B0 = 0;
 TRISD.B1 = 0;
 TRISD.B2 = 0;
 TRISD.B3 = 0;
 TRISA = 0xFF;
 OSCCON = 0x73;
 I2C1_Init(100000);
 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);

 Lcd_out(1,1,"  Digital  Clock  ");
 Lcd_out(2,1," by:  Ruba & Nada ");
 Delay_ms(500);
 Lcd_Cmd(_LCD_CLEAR);

 while(1) {

 set = 0;
 if(PORTA.B1 == 0) {
 Delay_ms(30);
 if(PORTA.B1 == 0) {
 setCounter++;
 if(setCounter >= 7)
 setCounter = 0;
 }
 }
 if(setCounter) {
 if(PORTA.B3 == 0) {
 Delay_ms(30);
 if(PORTA.B3 == 0)
 set = 1;
 }
 if(PORTA.B4 == 0) {
 Delay_ms(30);
 if(PORTA.B4 == 0)
 set = -1;
 }

 if(setCounter && set) {
 switch(setCounter) {
 case 1:
 hour = readFromRTC(2);
 hour = Bcd2Dec(hour);
 hour = hour + set;
 if(hour >= 24)
 hour = 0;
 else if(hour < 0)
 hour = 23;
 hour = Dec2Bcd(hour);
 writeOnRTC(2, hour);
 break;

 case 2:
 minute = readFromRTC(1);
 minute = Bcd2Dec(minute);
 minute = minute + set;
 if(minute >= 60)
 minute = 0;
 if(minute < 0)
 minute = 59;
 minute = Dec2Bcd(minute);
 writeOnRTC(1, minute);
 break;

 case 3:
 second = readFromRTC(0);
 second = Bcd2Dec(second);
 second = second + set;
 if(second >= 60)
 second = 0;
 if(second < 0)
 second = 59;
 second = Dec2Bcd(second);
 writeOnRTC(0, second);
 break;

 case 4:
 day = readFromRTC(4);
 day = Bcd2Dec(day);
 day = day + set;
 if(day >= 32)
 day = 1;
 if(day <= 0)
 day = 31;
 day = Dec2Bcd(day);
 writeOnRTC(4, day);
 break;

 case 5:
 month = readFromRTC(5);
 month = Bcd2Dec(month);
 month = month + set;
 if(month > 12)
 month = 1;
 if(month <= 0)
 month = 12;
 month = Dec2Bcd(month);
 writeOnRTC(5,month);
 break;

 case 6:
 year = readFromRTC(6);
 year = Bcd2Dec(year);
 year = year + set;
 if(year < 15)
 year = 30;
 if(year >= 30)
 year = 15;
 year = Dec2Bcd(year);
 writeOnRTC(6, year);
 break;
 }
 }
 }


 setAlarm = 0;
 if(PORTA.B2 == 0) {
 display = 1;
 clearOneTime = 0;
 if(PORTA.B2 == 0) {
 alarmCounter++;
 if(alarmCounter > 4)
 alarmCounter = 0;
 }
 }

 if(alarmCounter) {
 if(PORTA.B3 == 0) {
 Delay_ms(30);
 if(PORTA.B3 == 0) {
 setAlarm = 1;
 }
 }
 if(PORTA.B4 == 0) {
 Delay_ms(30);
 if(PORTA.B4 == 0) {
 setAlarm = -1;
 }
 }
 }

 if(alarmCounter) {
 switch(alarmCounter) {
 case 1:
 hr_alarm = Bcd2Dec(hr_alarm);
 hr_alarm = hr_alarm + setAlarm;
 if(hr_alarm >= 24)
 hr_alarm = 0;
 else if(hr_alarm < 0)
 hr_alarm = 23;
 hr_alarm = Dec2Bcd(hr_alarm);
 break;

 case 2:
 min_alarm = Bcd2Dec(min_alarm);
 min_alarm = min_alarm + setAlarm;
 if(min_alarm >= 60)
 min_alarm = 0;
 if(min_alarm < 0)
 min_alarm = 59;
 min_alarm = Dec2Bcd(min_alarm);
 break;

 case 3:
 patternOfLed = patternOfLed + setAlarm;
 if (patternOfLed > 3)
 patternOfLed = 1;
 if (patternOfLed < 1)
 patternOfLed = 3;
 AlarmPattern(patternOfLed);
 patt_alarm = patternOfLed;
 break;

 case 4:
 display = 0;
 PORTD.B0=0; PORTD.B1=0; PORTD.B2=0; PORTD.B3=0;
 break;
 }
 }


 switch (display) {
 case 0:
 time[0] = MSBofBCD(hour);
 time[1] = LSBofBCD(hour);
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

 case 1:
 if(clearOneTime == 0) {
 Lcd_Cmd(_LCD_CLEAR);
 clearOneTime = 1;
 }
 Lcd_out(1,1,"Alarm: ");
 alarm[0] = MSBofBCD(hr_alarm);
 alarm[1] = LSBofBCD(hr_alarm);
 alarm[3] = MSBofBCD(min_alarm);
 alarm[4] = LSBofBCD(min_alarm);
 Lcd_out(1, 8, alarm);
 Delay_ms(200);
 break;
 }


 second = readFromRTC(0);
 minute = readFromRTC(1);
 hour = readFromRTC(2);
 day = readFromRTC(4);
 month = readFromRTC(5);
 year = readFromRTC(6);

 }
}
