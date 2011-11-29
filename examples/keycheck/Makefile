ASMSRCS = keycheck.asm

INCLUDES = -I/opt/rigol/include/rigol/02.05.02.00
ASMFLAGS = --warn --noexecstack $(INCLUDES)

OBJS = $(ASMSRCS:%.asm=%.o) 

AS = bfin-uclinux-as
LD = bfin-uclinux-ld

%.o: %.asm
	$(AS) $(ASMFLAGS) -o $@ $<

default: all
all:	clean hello

hello:	$(OBJS)
	$(LD) -o dummy $(OBJS)

upload: hello
	rglupload /dev/ttyUSB0 dummy 0xef000 0x300

start:
	rglexecute /dev/ttyUSB0 0x0EF000

clean:
	rm -f *.o dummy  
