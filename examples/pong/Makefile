ASMSRCS = pong.asm

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
	rigol-upload

clean:
	rm -f *.o dummy  
