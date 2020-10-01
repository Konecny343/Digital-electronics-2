/***********************************************************************
 * 
 * Alternately toggle two LEDs when a push button is pressed.
 * ATmega328P (Arduino Uno), 16 MHz, AVR 8-bit Toolchain 3.6.2
 *
 * Copyright (c) 2018-2020 Tomas Fryza
 * Dept. of Radio Electronics, Brno University of Technology, Czechia
 * This work is licensed under the terms of the MIT license.
 * 
 **********************************************************************/

/* Defines -----------------------------------------------------------*/
#define LED_RED5   PB5     // AVR pin where red LED (number five) is connected
#define LED_RED4   PB4	   // AVR pin where red LED (number four) is connected
#define LED_RED3   PB3	   // AVR pin where red LED (number three) is connected
#define LED_RED2   PB2	   // AVR pin where red LED (number two) is connected
#define LED_RED1   PB1	   // AVR pin where red LED (number one) is connected
#define DELAY	   250
#ifndef F_CPU
#define F_CPU 16000000      // CPU frequency in Hz required for delay
#endif

/* Includes ----------------------------------------------------------*/
#include <util/delay.h>     // Functions for busy-wait delay loops
#include <avr/io.h>         // AVR device-specific IO definitions

/* Functions ---------------------------------------------------------*/
/**
 * Main function where the program execution begins. Toggle two LEDs 
 * when a push button is pressed.
 */
int main(void)
{
    	 /* LED RED ONE */
    	 // Set pin as output in Data Direction Register...
    	 DDRB = DDRB | (1<<LED_RED1);
    	 // ...and turn LED off in Data Register
    	 PORTB = PORTB & ~(1<<LED_RED1);

     	 /* LED RED TWO */
     	 DDRB = DDRB | (1<<LED_RED2);
	 PORTB = PORTB & ~(1<<LED_RED2);
	 
	 /* LED RED THREE */
	 DDRB = DDRB | (1<<LED_RED3);
	 PORTB = PORTB & ~(1<<LED_RED3);
	 
	 /* LED RED FOUR */
	 DDRB = DDRB | (1<<LED_RED4);
	 PORTB = PORTB & ~(1<<LED_RED4);
	 
	 /* LED RED FIVE */
	 DDRB = DDRB | (1<<LED_RED5);
	 PORTB = PORTB & ~(1<<LED_RED5);
	
    // Infinite loop
    while (1)
    {
		// Move left to right
        	PORTB = PORTB ^ (1<<LED_RED1);
        	_delay_ms(DELAY);
        	PORTB = PORTB ^ (1<<LED_RED1);
       
		PORTB = PORTB ^ (1<<LED_RED2);
		_delay_ms(DELAY);
		PORTB = PORTB ^ (1<<LED_RED2);
		
		PORTB = PORTB ^ (1<<LED_RED3);
		_delay_ms(DELAY);
		PORTB = PORTB ^ (1<<LED_RED3);
		
		PORTB = PORTB ^ (1<<LED_RED4);
		_delay_ms(DELAY);
		PORTB = PORTB ^ (1<<LED_RED4);
		
		PORTB = PORTB ^ (1<<LED_RED5);
		_delay_ms(DELAY);
		PORTB = PORTB ^ (1<<LED_RED5);
		
		//Move right to left
		PORTB = PORTB ^ (1<<LED_RED5);
		_delay_ms(DELAY);
		PORTB = PORTB ^ (1<<LED_RED5);
		
		PORTB = PORTB ^ (1<<LED_RED4);
		_delay_ms(DELAY);
		PORTB = PORTB ^ (1<<LED_RED4);
		
		PORTB = PORTB ^ (1<<LED_RED3);
		_delay_ms(DELAY);
		PORTB = PORTB ^ (1<<LED_RED3);
		
		PORTB = PORTB ^ (1<<LED_RED2);
		_delay_ms(DELAY);
		PORTB = PORTB ^ (1<<LED_RED2);
		
		PORTB = PORTB ^ (1<<LED_RED1);
		_delay_ms(DELAY);
		PORTB = PORTB ^ (1<<LED_RED1);
		
    }
	
    // Will never reach this
    return 0;
}