/*
 * Group23.c
 *
 * Created: 13/08/2017 5:48:06 p.m.
 * Author : char620
 */ 

#include <avr/io.h>
//#include "functions23.c"
#include "prototypes23.h"

#define F_CPU 16000000// Clock Speed
#define BAUD 9600
#define MYUBRR F_CPU /16/BAUD-1
#define TIME_DELAY 500
/* declare global variables here*/
int main( void )
{
uint8_t data =0;
usart_init (MYUBRR );
uint8_t TXBUF[] = {83, 85, 80, 45, 71, 69, 33, 33, 33, 33};
uint8_t txindex = 0;
while (1){
//read array into data variable
data = TXBUF[txindex];
//Transmit data by calling usart_transmit function
usart_transmit (data);
// increment index
txindex ++;
}
return 0;
}
// if you copy paste from pdf you might get some weird errors
//as copied characters may not be recognized by the IDE.