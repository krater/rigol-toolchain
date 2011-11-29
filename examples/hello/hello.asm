.include "rigol.inc"
.include "clib.inc"
.include "keyboard.inc"

.include "upload_startup.inc"

#output messagebox
  R1=7
  R0.L = hello
  R0.H = hello
  CALL MessageBox

lp1:
  CALL GetKeyFromQueue
  CC=R0==0              #KC_NOKEY
  IF CC JUMP lp1

  JUMP.L JumpBack

hello:
.asciz "  Hello World ! :)"

.include "endline.inc"

