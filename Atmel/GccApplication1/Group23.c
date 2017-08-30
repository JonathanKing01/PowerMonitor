/*
 * Group23.c
 *
 * Created: 13/08/2017 5:48:06 p.m.
 * Author : char620
 */ 

#include <avr/io.h>
#include "prototypes23.h"

#define F_CPU 16000000// Clock Speed
#define BAUD 9600
#define MYUBRR (F_CPU /16/BAUD)-1


int main( void )
{

	uint8_t data =0;  // initialize vale for data thats being transmitted

	usart_init (MYUBRR ); // Calling the function that initializes the serial port

	uint8_t TXBUF[] = {7}; // Data array being transmitted

	uint8_t txindex = 0;  // initialize index position of array

while (1){
// if array index is less that 8 then complete the follow:
	if(txindex < 8) {
		data = TXBUF[txindex]; //read array into data variable
		usart_transmit (data); //Transmit data by calling usart_transmit function
		txindex ++;
	}
	else 
		txindex = 0;  // reset the value of the index back to 0
}
return 0;
}
