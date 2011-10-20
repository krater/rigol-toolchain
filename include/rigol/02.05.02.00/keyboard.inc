##################################################################
#
#  Calling Conventions
#  
# Argument1 : R0
# Argument2 : R1
# Argument3 : R2
# Argument4 : [SP + 0xc]
# ...
# Result    : R0 
#

##################################################################
# char GetKeyFromQueue();
# 
.equ GetKeyFromQueue,		0x000ECF3C


##################################################################
# void AddKeyToQueue(char key);
#  
.equ AddKeyToQueue,		0x000EBFE4 


##################################################################
# bool GetKeyLock();
#  
.equ GetKeyLock,		0x0004CCF6 


##################################################################
# void SetKeyLock(bool keylock);
#  
.equ SetKeyLock,		0x0004CF6C 


##################################################################
# standart keycodes  
#
# KC_P_xxx   Keycode for key pressed
# KC_R_xxx   keycode for key released
# KC_LR_xxx  keycode for left rotate
# KC_RR_xxx  keycode for right rotate
# KC_LP_xxx  keycode for long-press (more than 3 seconds)


.equ KC_RL_KNOB,                         0x3d
.equ KC_RR_KNOB,                         0x3e
.equ KC_R_KNOB,                          0x43

.equ KC_RL_TRIGGER_SCALE,                0x0b
.equ KC_RR_TRIGGER_SCALE,                0x0c
.equ KC_R_TRIGGER_SCALE,                 0x11
.equ KC_RL_TRIGGER_LEVEL,                0x1f
.equ KC_RR_TRIGGER_LEVEL,                0x20
.equ KC_R_TRIGGER_LEVEL,                 0x25
.equ KC_R_TRIGGER_FORCE,                 0x1a
.equ KC_R_TRIGGER_OFF,                   0x23
.equ KC_R_TRIGGER_50PC,                  0x24
.equ KC_R_TRIGGER_MENU,                  0x2e

.equ KC_LR_VERTICAL_SCALE,               0x15
.equ KC_RR_VERTICAL_SCALE,               0x16
.equ KC_R_VERTICAL_SCALE,                0x1b
.equ KC_RL_VERTICAL_POSITION,            0x33
.equ KC_RR_VERTICAL_POSITION,            0x34
.equ KC_R_VERTICAL_POSITION,             0x39

.equ KC_RL_HORIZONTAL_POSITION,          0x29
.equ KC_RR_HORIZONTAL_POSITION,          0x2a
.equ KC_R_HORIZONTAL_POSITION,           0x2f

.equ KC_R_HORIZONTAL_MENU,               0x19

.equ KC_P_BUTTON1,                       0x5b
.equ KC_P_BUTTON2,                       0x5c
.equ KC_P_BUTTON3,                       0x5d
.equ KC_P_BUTTON4,                       0x5e
.equ KC_P_BUTTON5,                       0x5f
.equ KC_R_BUTTON1,                       0x3f
.equ KC_R_BUTTON2,                       0x35
.equ KC_R_BUTTON3,                       0x2b
.equ KC_R_BUTTON4,                       0x21
.equ KC_R_BUTTON5,                       0x17

.equ KC_R_UTILITY,                       0x2d
.equ KC_R_STORAGE,                       0x37
.equ KC_R_CURSOR,                        0x40
.equ KC_R_DISPLAY,                       0x41
.equ KC_R_MEASURE,                       0x4a
.equ KC_R_ACQUIRE,                       0x4b

.equ KC_R_CH1,                           0x36
.equ KC_R_CH2,                           0x2c
.equ KC_R_MATH,                          0x22
.equ KC_R_REF,                           0x18
.equ KC_R_LA,                            0x0e

.equ KC_R_MENU,                          0x49
.equ KC_R_RUNSTOP,                       0x38
.equ KC_R_AUTO,                          0x42




#0x7b longpress button5
#0x7c longpress ref
#0x7d longpress horizontal menu
#0x7f longpress vertical scale
#0x85 longpress button4
#0x86 longpress math
#0x87 longpress off
#0x8f longpress button3
#0x90 longpress ch2
#0x99 longpress button2
#0x9a longpress ch1
#0x9d longpress vertical position
#0xa3 longpress button1
#0xa7 longpress knob
#0xad longpress menu on/off


##################################################################
# system keycodes  
#

#.equ KC_UNKNOWN,                        0xc8  #at the moment unknown function
.equ KC_KEYLOCK,                         0xc9  #keyboard locked, but key pressed/released
#.equ KC_UNKNOWN,                        0xff  #at the moment unknoen
.equ KC_NOKEY,                           0x00  #no key pressed


