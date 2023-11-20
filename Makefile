MMCU = atmega328p
FCPU = 16000000

CC = avr-gcc
FLAGS = -mmcu=$(MCU)
CFLAGS = -Wall $(FLAGS) -DF_CPU=$(FCPU) -Os
LDFLAGS = $(FLAGS)

TARGET = ordonnanceur

all: $(TARGET).hex

clean:
	rm -f *.o $(TARGET).hex $(TARGET).elf $(TARGET)

	
$(TARGET).o: $(TARGET).c $(TARGET).h
	$(CC) -mmcu=$(MMCU) -DF_CPU=$(FCPU)L -c -Wall -I. -Os $< -o $@
	
$(TARGET).elf: $(TARGET).o
	$(CC) -mmcu=$(MMCU) -g -lm -Wl,--gc-sections -o $@ $<

$(TARGET).hex: $(TARGET).elf
	avr-objcopy -j .text -j .data -O ihex $< $@

upload: $(TARGET).hex
	stty -F /dev/ttyACM0 hupcl
	avrdude -F -v -p $(MMCU) -c stk500v1 -b 115200 -P /dev/ttyACM0 -U flash:w:$<
