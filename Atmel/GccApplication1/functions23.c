#include <avr/io.h>

/*********************/
//functions23.c
/********************/

void usart_init(uint16_t MYUBRR)
{
	// Set baud rate using register UBRR0H and UBRR0L
    UBRR0H = (MYUBRR >> 8);
	UBRR0L = MYUBRR;


	// Enable USART transmitter inside register UCSR0B
	UCSR0B |= (1<<TXEN0);
	

	// Setting the number of data bits (Character Size) in a frame the Receiver and Transmitter use
	UCSR0C |= (1<<UCSZ01)|(1<<UCSZ00);

}


void usart_transmit(uint8_t data )
{
	/* Wait for empty UDR register */
	// when UDRE0 is 1 the buffer is empty, 
	while (   !((1<<UDRE0) & UCSR0A)      );

	/* Put data into UDR0, sends the data */
    UDR0 = data;
 
}