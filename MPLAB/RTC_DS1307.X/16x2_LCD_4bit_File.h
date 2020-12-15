/*
 * PIC18F4550 LCD16x2 Header File
 * http://www.electronicwings.com
 */ 


// This is a guard condition so that contents of this file are not included
// more than once.  
#ifndef XC_HEADER_TEMPLATE_H
#define	XC_HEADER_TEMPLATE_H

#include <xc.h> // include processor files - each processor file is guarded.  

#include <pic18f4550.h>
#include "Configuration_Header_File.h"

#define _XTAL_FREQ 8000000
/*********************Definition of Ports********************************/

#define RS LATD2            
#define EN LATD3           
#define ldata LATD
#define LCD_Port TRISD
#define LED1_CONF TRISDbits.TRISD0
#define LED2_CONF TRISDbits.TRISD1
#define PAUSE_CONF TRISBbits.TRISB7
#define INPUNT 1
#define OUTPUT 0
#define PAUSE PORTBbits.RB7
#define LED1 LATDbits.LATD0
#define LED2 LATDbits.LATD1
#define ON 1
#define OFF 0

/*********************Proto-Type Declaration*****************************/
/**
 * Genera un retraso en milisegundos
 * @param milisegundos de retraso
 */
void MSdelay(unsigned int );
/**
 * Inicializa el LCD
 */
void LCD_Init();
/**
 * Envia un comando al LCD
 * @param Comando a enviar
 */
void LCD_Command(unsigned char );
/**
 * Envia un caracter al LCD
 * @param x Caracter a enviar
 */
void LCD_Char(unsigned char x);
/**
 * Desplega un String en el LCD
 * @param String a mostrar en el LCD
 */
void LCD_String(const char *);
/**
 * Muestra un String en el LCD en las coordenadas indicadas
 * @param Coordenada para la fila
 * @param Coordendad para la columna
 * @param String a mostrar
 */
void LCD_String_xy(char, char , const char *);
void LCD_Clear();                   /*Clear LCD Screen*/

#endif	/* XC_HEADER_TEMPLATE_H */

