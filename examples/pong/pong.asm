.include "rigol.inc"
.include "clib.inc"
.include "keyboard.inc"

.include "upload_startup.inc"

JUMP RealStart

# text must be align 4, but actually we can't use align :(
# so we put the text at start of the code

fmtstring:
.asciz "%i"

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

  .word 1#4                # 22  ball dx
  .word 1#4                # 24  ball dy

  .word 0                # 26  points pl1
  .word 0                # 28  points pl2

  .word 0xb963           # 30  random seed

  .word 0


random:
  .long 123456789
  .long 362436069
  .long 521288629
  .long 88675123

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


  ### operate ball x movin'

ballx:
  R2=W[P0+8](x)           # Ball x
  R3=W[P0+22](x)          # Ball dx
  R3=R2+R3	          # now R3 is the new x value


#  W[P0+30]=R3 #debug
  
  ### check ball movin' direction
  R0=0
  R1=W[P0+22](x)          # Ball dx
  CC=R0<R1                # Ball movin' right ?
  IF CC JUMP movright

movleft:
  R0=0
  CC=R0<R3                # Ball at left end ?
  IF !CC JUMP pl2point

  R0=40(x)
  CC=R3<R0               # Ball is right of player1
  IF !CC JUMP bally      # ignore...

  R0=30(x)
  CC=R0<R3               # Ball is left of player1
  IF CC JUMP pl1chkhit   # check if player 1 hit the ball 

  JUMP bally


movright:
  R0=(320-10)
  CC=R0<=R3               # Ball at right end ?
  IF CC JUMP pl1point

  R0=(320-40-10)(x)
  CC=R3<R0              # Ball is left of player2
  IF CC JUMP bally      # ignore...

  R0=(320-30-10)(x)
  CC=R0<R3               # Ball is right of player1
  IF !CC JUMP pl2chkhit  # check if player 1 hit the ball


  ### operate ball y movin'

bally:
  R2=W[P0+10](x)          # Ball y
  R3=W[P0+24](x)          # Ball dy
  R3=R2+R3                # now R3 is the new y value

  R0=(234-10)
  CC=R0<=R3
  IF CC JUMP goup
  R0=0
  CC=R0<R3
  IF !CC JUMP godown


ballmove:
  # move x
  R0=W[P0+8](x)           # Ball x
  R1=W[P0+22](x)          # Ball dx
  R0=R0+R1
  W[P0+8]=R0              # Ball x

  # move y
  R0=W[P0+10](x)          # Ball y
  R1=W[P0+24](x)          # Ball dy
  R0=R0+R1
  W[P0+10]=R0             # Ball y


noballmove:
  UNLINK
  RTS


pl1chkhit:
  R0=W[P0+10](x)          # Ball y
  #R1=W[P0+24](x)          # Ball dy
  #R0=R0+R1

  R2=W[P0+2](x)           # Player 1 y
 
  R0+=10                  # compensate 10 pixel of ball thicknes 
  CC=R0<R2
  IF CC JUMP bally        # Ball is over Player
  R0+=-10

  R2+=50
  CC=R2<R0
  IF CC JUMP bally        # Ball is under Player

pl1hit:
  CALL GetLousyRndNum
  W[P0+22]=R0
  JUMP bally


pl2chkhit:
  R0=W[P0+10](x)          # Ball y
  #R1=W[P0+24](x)          # Ball dy
  #R0=R0+R1

  R2=W[P0+6](x)           # Player 1 y

  R0+=10                  # compensate 10 pixel of ball thicknes
  CC=R0<R2
  IF CC JUMP bally        # Ball is over Player
  R0+=-10

  R2+=50
  CC=R2<R0
  IF CC JUMP bally        # Ball is under Player

pl2hit:
  R0=-3       #-4
  W[P0+22]=R0
  JUMP bally


goup:
  R0=-3        #-4
  W[P0+24]=R0
  JUMP ballmove

godown:
  R0=3          #4
  W[P0+24]=R0
  JUMP ballmove

pl1point:
  R0=W[P0+26]
  R0+=1
  W[P0+26]=R0
  CALL StartPL2
  JUMP noballmove

pl2point:
  R0=W[P0+28]
  R0+=1
  W[P0+28]=R0
  CALL StartPL1
  JUMP noballmove

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

  CALL StartPL1
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
  LINK 0x0

  P0.L=Variables
  P0.H=Variables

  R0=3#4
  W[P0+22]=R0     # ball dx
  W[P0+24]=R0     # ball dy

  R0=40
  W[P0+8]=R0      # ball x
  R0=70
  W[P0+10]=R0     # ball y

  UNLINK
  RTS


StartPL2:
  LINK 0x0

  P0.L=Variables
  P0.H=Variables

  R0=-3#-4
  W[P0+22]=R0     # ball dx
  R0=3#4
  W[P0+24]=R0     # ball dy

  R0=320-40-10
  W[P0+8]=R0      # ball x
  R0=234-70-10
  W[P0+10]=R0     # ball y

  UNLINK
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

  R1=W[P0+26](x)  #pl1 points
  #R1=W[P0+8](x)   #ball x
  #R1=W[P0+22](x)   #ball dx

  R0.L=fmtstring
  R0.H=fmtstring
  CALL vprintf

  # output pl2 points
  R0=175
  R1=10
  CALL set_TextPaintPos

  P0.L=Variables
  P0.H=Variables

  R1=W[P0+28](x)  #pl2 points
  #R1=W[P0+10](x)  #ball y
  #R1=W[P0+24](x)   #ball dy

  R0.L=fmtstring
  R0.H=fmtstring
  CALL vprintf


  # output debug
  #R0=175
  #R1=20
  #CALL set_TextPaintPos

  #P0.L=Variables
  #P0.H=Variables

  #R1=W[P0+30](x)  #pl2 points
  #R1=W[P0+10](x)  #ball y
  #R1=W[P0+24](x)   #ball dy

  #R0.L=fmtstring
  #R0.H=fmtstring
  #CALL vprintf




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
  LINK 0x0
  
  CALL GetRandomNum

  R1=7
  R0=R0&R1

  P0.L=Variables
  P0.H=Variables
  W[P0+30]=R0

  R1=0
  CC=R0==R1
  IF CC JUMP xxx
  UNLINK
  RTS

xxx:
  R0=4
  UNLINK
  RTS


GetRandomNum:
  [--SP]=P0

  P0.L=random
  P0.H=random

  #t=x^(x<<11)
  R0=[P0]
  R1=R0<<11
  R1=R0^R1          #R1=t

  #x=y
  R0=[P0+4]
  [P0]=R0           

  #y=z
  R0=[P0+8]
  [P0+4]=R0

  #z=w
  R0=[P0+12]
  [P0+8]=R0         #R0=w

  #w^=(w>>19)
  R2=R0>>19
  R2=R2^R0
  R2=R2^R1
  R1>>=8
  R2=R2^R1
  [P0+12]=R2

  R0=R2
  R0+=1

  P0=[SP++]
  RTS

  
.include "endline.inc"
