# Makefile for C program on Arduino Uno (ATmega328P)

# Define the microcontroller, clock frequency, and programmer
MCU = atmega328p
F_CPU = 16000000UL
PROGRAMMER = arduino
PORT = /dev/ttyACM0
BAUD = 115200

# Toolchain commands
CC = avr-gcc
OBJCOPY = avr-objcopy
AVRDUDE = avrdude

# Compiler flags
CFLAGS = -mmcu=$(MCU) -DF_CPU=$(F_CPU) -Os

# Source and target files
SRC = main.c
TARGET = main.elf
HEX = main.hex

all: $(HEX)

# Compile the C program to ELF
$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

# Convert the ELF file to HEX format
$(HEX): $(TARGET)
	$(OBJCOPY) -O ihex -R .eeprom $(TARGET) $(HEX)

# Upload the HEX file to the Arduino
upload: $(HEX)
	$(AVRDUDE) -v -p $(MCU) -c $(PROGRAMMER) -P $(PORT) -b $(BAUD) -U flash:w:$(HEX):i

# Clean the generated files
clean:
	rm -f $(TARGET) $(HEX)
re: clean all
