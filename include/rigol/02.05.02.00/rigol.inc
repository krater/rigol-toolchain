##################################################################
#
#  Calling Conventions
#  
# Argument1 : R0
# Argument2 : R1
# Argument3 : R2
# Argument4 : [SP + 0xc]
# Argument5 : [sdfsf]
# ...
# Result    : R0 
#

##################################################################
# unsigned long calc_crc32(unsigned char *buf,int length);
# 
.equ calc_crc32,		0x0001CBDC  


##################################################################
# bool is_HW_xx();
.equ is_HW_58,			0x0001CC50       
.equ is_HW_57,			0x0001CC90       
.equ is_HW_07,			0x0001CCD0       
.equ is_HW_06,			0x0001CD10       
.equ is_HW_05,			0x0001CD50       
.equ is_HW_04,			0x0001CD90       
.equ is_HW_03,			0x0001CDD0       


##################################################################
# void MessageBox(char *string,int progress);
# 
.equ MessageBox,		0x0003AF80


##################################################################
# void PaintProgressBar(int progress);
#  
.equ PaintProgressBar,		0x000DA5E6 


##################################################################
# void set_CharPaintingMode(bool inverted);
# 
# 0=normal
# 1=inverted
.equ set_CharPaintingMode,	0x000D4702 


##################################################################
# void set_TextPaintPos(int x,int y);
#       
.equ set_TextPaintPos,		0x000D4718   


##################################################################
# void PaintBox(int x,int y);
#     
.equ PaintBox,			0x000D522C


##################################################################
# void PaintBoxWithBorder(int x,int y,int width,int height);
#  
.equ PaintBoxWithBorder,	0x000AE164 
 
 
.equ PaintGraphic,		0x000AD4E2 



.equ write_EEPROM,		0x0004E07E       
.equ set_UART_Baud,		0x000C9632       
.equ exec_UART_WRITE,		0x000C995E 	#R0=pBuf;R1=len
.equ get_CmdParam,		0x000B572A
.equ get1_CmdParam,		0x000B5598
.equ exec_scmd_0x19c,		0x000EA364
.equ vprintf_XY_LCD,		0x000DA54E       
.equ set1_Model_params,		0x0001D3A8       
.equ exec_write_ModelSerialN,	0x0001D5AC       
.equ wr_EEPROM_HardParams,	0x0001E198       
.equ set_speed_Freq,		0x0001CEA0       
.equ Set_KeyLock,		0x0004CF6C
.equ set_PaintColor,            0x000D4A68
.equ exec_Loading_MDMA,		0xFFA0EE8C

# buffers
.equ rx_buf_RemoteCmd,		0x006EFBF0
.equ tx_buf_RemoteCmd,		0x006EFC30
