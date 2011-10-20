#include "rigol_com.h"

rigol_com::rigol_com()
{
    open=0;
}

rigol_com::~rigol_com()
{
}

int rigol_com::open_rigol(const char *device)
{
    if(open)    close_rigol();

    if(serial.open_port(device)<0)
    {
        printf("Can't open port %s\n",device);
        return -1;
    }

    //TODO:check if there is really a rigol scope

    open=1;
    return 0;
}

void rigol_com::close_rigol()
{
    open=0;
    serial.close_port();
}

char* rigol_com::identify()
{
    if(!open) return 0;

    serial.send_line("*IDN?");
    serial.receive_line(line,LINELEN);
    return line;
}

void rigol_com::keylock_disable()
{
    if(!open) return;
    serial.send_line(":KEY:LOCK DISABLE");
}

char* rigol_com::custom_command(const char *cmd,bool get_response)
{
    if(!open) return 0;
    serial.send_line(cmd);

    if(get_response)
    {
        serial.receive_line(line,LINELEN);
        return line;
    }
    else
        return 0;
}



int rigol_com::write_data(uint32_t address,uint8_t *buffer,size_t length)
{
    for(size_t i=0;i<length;i++)
    {
        if(write_byte(address++,*(buffer++)))
            return -1;
    }

    return 0;
}


int rigol_com::read_data(uint32_t address,uint8_t *buffer,size_t length)
{
    //dummy
    address=0;buffer=0;length=0;
    return 0;
}

int rigol_com::write_byte(uint32_t address,uint8_t value)
{
    if(!open) return -1;
    snprintf(line,LINELEN,":FFT:%.8xw%.2x",address,value);
    printf("%s\n",line);
    serial.send_line(line);

    serial.receive_line(line,LINELEN);
    printf("%s",line);

    return 0;
}

void rigol_com::bla()
{
    serial.receive_line(line,LINELEN);
    printf("%s",line);
}


