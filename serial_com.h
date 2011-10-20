#ifndef SERIAL_COM_H
#define SERIAL_COM_H

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <termios.h>
#include <stdio.h>
#include <memory.h>
#include <unistd.h>

class serial_com
{
public:
    serial_com();
    ~serial_com();

    int open_port(const char *device);
    void close_port();

    int send_line(const char *line);
    size_t receive_line(char *buf,size_t maxlen);

private:

    int fd;

};

#endif // SERIAL_COM_H
