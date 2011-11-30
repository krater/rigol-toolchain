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

#ifndef RIGOL_COM_H
#define RIGOL_COM_H

#include <stdint.h>
#include "serial_com.h"

#define LINELEN 1024

class rigol_com
{
public:
    rigol_com();
    ~rigol_com();

    int open_rigol(const char *device);
    void close_rigol();

    // normal access
    char* identify();
    void keylock_disable();

    char* custom_command(const char *cmd,bool get_response);

    // memory access
    int write_data(uint32_t address,uint8_t *buffer,size_t length);    
    int read_data(uint32_t address,uint8_t *buffer,size_t length);




    void bla();
private:
    int write_byte(uint32_t address,uint8_t value);

    serial_com serial;
    char line[LINELEN];
    bool open;

};

#endif // RIGOL_COM_H
