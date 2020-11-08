/***********************************************************************
 * 
 * Stopwatch with LCD display output.
 * ATmega328P (Arduino Uno), 16 MHz, AVR 8-bit Toolchain 3.6.2
 *
 * Copyright (c) 2017-2020 Tomas Fryza
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

/* Function definitions ----------------------------------------------*/
/**
 * Main function where the program execution begins. Update stopwatch
 * value on LCD display when 8-bit Timer/Counter2 overflows.
 */
int main(void)
{
    // Initialize LCD display
    lcd_init(LCD_DISP_ON);
	
    // Display first custom character
    lcd_gotoxy(14, 1);
    lcd_putc(0x46);
    //lcd_gotoxy(15, 1);
    lcd_putc(0x4b);
    // Put string(s) at LCD display
    lcd_gotoxy(1, 0);
    lcd_puts("00:00.0");
	

    // Configure 8-bit Timer/Counter2 for Stopwatch
    // Enable interrupt and set the overflow prescaler to 16 ms
    TIM2_overflow_16ms();
    TIM2_overflow_interrupt_enable();
	
    // Configure 8-bit Timer/Counter0 for Stopwatch
    // Enable interrupt and set the overflow prescaler to 16 ms
    TIM0_overflow_16ms();
    TIM0_overflow_interrupt_enable();

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
 * ISR starts when Timer/Counter2 overflows. Update the stopwatch on
 * LCD display every sixth overflow, ie approximately every 100 ms
 * (6 x 16 ms = 100 ms).
 */
ISR(TIMER2_OVF_vect)
{
    static uint8_t number_of_overflows = 0;
	static uint8_t tens = 0;			// Tenths of a second
	static uint8_t secs = 0;			// Seconds
	static uint8_t minut = 0;			// Minutes
	static uint16_t secsSquare = 0;			// secs * secs
	char lcd_string[2] = "  ";			// String for converting numbers by itoa()
	
    number_of_overflows++;
    if (number_of_overflows >= 6)
    {
        // Do this every 6 x 16 ms = 100 ms
        number_of_overflows = 0;

        tens++;
	if (tens > 9)
	{
		tens = 0;
		secs++;
		
		secsSquare = secs * secs;
		itoa(secsSquare, lcd_string, 10);
		lcd_gotoxy(11, 0);
		// Display secsSquare
		lcd_puts(lcd_string);
	}
		
	itoa(tens, lcd_string, 10);
	lcd_gotoxy(7, 0);
	// Display tenths of a second
	lcd_puts(lcd_string);
		
	if (secs > 59)
	{
		minut++;
		secs = 0;
		lcd_gotoxy(4, 0);
		lcd_putc('0');
		secsSquare = 0;
		// Deleting values on positions secsSquare
		lcd_gotoxy(11, 0);
		lcd_putc(' ');
		lcd_gotoxy(12, 0);
		lcd_putc(' ');
		lcd_gotoxy(13, 0);
		lcd_putc(' ');
		lcd_gotoxy(14, 0);
		lcd_putc(' ');
	}
		
	itoa(secs, lcd_string, 10);
	if (secs > 9)
	{
		lcd_gotoxy(4, 0);
	} 
	else
	{
		lcd_gotoxy(5, 0);
	}
	// Display seconds
	lcd_puts(lcd_string);
		
	if (minut > 59)
	{
		minut = 0;
		lcd_putc('0');
		lcd_gotoxy(2, 0);
	}
	itoa(minut, lcd_string, 10);
		
	if (minut > 9)
	{
		lcd_gotoxy(1, 0);
	} 
	else
	{
		lcd_gotoxy(2, 0);
	}
	// Display minutes
	lcd_puts(lcd_string);	
    }
}

ISR(TIMER0_OVF_vect)
{
	static uint8_t symbol = 0;
	static uint8_t position = 0;

	lcd_gotoxy(1 + position, 1);
	lcd_putc(symbol);

	symbol++;
	if (symbol > 5)
	{
		position++;
		symbol = 0;
		if (position == 9)
		{
			position = 0;
			lcd_gotoxy(9,1);
			lcd_putc(0xff);
			lcd_gotoxy(8,1);
			lcd_putc(0xff);
			lcd_gotoxy(7,1);
			lcd_putc(0xff);
			lcd_gotoxy(6,1);
			lcd_putc(0xff);
			lcd_gotoxy(5,1);
			lcd_putc(0xff);
			lcd_gotoxy(4,1);
			lcd_putc(0xff);
			lcd_gotoxy(3,1);
			lcd_putc(0xff);
			lcd_gotoxy(2,1);
			lcd_putc(0xff);
			lcd_gotoxy(1,1);
			lcd_putc(0xff);
		}
	}
}
