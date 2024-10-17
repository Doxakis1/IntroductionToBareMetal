.equ DDRB , 0x04	; define the DDRB address as per ATmega328P docs
.equ PORTB , 0x05	; define the PORTB address as per ATmega328P docs
.equ r16 , 0x10		; define the register we want to use
.equ r15 , 0x0F 	; define the register we want to use
.org 0x0000	; Set the origin to the zero

SET_PIN_HIGH:
	ldi	r16, 0x20	; Load (1 << 5)  into r16 to set DDB5 
	in	r15, DDRB	; Store current DDRB state
	ori	r16, r15	; Do binary or to set DDRB5 bit high
	out 	DDRB, r16	; Set DDB5 high to make it write pin
	ldi	r16, 0x20	; Load (1 << 5)  into r16 to set DDB5 
	in	r15, PORTB	; Store current PORTB state
	ori	r16, r15	; Do binary or to set PORTB5 bit high
	out	PORTB, r16  ; Set PORTB5 high to turn the LED on
MAIN_LOOP:
	rjmp MAIN_LOOP	; Make an infinite loop like while(1)

