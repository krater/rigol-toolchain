TTY=/dev/ttyUSB0

ASMSRCS = pong.asm

INCLUDES = -I/opt/rigol/include/rigol/02.05.02.00
ASMFLAGS = --warn --noexecstack $(INCLUDES)

OBJS = $(ASMSRCS:%.asm=%.o) 

AS = bfin-uclinux-as
LD = bfin-uclinux-ld

%.o: %.asm
	$(AS) $(ASMFLAGS) -o $@ $<

default: all
all:	clean pong

pong:	$(OBJS)
	$(LD) -o dummy $(OBJS)

upload:	pong
	sudo rglupload $(TTY) dummy 0x0EF000 0x600

start:	
	sudo rglexecute $(TTY) 0x0EF000

run: clean pong upload start

clean:
	rm -f *.o dummy