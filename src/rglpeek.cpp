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

    printf("Rigol Peek v1.0\n\nCopyright 2011 by Andreas Schuler\nLicensed under GPL v2\n\n");

    if(argc<4)
    {
        printf("Usage:    rglpoke port address bytecount\n"\
               "Example:  rglpoke /dev/ttyS0 0xa00000 0x42\n\n");

        return -1;
    }

    if(rigol.open_rigol(argv[1])<0)
        return -1;

    rigol.custom_command("",0);

    printf("Scope identification:\n%s\n",rigol.identify());


    uint32_t addr=(uint32_t)strtol(argv[2],0,16);
    uint8_t length=(uint8_t)strtol(argv[3],0,16);

    uint8_t *buffer=(uint8_t*)malloc(length);

    rigol.read_data(addr,buffer,length);

    for(int y=0;y<length;y++)
    {
        printf("%.2x ",buffer[y]);

        if((y%16)==15)
            printf("\n");
    }

    printf("\n");
    rigol.keylock_disable();
    rigol.close_rigol();

}

