ASMSRCS = rwpatch.asm

INCLUDES = -I/opt/rigol/include/rigol/02.05.02.00
ASMFLAGS = --warn --noexecstack $(INCLUDES)

OBJS = $(ASMSRCS:%.asm=%.o) 

AS = bfin-uclinux-as
LD = bfin-uclinux-ld

%.o: %.asm
	$(AS) $(ASMFLAGS) -o $@ $<

default: all
all:	clean rwpatch 

rwpatch:$(OBJS)
	$(LD) -o dummy $(OBJS)

patch:  rwpatch
	echo "9c28690d8d5a5690b7340fda943f5549  DS1000EUpdate.RGL" >chksum
	md5sum -c chksum
	rm -f chksum
	rglinject DS1000EUpdate.RGL 0xB7ECD 0xB8009 dummy
clean:
	rm -f *.o dummy chksum 
