/*
 * PIC18F4550 interfacing with RTC DS1307
 * http://www.electronicwings.com
 */ 


#include <stdio.h>
#include "Configuration_Header_File.h"
#include "16x2_LCD_4bit_File.h"
#include <pic18f4550.h>
#include "I2C_Master_File.h"

#define device_id_write 0xD0
#define device_id_read 0xD1
#define hour_12_PM 0x60
#define hour_12_AM 0x40

int sec,min,hour;
int Day,Date,Month,Year;
int alarma, counter_sec, counter_min;
int run, count_pomo, count_pomo_fail;

void RTC_Read_Clock(char read_clock_address)
{
    I2C_Start(device_id_write);
    I2C_Write(read_clock_address);     /* address from where time needs to be read*/
    I2C_Repeated_Start(device_id_read);
    sec = I2C_Read(0);                 /*read data and send ack for continuous reading*/
    min = I2C_Read(0);                 /*read data and send ack for continuous reading*/
    hour= I2C_Read(1);                 /*read data and send nack for indicating stop reading*/
    
}

void RTC_Clock_Write(char sec, char min, char hour, char AM_PM)					/* function for clock */
{
    hour = (hour | AM_PM);        /* whether it is AM or PM */
	I2C_Start(device_id_write);	  /* start I2C communication with device slave address */	
	I2C_Write(0);			      /* write on 0 location for second value */
	I2C_Write(sec);			      /* write second value on 00 location */
	I2C_Write(min);			      /* write min value on 01 location */
	I2C_Write(hour);		      /* write hour value on 02 location */
	I2C_Stop();				      /* stop I2C communication */
}

void MSdelay1(unsigned int val)
{
 unsigned int i,j;
 for(i=0;i<val;i++)
     for(j=0;j<165;j++);             /*This count Provide delay of 1 ms for 8MHz Frequency */
}

int Dec2Bcd(int dec) {
    int bdc;
    bdc = ((dec/10) << 4) + (dec % 10);
    return bdc;
}

int Bcd2Dec(int bcd) {
    int dec;
    dec = bcd + ((bcd & 0x70) >> 4) * 10;
    return dec;
}

void main()
{
    TRISDbits.TRISD0 = 0;
    TRISDbits.TRISD1 = 0;
    
    TRISBbits.TRISB7 = 1;
    
    char secs[10],mins[10],hours[10];
    char counters_sec[10], counters_min[10], counters_pomos[10];
    char Clock_type = 0x06;
    char AM_PM = 0x05;
    OSCCON=0x72;                    /*Use internal oscillator and 
                                     *set frequency to 8 MHz*/ 
    I2C_Init();                     /*initialize I2C protocol*/
    LCD_Init();                     /*initialize LCD16x2*/    
    LCD_Clear();
    MSdelay(10);
    alarma=1 , counter_sec=0, counter_min=0, run = 1;
    count_pomo=0, count_pomo_fail=0;
    while(1)
    {
        if(alarma) {
        //MSdelay1(2000);
        RTC_Read_Clock(0);              /*gives second,minute and hour*/
        I2C_Stop();
        if(hour & (1<<Clock_type)){     /* check clock is 12hr or 24hr */
            
            if(hour & (1<<AM_PM)){      /* check AM or PM */
                LCD_String_xy(1,14,"PM");
            }
            else{
                LCD_String_xy(1,14,"AM");
            }
            
            hour = hour & (0x1f);
            sprintf(secs,"%x ",sec);   /*%x for reading BCD format from RTC DS1307*/
            sprintf(mins,"%x:",min);    
            sprintf(hours,"Tim:%x:",hour);  
            LCD_String_xy(0,0,hours);            
            LCD_String(mins);
            LCD_String(secs);
        }
        else{
            
            hour = hour & (0x3f);
            sprintf(secs,"%x ",sec);   /*%x for reading BCD format from RTC DS1307*/
            sprintf(mins,"%x:",min);    
            sprintf(hours,"Tim:%x:",hour);  
            LCD_String_xy(0,0,hours);            
            LCD_String(mins);
            LCD_String(secs); 
        }
        alarma=0;
        }
        
        MSdelay(1000);
        
        if (!alarma) {
            
            if (!PORTBbits.RB7) {
                MSdelay(50);
                counter_min = 0;
                counter_sec = 0;
                count_pomo_fail++;
            }
            
            if (run) {
                LATDbits.LATD0 = 1;
            } else {
                LATDbits.LATD1 = 1;
            }
            
            int aux = Bcd2Dec(sec);
            RTC_Read_Clock(0);              /*gives second,minute and hour*/
            I2C_Stop();
            if (aux < Bcd2Dec(sec)) {
                if(counter_sec >= 59) {
                    counter_sec = (counter_sec % 59) - 1;
                    counter_min++;
                    LCD_Clear();
                }
                if(run) {
                    if (counter_sec == 5) {
                        counter_sec = 0;
                        run = 0;
                        LATDbits.LATD0 = 0;
                    }
                } else {
                    if (counter_sec == 3) {
                        counter_sec = 0;
                        run = 1;
                        LATDbits.LATD1 = 0;
                        count_pomo++;
                    }
                }
                
                int print_sec = Dec2Bcd(++counter_sec);
                int print_min = Dec2Bcd(counter_min);
                int print_pomo = Dec2Bcd(count_pomo);
                int print_fail = Dec2Bcd(count_pomo_fail);
                
                sprintf(counters_min,"Tempom:%x",print_min);
                sprintf(counters_sec,"-%x",print_sec);
                sprintf(counters_pomos," E%x F%x", print_pomo, print_fail);
                LCD_String_xy(2,0,counters_min);
                LCD_String(counters_sec);
                LCD_String(counters_pomos);
            }
            alarma=1;
        }
    }    
}
