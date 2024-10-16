# Makefile for assembly program on Arduino Uno (ATmega328P)

# Define the microcontroller, clock frequency, and programmer
MCU = atmega328p
PROGRAMMER = arduino
PORT = /dev/ttyACM0          
BAUD = 115200

# Toolchain commands
AS = avr-as
LD = avr-ld
OBJCOPY = avr-objcopy
AVRDUDE = avrdude

# Source and target files
ASM = main.asm
OBJ = main.o
TARGET = main.elf
HEX = main.hex

all: $(HEX)

# Assemble the assembly file to an object file
$(OBJ): $(ASM)
	$(AS) -mmcu=$(MCU) -o $(OBJ) $(ASM)

# Link the object file to an ELF file
$(TARGET): $(OBJ)
	$(LD) -o $(TARGET) $(OBJ)

# Convert the ELF file to HEX format
$(HEX): $(TARGET)
	$(OBJCOPY) -O ihex -R .eeprom $(TARGET) $(HEX)

# Upload the HEX file to the Arduino
upload: $(HEX)
	$(AVRDUDE) -v -p $(MCU) -c $(PROGRAMMER) -P $(PORT) -b $(BAUD) -U flash:w:$(HEX):i

# Clean the generated files
clean:
	rm -f $(OBJ) $(TARGET) $(HEX)

