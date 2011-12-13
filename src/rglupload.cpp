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
#include "code_binary.h"


int main(int argc, char *argv[])
{
    rigol_com rigol;

    printf("Rigol Code Uploader v1.0\n\nCopyright 2011 by Andreas Schuler\nLicensed under GPL v2\n\n");

    if(argc<5)
    {
        printf("Usage:    rglupload port srcfile startaddress maxlength\n"\
               "Example:  rglupload /dev/ttyS0 homebrew 0xa00000 0x1000\n\n");

        return -1;
    }

    if(rigol.open_rigol(argv[1])<0)
        return -1;

    rigol.custom_command("",0);

    printf("Scope identification:\n%s\n",rigol.identify());


    uint32_t start=(uint32_t)strtol(argv[3],0,16);
    uint32_t length=(uint32_t)strtol(argv[4],0,16);

    uint8_t *buf=(uint8_t*)malloc(length);

    code_binary codefile;

    if(!codefile.open_file(argv[2]))
    {
        int clen=codefile.getcode("** Start Homebrew **","** End Homebrew **",buf,length);

        if(clen>0)
            rigol.write_data(start,buf,clen);
    }
    else
        printf("Can't open file %s\n",argv[2]);

    /*uint8_t buf[20]={0,1,2,3,4,5,6,7,8,9,0x12,0x23,0x34,0x45,0x56};

    rigol.write_data(start,buf,20);

    rigol.custom_command(":FFT:00A00000r20",1);
    for(int i=0;i<0x20;i++)
    {
        rigol.bla();
    }*/

    rigol.keylock_disable();
    rigol.close_rigol();


}

