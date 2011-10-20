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
