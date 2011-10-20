.include "rigol.inc"
.include "clib.inc"
.include "keyboard.inc"

.include "upload_startup.inc"


OperateKeys:
  P0.L=Variables
  P0.H=Variables

  CALL GetCharFromQueue
 
  R1=KC_LR_VERTICAL_SCALE
  CC=R0==R1
  IF CC JUMP bla

  R1=KC_RR_VERTICAL_SCALE
  CC=R0==R1
  IF CC JUMP blubb

  R1=KC_LR_TRIGGER_SCALE
  CC=R0==R1
  IF CC JUMP bla

  R1=KC_RR_TRIGGER_SCALE
  CC=R0==R1
  IF CC JUMP blubb





PaintPlayfield:

  P0.L=Variables
  P0.H=Variables

  R0=W[P0+14]
  CALL set_PaintColor

  R0=0
  R1=0
  R2=320
  R3=234
  [SP+0x0c]=R3
  CALL PaintBox 


  R0=W[P0+16]
  CALL set_PaintColor

  R0=W[P0+0]             # player 1 x
  R1=W[P0+2]             # player 1 y
  R2=10
  R3=100
  [SP+0x0c]=R3
  CALL PaintBox 


  R0=W[P0+18]
  CALL set_PaintColor

  R0=W[P0+4]             # player 2 x
  R1=W[P0+8]             # player 2 y
  R2=10
  R3=100
  [SP+0x0c]=R3
  CALL PaintBox



  R0=W[P0+20]
  CALL set_PaintColor

  R0=W[P0+10]            # ball x
  R1=W[P0+12]            # ball y
  R2=10
  R3=10
  [SP+0x0c]=R3
  CALL PaintBox

  RTS






# Variables
Variables:
  .word 20               # player 1 x
  .word 50               # player 1 y

  .word 30               # player 2 x
  .word 70               # player 2 y

  .word 40               # ball x
  .word 70               # ball y

  .word 0x0000           # Playfield Color
  .word 0xffff           # Player1Color
  .word 0xffff           # Player2Color
  .word 0xffff           # BallColor


.include "endline.inc"
