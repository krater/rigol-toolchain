TTY=/dev/ttyUSB0

ASMSRCS = keycheck.asm

INCLUDES = -I/opt/rigol/include/rigol/02.05.02.00
ASMFLAGS = --warn --noexecstack $(INCLUDES)

OBJS = $(ASMSRCS:%.asm=%.o) 

AS = bfin-uclinux-as
LD = bfin-uclinux-ld

%.o: %.asm
	$(AS) $(ASMFLAGS) -o $@ $<

default: all
all:	clean keyckeck

keyckeck:	$(OBJS)
	$(LD) -o dummy $(OBJS)

upload: keyckeck
	sudo rglupload $(TTY) dummy 0xEF000 0x300

start:
	sudo rglexecute $(TTY) 0x0EF000

run: clean keyckeck upload start

clean:
	rm -f *.o dummy  
