/***********************************************************************
 * 
 * Analog-to-digital conversion with displaying result on LCD and 
 * transmitting via UART.
 * ATmega328P (Arduino Uno), 16 MHz, AVR 8-bit Toolchain 3.6.2
 *
 * Copyright (c) 2018-2020 Tomas Fryza
 * Dept. of Radio Electronics, Brno University of Technology, Czechia
 * This work is licensed under the terms of the MIT license.
 * 
 **********************************************************************/

/* Includes ----------------------------------------------------------*/
#include <avr/io.h>         // AVR device-specific IO definitions
#include <avr/interrupt.h>  // Interrupts standard C library for AVR-GCC
#include "timer.h"          // Timer library for AVR-GCC
#include "lcd.h"            // Peter Fleury's LCD library
#include <stdlib.h>         // C library. Needed for conversion function
#include "uart.h"           // Peter Fleury's UART library

#ifndef F_CPU
#define F_CPU 16000000      // CPU frequency in Hz required for delay func
#endif

/* Function definitions ----------------------------------------------*/
/**
 * Main function where the program execution begins. Use Timer/Counter1
 * and start ADC conversion four times per second. Send value to LCD
 * and UART.
 */
int main(void)
{
    // Initialize LCD display
    lcd_init(LCD_DISP_ON);
    lcd_gotoxy(1, 0); lcd_puts("value:");
    lcd_gotoxy(3, 1); lcd_puts("key:");
    lcd_gotoxy(8, 0); lcd_puts("a");    // Put ADC value in decimal
    lcd_gotoxy(13,0); lcd_puts("b");    // Put ADC value in hexadecimal
    lcd_gotoxy(8, 1); lcd_puts("c");    // Put button name here

    // Configure ADC to convert PC0[A0] analog value
    // Set ADC reference to AVcc
	ADMUX |= (1 << REFS0);
	ADMUX &= ~(1 << REFS1);

    // Set input channel to ADC0
	ADMUX &= ~(1 << MUX0) | (1 << MUX1) | (1 << MUX2) | (1 << MUX3);
	
    // Enable ADC module
	ADCSRA |= (1 << ADEN);
	
    // Enable conversion complete interrupt
	ADCSRA |= (1 << ADIE); 
	
    // Set clock prescaler to 128
	ADCSRA |= (1 << ADPS0) | (1 << ADPS1) | (1 << ADPS2);

    // Configure 16-bit Timer/Counter1 to start ADC conversion
    // Enable interrupt and set the overflow prescaler to 262 ms
	TIM1_overflow_262ms();
	TIM1_overflow_interrupt_enable();

    // Initialize UART to asynchronous, 8N1, 9600
	uart_init(UART_BAUD_SELECT(9600, F_CPU));

    // Enables interrupts by setting the global interrupt mask
    sei();

    // Infinite loop
    while (1)
    {
        /* Empty loop. All subsequent operations are performed exclusively 
         * inside interrupt service routines ISRs */
    }

    	// Will never reach this
    	return 0;
}

/* Interrupt service routines ----------------------------------------*/
/**
 * ISR starts when Timer/Counter1 overflows. Use single conversion mode
 * and start conversion four times per second.
 */
ISR(TIMER1_OVF_vect)
{
    	// Start ADC conversion
	ADCSRA |= (1 << ADSC);

}

/* -------------------------------------------------------------------*/
/**
 * ISR starts when ADC completes the conversion. Display value on LCD
 * and send it to UART.
 */
ISR(ADC_vect)
{
    uint16_t value = ADC;
    char lcd_string[8] = "        ";
    
	// Clear decimal and hex positions
	lcd_gotoxy(8, 0);
	lcd_puts(lcd_string);
	
	// Print ADC value on LCD in decimal 
	itoa(value, lcd_string, 10);
	lcd_gotoxy(8, 0);
	lcd_puts(lcd_string);
	
	if (value < 1030)
	{
		// Send data through UART
		uart_puts("ADC value in decimal: ");
		uart_puts(lcd_string);
		uart_puts("\r\n");
	}
	
	// Print ADC value on LCD in hex
	itoa(value, lcd_string, 16);
	lcd_gotoxy(13, 0);
	lcd_puts(lcd_string);
	
	// Clear key positions
	lcd_gotoxy(8, 1);
	lcd_puts("      ");
	lcd_gotoxy(8, 1);
	
	// Print key
	if (value > 1000)
	{
		lcd_puts("NONE");
	}
	
	if (value < 70)
	{
		lcd_puts("RIGHT");
	}
	
	if (value > 70 && value < 200)
	{
		lcd_puts("UP");
	}
	
	if (value > 200 && value < 370)
	{
		lcd_puts("DOWN");
	}
	
	if (value > 370 && value < 600)
	{
		lcd_puts("LEFT");
	}
	
	if (value > 600 && value < 1000)
	{
		lcd_puts("SELECT");
	}
	
	if (value > 1000)
	{
		int parity = 0;
		itoa(parity, lcd_string, 10);
		lcd_gotoxy(15,1);
		lcd_puts(lcd_string);
	} 
	else
	{
		int memory[32];
		int i = 0, j, parity = 0;
		
		while (value > 0)
		{
			memory[i] = value % 2;
			value = value/2;
			i++;
		}
		
		for (j = i - 1; j > 0; j--)
		if(memory[j] == 1)
		{
			parity++;
		}
		else
		{
			parity = 0;
		}
		
		itoa(parity, lcd_string, 10);
		lcd_gotoxy(15,1);
		lcd_puts(lcd_string);
	}
}