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
	rglupload /dev/ttyS0 dummy 0xef000 0x600

start:	
	rglexecute /dev/ttyS0 0x0EF000

clean:
	rm -f *.o dummy  
