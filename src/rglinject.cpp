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
#include <assert.h>

#ifndef null
#define null 0
#endif

int findstring(FILE *f,const char *string,bool behind=true);


int main(int argc,const char* argv[])
{
	int ret=-1;
	FILE *src=0,*dst=0;
	long int dst_start,dst_end;
	long src_start,src_end;
	char *code=0;

	printf("RGL Firmware Homebrew Injector v1.0\n\nCopyright 2011 by Andreas Schuler\nLicensed under GPL v2\n\n");

	if(argc<4)
	{
        printf("Usage:    rglinject dstfile startaddress endaddress srcfile\n"\
               "Example:  rglinject DS1000EUpdate.RGL 0xB7D7A 0xB7EB8 homebrew\n\n");

		return 0;
	}

	dst_start=strtol(argv[2],null,16);
	dst_end=strtol(argv[3],null,16);

	src=fopen(argv[4],"rb");
	if(!src)
	{
        printf("Can't open source file: %s\n",argv[4]);
		goto end;
	}

	dst=fopen(argv[1],"r+b");
	if(!dst)
	{
		printf("Can't open destination file: %s\n",argv[1]);
		goto end;
	}


	src_start=findstring(src,"** Start Homebrew **",true)+1;
	src_end=findstring(src,"** End Homebrew **",false);

	if(src_start<0)
	{
		printf("Couldn't find startposition\n");
		goto end;		
	}

	if(src_end<0)
	{
		printf("Couldn't find endposition\n");
		goto end;
	}
	
    printf("Homebrew code length: %u bytes\n",(unsigned int)(src_end-src_start));
    printf("Space for code:       %u bytes\n",(unsigned int)(dst_end-dst_start));
	
	if((src_end-src_start)>(dst_end-dst_start))
	{
		printf("Not enough space free...\n");
		goto end;
	}
	else
        printf("%u bytes free\n\n",(unsigned int)((dst_end-dst_start)-(src_end-src_start)));

	code=(char*)calloc(dst_end-dst_start,1);
	
	fseek(src,src_start,SEEK_SET);
	fread(code,src_end-src_start,1,src);

	fseek(dst,dst_start,SEEK_SET);
	fwrite(code,dst_end-dst_start,1,dst);

	printf("Done.\n");
	ret=0;

end:
	if(code) free(code);
	if(src) fclose(src);
	if(dst) fclose(dst);

	return ret;
}



int findstring(FILE *f,const char *string,bool behind)
{
	char buf[500]={0};
    size_t len=strlen(string);

	assert(len);
	assert(f);
	if(len>=500)
	{
		assert(null);
		return -1;
	}

	fseek(f,0,SEEK_SET);

	int pos=0;
	while(!feof(f))
	{
		fread(buf+len,1,500-len,f);

        for(unsigned int i=0;i<(500-len);i++)
		{
			if(!memcmp(string,buf+i,len))
			{
				if(behind)
					return pos+i;
				else
                    return pos+i-(int)len;
			}

			*(buf+i)=0;
		}

        memcpy(buf,buf+500-(int)len,len);
        pos+=500-(int)len;
	}

	return -1;
}





