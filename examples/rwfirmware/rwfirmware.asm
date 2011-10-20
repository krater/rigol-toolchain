.equ show_info_str,0x3AF80                  #R0=pBuf;R1=progress (do not use LC0,LC1)
.equ fprintf,0xE52A0                        #R0=pbuf;R1=pFormat;R2=Value
.equ FFT_End,0xB7EB8
.equ MATH_End,0xB7D52
.equ get_CmdParam,0xB572A
.equ exec_UART_WRITE,0xC995E                #R0=pBuf;R1=len
.equ strlen,0xE53E0                         #R0=pBuf
.equ get_CmdParam,0xB572A
.equ get1_CmdParam,0xB5598
.equ exec_scmd_0x19c,0xEA364

.equ StartMathHomebrew,0xB7A72 #(Math)
.equ StartFFTHomebrew,0xB7D7A  #(FFT)



.org StartFFTHomebrew-21
.ascii "** Start Homebrew **"
.org StartFFTHomebrew
StartNewHomebrewCode:

  CALL get_CmdParam        

#----------------------------------
# convert address and save

  R0.L = rx_buf_RemoteCmd+1
  R0.H = rx_buf_RemoteCmd+1
  R1 = 8
  CALL hex2int
  [FP-0x4] = R0


# output converted values
  R2 = R0          
  R1.L = format
  R1.H = format
  R0.L = tx_buf_RemoteCmd
  R0.H = tx_buf_RemoteCmd
  CALL fprintf

  R0.L = tx_buf_RemoteCmd
  R0.H = tx_buf_RemoteCmd
  CALL strlen

  R1 = R0
  R0.L = tx_buf_RemoteCmd
  R0.H = tx_buf_RemoteCmd
  CALL exec_UART_WRITE


# read second value
  R0.L = rx_buf_RemoteCmd+10
  R0.H = rx_buf_RemoteCmd+10
  R1 = 2
  CALL hex2int
  [FP-0x8] = R0

#----------------------------------
# check for W(rite) 

  P0.L = rx_buf_RemoteCmd+9
  P0.H = rx_buf_RemoteCmd+9

  R0=B[P0](Z)
  R1='W'
  CC=R0==R1
  IF CC JUMP write

# check for R(ead)

  R1='R'
  CC=R0==R1
  IF CC JUMP read


# check for C(all)

  R1='C'
  CC=R0==R1
  IF CC JUMP callf

  JUMP bla

#----------------------------------
# read x bytes from memory
read:

  R1=[FP-0x8]        #count
  R0=[FP-0x4]        #address
  CALL dumpmem

  JUMP end


#----------------------------------
# write byte to memory
write:

  R1=[FP-0x8]        #value
  R0=[FP-0x4]        #address
  CALL writemem

  JUMP end


#----------------------------------
# call function
callf:

  P0=[FP-0x4]
  CALL (P0)

  JUMP end


#----------------------------------
# convert address and save
bla:

# output converted values
  R2 = [FP-0x8]     
  R1.L = format2
  R1.H = format2
  R0.L = tx_buf_RemoteCmd
  R0.H = tx_buf_RemoteCmd
  CALL fprintf

  R1 = 2
  R0.L = tx_buf_RemoteCmd
  R0.H = tx_buf_RemoteCmd
  CALL exec_UART_WRITE


end: JUMP.L FFT_End


format:
.ascii "%.8x:"
.byte 0
format2:
.ascii "%.2x"
.byte 0

.align 2
#----------------------------------

#----------------------------------
# writemem
#
# R0 = ptr to memory
# R1 = value

writemem:
  P0=R0
  B[P0]=R1
  RTS

#----------------------------------
# dumpmem
#
# R0 = ptr to memory
# R1 = bytes to dump

dumpmem:
  LINK 0x40 #0x18

  [FP-0x4]=R0
  [FP-0xc]=R1
  R1=0
  [FP-0x8]=R1

dumpmem_loop:
  P0=[FP-0x4]               # p0=memory to dump
  R2=B[P0++](Z)
  [FP-0x4]=P0
           
  R1.L = format2
  R1.H = format2
  R0.L = tx_buf_RemoteCmd
  R0.H = tx_buf_RemoteCmd
  CALL fprintf

  R1 = 2
  R0.L = tx_buf_RemoteCmd
  R0.H = tx_buf_RemoteCmd
  CALL exec_UART_WRITE


  R1=[FP-0x8]
  R1+=1
  [FP-0x8]=R1

  R2=[FP-0xc]
  CC=R1<R2
  IF CC JUMP dumpmem_loop


  P0=[FP+0x4];
  UNLINK;
  JUMP (P0);


#----------------------------------
# hex2int
#
# R0 = ptr to hex string
# R1 = length of hex string

hex2int:
  P0=R1
  P1=R0
  R0=0

start:R0<<=4
      R2=B[P1++](Z)
      R1=0x39
      CC=R2<=R1
      IF CC JUMP num
      R1=0xdf
      R2=R2&R1
      R2+=-0x7
num:  R2+=-0x30
      R0=R0+R2

  P0+=-1
  CC=P0<=0
  IF !CC JUMP start
  RTS

#-------------------------------------
.ascii "** End Homebrew **"


.org 0x6efbf0
rx_buf_RemoteCmd: UNLINK
.org 0x6efc30
tx_buf_RemoteCmd: UNLINK
