/*
   Development Toolchain for Rigol Oscilloscopes

   Copyright (C) 2011
   Andreas Schuler <andreas at schulerdev.de>

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License v2 as published by the Free
   Software Foundation.

   This program is distributed in the hope that it will be useful, but WITHOUT
   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
   FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
   more details.

   You should have received a copy of the GNU General Public License along with
   this program; if not, write to the Free Software Foundation, Inc., 59 Temple
   Place, Suite 330, Boston, MA 02111-1307 USA
*/

#include <stdio.h>
#include <stdlib.h>

#include "rigol_com.h"


int main(int argc, char *argv[])
{
    rigol_com rigol;

    printf("Rigol Code Executer v1.0\n\nCopyright 2011 by Andreas Schuler\nLicensed under GPL v2\n\n");

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

