#include <avr/io.h> // includes definitions of I/O registers
#include <stdint.h> // includes definition of uint8_t

void	setDDRB5_high(void){
	volatile register uint8_t bit5High = 0x20; // (1 << 5)
	// we use binary or to reserve registers other bits 
	DDRB |= bit5High; // we set DDRB5 high to make it writable
}

void sleep_for_500ms(void){
	volatile register uint8_t r_21 = 0x20;
	while(r_21 > 0){
		volatile register uint8_t r_18 = 0xFF;
		while(r_18 > 0){
			volatile register uint8_t r_19 = 0xFF;
			while(r_19 > 0){
				--r_19;
			}
			--r_18;
		}
		--r_21;
	}
	return ;
}

int main(void){
	volatile register uint8_t pin5High = 0x20; // (1 << 5)
	volatile register uint8_t pin5Low = 0xDF; // all bits except 5th high
	setDDRB5_high();
	while (1)
	{
		PORTB |= pin5High; // we set PORTB5 high
		sleep_for_500ms();
		PORTB &= pin5Low; // we set PORTB5 low
		sleep_for_500ms();
	}
	return 0;
}

