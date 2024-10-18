.equ DDRD , 0x0A	; define the DDRB address as per ATmega328P docs
.equ PORTD , 0x0B	; define the PORTB address as per ATmega328P docs
.equ DDRB , 0x04	; define the DDRB address as per ATmega328P docs
.equ PORTB , 0x05	; define the PORTB address as per ATmega328P docs
.equ SPH , 0x0E		; define the SPH address as per ATmega328P docs
.equ SPL , 0x3D		; define the SPH address as per ATmega328P docs
.equ r16 , 0x10		; define the register we want to use
.equ r15 , 0x0F		; define the register we want to use
; in AVR-GCC documentation we see that registers R2-R17,R28 and R29 are 
; preserved while R18-R27, R30 and R31 are clobbered, that is why I will next
; introduce R18,R19 and R20 so that we can use them when we are calling 
; functions without having to preserve them
.equ r18 , 0x12 	; define the register we want to use
.equ r19 , 0x13 	; define the register we want to use
.equ r20 , 0x14 	; define the register we want to use
.equ r21 , 0x14 	; define the register we want to use
.org 0x0000	; Set the origin to the zero
	rjmp	SETUP
SLEEP_FOR_500ms:
	ldi	r20, 0x00; 1 cycle
	ldi	r21, 0x20; 1 cycle
_SLEEP_FOR_500ms_main:
	dec	r21	; 1 cycle
	cp	r21, r20; 1 cycle
	breq	_SLEEP_FOR_500ms_end; 2 cycles
	ldi	r18, 0xFF; 1 cycle
_SLEEP_FOR_500ms_loop1:
	dec	r18	; 1 cycle
	cp	r18, r20; 1 cycle
	breq	_SLEEP_FOR_500ms_main; 2 cycles
	ldi	r19, 0xFF; 1 cycle
_SLEEP_FOR_500ms_loop2:
	dec	r19	; 1 cycle
	cp	r19, r20; 1 cycle
	brne	_SLEEP_FOR_500ms_loop2; 2 cycles
	rjmp	_SLEEP_FOR_500ms_loop1; 2 cycles
_SLEEP_FOR_500ms_end:
	ret
SETUP:
	ldi	r16, 0x08
	out	SPH, r16	; set stackpointer high byte to 0x08
	ldi	r16, 0xFF
	out	SPH, r16	; set stackpointer low byte to 0xFF
	ldi	r16, 0xFF	; Load 255 into r16 to set all bits of DDRD 
	out 	DDRD, r16	; Set DDB5 high to make it write pin
	rjmp	SET_YELLOW_PINS_ON; we could have left this drop technically
SET_YELLOW_PINS_ON:
	ldi	r16, 0x88	; Load 0b10001000 to r16 (yellow pins) 
	out	PORTD, r16	; Set PORTD yellow LEDS on
	rcall	SLEEP_FOR_500ms	; Sleep for 500 ms
SET_RED_PINS:
	ldi	r16, 0x44	; Load 0b01000100 to r16 (red pins) 
	out	PORTD, r16	; Set PORTD red LEDS on
	rcall	SLEEP_FOR_500ms	; Sleep for 500 ms
SET_GREEN_PINS_ON:
	ldi	r16, 0x22	; Load 0b00100010 to r16 (green pins) 
	out	PORTD, r16	; Set PORTD green LEDS on
	rcall	SLEEP_FOR_500ms	; Sleep for 500 ms
SET_BLUE_PINS_ON:
	ldi	r16, 0x11	; Load 0b00010001 to r16 (blue pins) 
	out	PORTD, r16	; Set PORTD blue LEDS on
	rcall	SLEEP_FOR_500ms	; Sleep for 500 ms
	rjmp	SET_YELLOW_PINS_ON; Set pin low

