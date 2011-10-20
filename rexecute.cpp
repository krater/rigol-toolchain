#include <stdio.h>
#include <stdlib.h>

#include "rigol_com.h"


int main(int argc, char *argv[])
{
    rigol_com rigol;

    printf("Rigol Code Executer\n\nCopyright 2011 by Andreas Schuler\nLicensed under GPL v2\n\n");

    if(argc<3)
    {
        printf("Usage:    rexecute port address to call\n"\
               "Example:  rexecute /dev/tty0 0xa00000\n\n");

        return -1;
    }

    if(rigol.open_rigol(argv[1])<0)
        return -1;

    printf("Scope identification:\n%s\n",rigol.identify());

    char line[30];
    snprintf(line,30,":FFT:%.8xc00",(uint32_t)strtol(argv[2],0,16));

    printf("%s\n",line);
    rigol.custom_command(line,0);
    rigol.close_rigol();


}

