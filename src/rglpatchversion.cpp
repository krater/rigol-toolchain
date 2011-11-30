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
#include <string.h>
#include <stdlib.h>
#include <stdint.h>

#ifndef null
#define null 0
#endif

uint32_t crc32(unsigned char *data,size_t len);

uint32_t versions[]={0x88848582,0x82848582,0x88828582,0x84828582};

int main(int argc,const char* argv[])
{
    unsigned char header[22];

    printf("RGL Firmware Version Patcher v1.0\n\nCopyright 2011 by Andreas Schuler\nLicensed under GPL v2\n\n");

    if(argc<2)
    {
        printf("Usage:    rglpatchversion file version\n"\
               "Example:  rglpatchversion DS1000EUpdate.RGL 3\n\n"\
               "Known Versions:\n"\
               " 0) 2.05.01.00\n"\
               " 1) 2.05.01.02\n"\
               " 2) 2.05.02.00\n"\
               " 3) 2.05.02.01\n");

        return 0;
    }

    long version=strtol(argv[2],null,10);

    if(version>=((long)(sizeof(versions)/4)))
    {
        printf("Unknown version...\n");
        return -1;
    }

    FILE *f=fopen(argv[1],"r+b");
    if(!f)
    {
        printf("Can't open file: %s\n",argv[1]);
        return -1;
    }

    if(fread(header,1,21,f)!=21)
    {
        printf("Read error\n");
        fclose(f);
        return -1;
    }

    *((uint32_t*)(header+10))=versions[version];
    *((uint32_t*)(header+16))=crc32(header,16);

    for(int i=0;i<21;i++)
        printf("%.2x ",header[i]);

    printf("\n");

    printf("patching file...");
    fseek(f,0,SEEK_SET);
    if(fwrite(header,1,21,f)!=21)
    {
	    printf("write error\n");
	    fclose(f);
	    return -1;
    }

    printf("ok\n");
    return 0;
}


uint32_t crc32(unsigned char *data,size_t len)
{
    uint32_t crc32=0xffffffff;

    size_t i,a;
    for(a=0;a<len;a++)
    {
        for(i=0;i<8;i++)
        {
            if((crc32&0x01)!=(unsigned long)((data[a]&(1<<i))?1:0))
                crc32=(crc32>>1)^0xEDB88320;
            else
                crc32>>=1;
        }
    }

    return crc32^0xffffffff;
}
