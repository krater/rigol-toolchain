.include "rigol.inc"
.include "clib.inc"
.include "keyboard.inc"

.include "upload_startup.inc"


  R0.L = hello
  R0.H = hello
  CALL strlen

#R1 = R0
#R0.L = hello
#R0.H = hello
#CALL exec_UART_WRITE

  R1=7
  R0.L = hello
  R0.H = hello
  CALL MessageBox

lp:
  CALL GetKeyFromQueue
  CC=R0==KC_NOKEY
  IF CC JUMP lp


  RTS

hello:
.asciz "Hello World ! :)"


.include "endline.inc"

