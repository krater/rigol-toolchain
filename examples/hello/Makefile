ASMSRCS = hello.asm

INCLUDES = -I/opt/rigol/include/rigol/02.05.02.00
ASMFLAGS = -R --warn --noexecstack $(INCLUDES)

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
	rglupload /dev/ttyS0 hello.o 0xef000 0x300

start:
	rglexecute /dev/ttyS0 0x0EF000

clean:
	rm -f *.o dummy  
