.include "rigol.inc"
.include "clib.inc"
.include "keyboard.inc"

.include "upload_startup.inc"

JUMP RealStart

# text must be align 4, but actually we can't use align :(
# so we put the text at start of the code

fmtstring:
.asciz "%u"

start:
.asciz "Press CH1 or CH2"
.byte 0
anykey:
.asciz "Press any key "


# Variables
Variables:
  .word 30               # 00  player 1 x
  .word 50               # 02  player 1 y

  .word 280              # 04  player 2 x
  .word 70               # 06  player 2 y

  .word 40               # 08  ball x
  .word 70               # 10  ball y

  .word 0x0000           # 12  Playfield Color
  .word 0xffff           # 14  Player1Color
  .word 0xffff           # 16  Player2Color
  .word 0x0f00           # 18  BallColor

  .word 0x0000           # 20  loopcount

  .word 4                # 22  ball dx
  .word 4                # 24  ball dy

  .word 0                # 26  points pl1
  .word 0                # 28  points pl2

  .word 0xbeef           # 30  random seed

  .word 0

#Attention, Code must be align 2 (or 4?)




RealStart:

#unlock keys
  LINK 0x40

  R0=0
  CALL Set_KeyLock

  CALL InitAll

lp1:
  CALL MoveBall
  CALL PaintPlayfield
  CALL StartPainting

lp2:
  CALL OperateKeys
  R1=0
  CC=R0==R1
  IF CC JUMP gameend

  P0.L=Variables
  P0.H=Variables
  R1=W[P0+20]
  R1+=1
  W[P0+20]=R1
  R0=128
  CC=R1<R0
  IF CC JUMP lp2

  R0=0
  P0.L=Variables
  P0.H=Variables
  W[P0+20]=R0
  JUMP lp1


gameend:
  UNLINK
  RTS

#  JUMP.L JumpBack


############################################################
#  Read Key and work with it
#

OperateKeys:
  LINK 0x0

  P0.L=Variables
  P0.H=Variables

  CALL GetKeyFromQueue
 
  P0.L=Variables
  P0.H=Variables

  R1=KC_LR_VERTICAL_POSITION
  CC=R0==R1
  IF CC JUMP pl1down

  R1=KC_RR_VERTICAL_POSITION
  CC=R0==R1
  IF CC JUMP pl1up

  R1=KC_LR_TRIGGER_LEVEL
  CC=R0==R1
  IF CC JUMP pl2down

  R1=KC_RR_TRIGGER_LEVEL
  CC=R0==R1
  IF CC JUMP pl2up

  R1=KC_R_MENU
  CC=R0==R1
  IF !CC JUMP KeysEnd 

  R0=0

  UNLINK
  RTS


KeysEnd:
  R0=1

  UNLINK
  RTS


pl1down:
  R1=W[P0+2]
  R2=(234-50-3)
  CC=R1<R2
  IF !CC JUMP KeysEnd
  R1+=3
  W[P0+2]=R1

  R0=2

  UNLINK
  RTS


pl1up:
  R1=W[P0+2]
  R2=3
  CC=R1<=R2
  IF CC JUMP KeysEnd
  R1+=-3
  W[P0+2]=R1

  R0=2

  UNLINK
  RTS


pl2down:
  R1=W[P0+6]
  R2=(234-50-3)
  CC=R1<R2
  IF !CC JUMP KeysEnd
  R1+=3
  W[P0+6]=R1

  R0=2

  UNLINK
  RTS

pl2up:
  R1=W[P0+6]
  R2=3
  CC=R1<=R2
  IF CC JUMP KeysEnd
  R1+=-3
  W[P0+6]=R1

  R0=2


  UNLINK
  RTS


############################################################
#  Move Ball
#

MoveBall:
  LINK 0x0

  P0.L=Variables
  P0.H=Variables

  R1=W[P0+8]	# Ball x
  R2=W[P0+10]	# Ball y
  R3=W[P0+22](x)# Ball dx
  R1=R1+R3
  R3=W[P0+24](x)# Ball dy
  R2=R2+R3

  ### check x move

  R0=(320-10-4)
  CC=R0<=R1
  IF CC JUMP pl1point
  
  R0=0+4
  CC=R0<R1
  IF !CC JUMP pl2point

  ## check for player hit
  R0=0
  CC=R0<R3
  IF CC JUMP chkpl2hit

chkpl1hit:
  R0.L=40 
  CC=R0<R1           # R1 is right of player1
  IF CC JUMP chky
  
  R0.L=30
  CC=R0<R1           # R1 is left of player1
  IF CC JUMP chky   

  JUMP pl1hit



chkpl2hit:

chky:
  ### check y move

  R0=(234-10-4)
  CC=R0<=R2
  IF CC JUMP goup

  R0=0+4
  CC=R0<R2
  IF !CC JUMP godown


