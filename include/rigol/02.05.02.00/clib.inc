#################################################
#
#  Calling Conventions
#  
# Argument1 : R0
# Argument2 : R1
# Argument3 : R2
# Argument4 : [dsfs]
# Argument4 : [sdfsf]
# ...
# Result    : R0 
#


.equ memset,		0x000E2B2E 
.equ memcpy,		0x000E2B64       
.equ sprintf,		0x000E52A0
.equ strcat,		0x000E52DC       
.equ strchr,		0x000E530C       
.equ strcmp,		0x000E5324       
.equ strcpy,		0x000E5398       
.equ strcspn,		0x000E53AC  
.equ strlen,		0x000E53E0       



.equ strncmp,		0x000E5400       
.equ vprintf,		0x000E51DE

.equ fclose,		0x00692A56       
.equ fread,		0x00692B1C       
.equ fwrite,		0x00692C68       
.equ fseek,		0x00692DB4       
.equ fopen,		0x00692F48       
.equ find_file,		0x00693AFC       

.equ aton,		0x0001D390       

.equ exit,		0x0068172E       


#.equ C4238       strcopy_?

