TTY=/dev/ttyUSB0

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
	sudo rglupload $(TTY) hello.o 0x0EF000 0x300

start:
	sudo rglexecute $(TTY) 0x0EF000

run: clean hello upload start

clean:
	rm -f *.o dummy  