move:
  W[P0+8]=R1
  W[P0+10]=R2

nomove:
  UNLINK
  RTS

goup:
  R0=-4
  W[P0+24]=R0
  JUMP move

godown:
  R0=-4
  W[P0+24]=R0
  JUMP move

pl1hit:
  R0=4
  #W[P0+22]=R0
  JUMP chky 

pl2hit:
  #R0=-4
  #W[P0+24]=R0
  JUMP chky


pl1point:
  R0=W[P0+26]
  R0+=1
  W[P0+26]=R0
  CALL StartPL2
  JUMP nomove

pl2point:
  R0=W[P0+28]
  R0+=1
  W[P0+28]=R0
  CALL StartPL1
  JUMP nomove


############################################################
#  InitAll
#

InitAll:
  LINK 0x10

  P0.L=Variables
  P0.H=Variables

  R0=0
  W[P0+26]=R0
  W[P0+28]=R0

  CALL PaintPlayfield

  R0.L=0xffff
  R0.H=0x0000
  CALL set_PaintColor

  R0=120
  R1=112
  CALL set_TextPaintPos

  R0.L=start
  R0.H=start
  CALL vprintf

  CALL StartPainting

waitforchkey:
  CALL GetKeyFromQueue
  R1=KC_R_CH1
  CC=R0==R1
  IF CC JUMP pl1start

  R1=KC_R_CH2
  CC=R0==R1
  IF CC JUMP pl2start

  JUMP waitforchkey

pl1start:
  CALL StartPL1
  UNLINK
  RTS

pl2start:
  CALL StartPL2
  UNLINK
  RTS


############################################################
#  Startpoints
#

StartPL1:

  P0.L=Variables
  P0.H=Variables

  R0=4
  W[P0+22]=R0     # ball dx
  W[P0+24]=R0     # ball dy

  R0=40
  W[P0+8]=R0      # ball x
  R0=70
  W[P0+10]=R0     # ball y

  RTS

StartPL2:

  P0.L=Variables
  P0.H=Variables

  R0=-4
  W[P0+22]=R0     # ball dx
  R0=4
  W[P0+24]=R0     # ball dy

  R0=320-40-10
  W[P0+8]=R0      # ball x
  R0=234-70-10
  W[P0+10]=R0     # ball y

  RTS



############################################################
#  Paint the Playfield
#

PaintPlayfield:
  LINK 0x60

  P0.L=Variables
  P0.H=Variables

  R0=W[P0+12]
  CALL set_PaintColor

  R0=0
  R1=0
  R2=320
  R3=234
  [SP+0x0c]=R3
  CALL PaintBox 


  P0.L=Variables
  P0.H=Variables
  R0=W[P0+14]
  CALL set_PaintColor

  P0.L=Variables
  P0.H=Variables
  R0=W[P0+0]             # player 1 x
  R1=W[P0+2]             # player 1 y
  R2=10
  R3=50
  [SP+0x0c]=R3
  CALL PaintBox 


  P0.L=Variables
  P0.H=Variables
  R0=W[P0+16]
  CALL set_PaintColor

  P0.L=Variables
  P0.H=Variables
  R0=W[P0+4]             # player 2 x
  R1=W[P0+6]             # player 2 y
  R2=10
  R3=50
  [SP+0x0c]=R3
  CALL PaintBox


  P0.L=Variables
  P0.H=Variables
  R0=W[P0+18]
  CALL set_PaintColor

  P0.L=Variables
  P0.H=Variables
  R0=W[P0+8]             # ball x
  R1=W[P0+10]            # ball y
  R2=10
  R3=10
  [SP+0x0c]=R3
  CALL PaintBox

  # output pl1 points
  R0=145
  R1=10
  CALL set_TextPaintPos

  P0.L=Variables
  P0.H=Variables
  R1=W[P0+26]
  R0.L=fmtstring
  R0.H=fmtstring
  CALL vprintf

  # output pl2 points
  R0=175
  R1=10
  CALL set_TextPaintPos

  P0.L=Variables
  P0.H=Variables
  R1=W[P0+28]
  R0.L=fmtstring
  R0.H=fmtstring
  CALL vprintf


  UNLINK
  RTS


StartPainting:
  LINK 0x0
  P1.L=exec_Loading_MDMA
  P1.H=exec_Loading_MDMA
  CALL (P1)
  JUMP.S dummy
dummy:
  UNLINK
  RTS


GetLousyRndNum:
  P0.L=Variables
  P0.H=Variables

  R0=W[P0+30]
  R0.L=R0.L*R0.L
  W[P0+30]=R0
  R1=8
  R0=R0&R1
  RTS
  
.include "endline.inc"
