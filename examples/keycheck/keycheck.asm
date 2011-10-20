.include "rigol.inc"
.include "clib.inc"
.include "keyboard.inc"

.include "upload_startup.inc"

#unlock keys
  R0=0
  CALL Set_KeyLock

#output messagebox
  R0.L = hello
  R0.H = hello
  CALL strlen

  R1=7
  R0.L = hello
  R0.H = hello
  CALL MessageBox

lp2:

#write text to screen
  R0=0x0000
  CALL set_PaintColor

  R0=78
  R1=2
  R2=20
  R3=11
  [SP+0x0c]=R3
  CALL PaintBox

  R0=0x0f05
  CALL set_PaintColor

  R0=82
  R1=4
  CALL set_TextPaintPos

lp1:
  CALL GetKeyFromQueue
  CC=R0==KC_NOKEY
  IF CC JUMP lp1

  R1=R0
  R0.L=fstr
  R0.H=fstr
  CALL vprintf

#output to screen
  P1.L=0xee8c
  P1.H=0xffa0
  CALL (P1)

  JUMP lp2

hello:
  .asciz "Press your keys..."

fstr:
  .asciz "%x"


.include "endline.inc"
