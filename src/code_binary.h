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
