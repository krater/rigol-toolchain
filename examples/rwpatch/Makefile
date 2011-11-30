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
	@echo "9c28690d8d5a5690b7340fda943f5549  DS1000EUpdate.RGL" >chksum
	@echo "Old checksum..."
	@md5sum -c chksum
	@rm -f chksum
	@cp DS1000EUpdate.RGL DS1000EUpdate.RGL.org
	@rglinject DS1000EUpdate.RGL 0xB7ECD 0xB800B dummy
	@rglpatchversion DS1000EUpdate.RGL 3
	@echo "3ffccd4edcc70710e010124edec9ee1c  DS1000EUpdate.RGL" >chksum
	@echo "New checksum..."
	@md5sum -c chksum
	@rm -f chksum
	@echo "\033[40;32mFirmware ready to flash. :)\033[40;m"

clean:
	rm -f *.o dummy chksum 
