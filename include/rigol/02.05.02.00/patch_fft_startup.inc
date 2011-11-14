.equ StartFreeCode,  0x0B7D7A # FFT-Command
.equ StartFreeData,  0xA00000
.equ JumpBack,       0x0B7D7A

.section text
.global __start
__start:
 JUMP __start


.org StartFreeCode-21
.ascii "** Start Homebrew **"
.org StartFreeCode
