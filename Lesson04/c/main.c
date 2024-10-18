#include <avr/io.h> // includes definitions of I/O registers
#include <stdint.h> // includes definition of uint8_t

void	setDDRD_high(void){
	volatile register uint8_t bit5High = 0xFF; // all bits high
	DDRD |= bit5High; // we set DDRD high to make it writable
}

void	setDDRB_low(void){
	volatile register uint8_t bitsLow = 0x0; // all bits low
	DDRB = bitsLow; // we set DDRD low to make it readable
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
	volatile register uint8_t colorYellow = 0x88; // 10001000
	volatile register uint8_t colorRed = 0x44; // 01000100
	volatile register uint8_t colorGreen = 0x22; // 00100010
	volatile register uint8_t colorBlue = 0x11; // 00010001
	setDDRD_high();
	setDDRB_low();
	sleep_for_500ms();
	volatile register uint8_t previousState = PINB & 0x20; //PINB5 previousState
	while(1){
		sleep_for_500ms();
		volatile register uint8_t newState = PINB & 0x20; //PINB5 previousState
		if (previousState != newState)
			break ;
	}
	while(1)
	{	
		PORTD = colorYellow; // we set PORTB5 high
		sleep_for_500ms();
		PORTD = colorRed; // we set PORTB5 low
		sleep_for_500ms();
		PORTD = colorGreen; // we set PORTB5 low
		sleep_for_500ms();
		PORTD = colorBlue; // we set PORTB5 low
		sleep_for_500ms();
	}
	return 0;
}

