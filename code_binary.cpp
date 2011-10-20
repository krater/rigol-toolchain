#include "code_binary.h"


code_binary::code_binary()
{
    file=0;
}

code_binary:: ~code_binary()
{
    close_file();
}

int code_binary::open_file(const char* filename)
{
    close_file();

    file=fopen(filename,"rb");
    if(!file)
        return -1;

    return 0;
}

void code_binary::close_file()
{
    if(file)
        fclose(file);
}

int code_binary::getcode(const char* start,const char* end,uint8_t *buffer,int maxlen)
{
    int ostart=findstring(start,true)+1;
    int oend=findstring(end,false);

    if(ostart<0)
	{
        printf("Couldn't find startposition (%s)\n",start);
        return -1;
	}

    if(oend<0)
	{
        printf("Couldn't find endposition (%s)\n",end);
        return -2;
	}
	
    printf("Homebrew code length: %u bytes\n",oend-ostart);

    if((oend-ostart)>maxlen)
	{
		printf("Not enough space free...\n");
        return -3;
	}

    memset(buffer,0,maxlen);
    fseek(file,ostart,SEEK_SET);
    fread(buffer,oend-ostart,1,file);

    return oend-ostart;
}


uint32_t code_binary::findstring(const char* str,bool offsetpos)
{
    char buf[BUFFERSIZE]={0};

    if(!file) return -1;

    uint32_t len=(uint32_t)strlen(str);

    assert(len);
    if(len>=BUFFERSIZE)
    {
        assert(0);
        return -1;
    }

    fseek(file,0,SEEK_SET);

    int pos=0;
    while(!feof(file))
    {
        fread(buf+len,1,BUFFERSIZE-len,file);

        for(uint32_t i=0;i<(BUFFERSIZE-len);i++)
        {
            if(!memcmp(str,buf+i,len))
            {
                if(offsetpos)
                    return pos+i;
                else
                    return pos+i-len;
            }

            *(buf+i)=0;
        }

        memcpy(buf,buf+BUFFERSIZE-len,len);
        pos+=BUFFERSIZE-len;
    }

    return -1;
}

