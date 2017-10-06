CC=avr-gcc
MCU=atmega16m1
PROGRAMMER=avrispmkII
PORT=usb
AVRDUDE=avrdude
OBJCOPY=avr-objcopy

SRCDIR=src
BUIDIR=build

SRCS=$(wildcard $(SRCDIR)/*.c)

CFLAGS+=-mmcu=$(MCU) -g -Os -Wall -Werror -Wunused -I$(LIBDIR)/
AVRFLAGS+=-p $(MCU) -v -c $(PROGRAMMER) -P $(PORT)

$(BUIDIR)/out.hex: $(BUIDIR)/out.elf
	$(OBJCOPY) -R .eeprom -O ihex $< $@

$(BUIDIR)/out.elf: $(SRCS) | $(BUIDIR)
	$(CC) -c -o $@ $< $(CFLAGS)

$(BUIDIR):
	mkdir -p $(BUIDIR)

.PHONY: flash
flash: $(BUIDIR)/out.hex
	sudo $(AVRDUDE) $(AVRFLAGS) -U flash:w:$<

