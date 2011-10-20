#include "serial_com.h"

serial_com::serial_com()
{
    fd=0;
}

serial_com::~serial_com()
{
    close_port();
}

int serial_com::open_port(const char *device)
{
    close_port();

    struct termios oldtio,newtio;

    fd = open(device,O_RDWR|O_NOCTTY);
    if(fd<0)
        return -1;

    tcgetattr(fd,&oldtio);
    bzero(&newtio,sizeof(newtio));

    newtio.c_cflag = B38400|CS8|CLOCAL|CREAD;
    newtio.c_iflag = IGNPAR;
    newtio.c_oflag = 0;
    newtio.c_lflag = ICANON;

    newtio.c_cc[VTIME]    = 10;     // inter-character timer =5
    newtio.c_cc[VMIN]     = 1;     // blocking read until 1 character arrives

    newtio.c_cc[VINTR]    = 0;     // Ctrl-c
    newtio.c_cc[VQUIT]    = 0;
    newtio.c_cc[VERASE]   = 0;     // del
    newtio.c_cc[VKILL]    = 0;     // @
    newtio.c_cc[VEOF]     = 4;     // Ctrl-d
    newtio.c_cc[VSWTC]    = 0;     // '\0'
    newtio.c_cc[VSTART]   = 0;     // Ctrl-q
    newtio.c_cc[VSTOP]    = 0;     // Ctrl-s
    newtio.c_cc[VSUSP]    = 0;     // Ctrl-z
    newtio.c_cc[VEOL]     = 0x0a;
    newtio.c_cc[VREPRINT] = 0;     // Ctrl-r
    newtio.c_cc[VDISCARD] = 0;     // Ctrl-u
    newtio.c_cc[VWERASE]  = 0;     // Ctrl-w
    newtio.c_cc[VLNEXT]   = 0;     // Ctrl-v
    newtio.c_cc[VEOL2]    = 0x0a;  // '\0'

    tcflush(fd, TCIFLUSH);
    tcsetattr(fd,TCSANOW,&newtio);

    return 0;
}

void serial_com::close_port()
{
    if(fd)  close(fd);
}

int serial_com::send_line(const char *line)
{
    size_t len=strlen(line);
    size_t res=write(fd,line,len);
    if(res<len)
        return -1;

    if(write(fd,"\x0a",1)!=1)
        return -1;

    return 0;
}

size_t serial_com::receive_line(char *buf,size_t maxlen)
{
    size_t res=read(fd,buf,maxlen);
    if(res>maxlen)
        res=maxlen;

    buf[res]=0;
    return res;
}
