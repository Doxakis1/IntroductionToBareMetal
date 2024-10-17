//#include <avr/io.h> // includes definitions of I/O registers
#include <stdint.h> // includes definition of uint8_t

uint8_t *DDRB_ptr = (uint8_t *)0x24;
#define DDRB (*DDRB_ptr)
uint8_t *PORTB_ptr = (uint8_t *)0x25;
#define PORTB (*PORTB_ptr)

void main(void){
	volatile register uint8_t pin5High = 0x20; // (1 << 5)
	// we use binary or to reserve registers other bits 
	
	DDRB |= pin5High; // we set DDRB5 high to make it writable
	PORTB |= pin5High; // we set PORTB5 high
	while (1)
		;
	return ;
}

