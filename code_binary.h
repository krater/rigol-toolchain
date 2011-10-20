#ifndef CODE_BINARY_H
#define CODE_BINARY_H

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

#define BUFFERSIZE 1024

class code_binary
{
public:
    code_binary();
    ~code_binary();

    int open_file(const char* filename);
    void close_file();

    int getcode(const char* start,const char* end,uint8_t *buffer,int maxlen);
    uint32_t findstring(const char* str,bool offsetpos);

private:
    FILE *file;
};

#endif // CODE_BINARY_H
