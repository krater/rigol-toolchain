CC := g++

# Stuff we need
INCLUDECFLAGS := #`pkg-config --cflags sdl`
INCLUDELIBFLAGS := -I"." -lelf 
INCLUDEFLAGS := $(INCLUDECFLAGS) $(INCLUDELIBFLAGS)

# Flags in common by all
CPPFLAGS := -Wall -W -Wextra -pedantic -pedantic-errors -Wfloat-equal -Wundef -Wshadow -Winit-self -Winline \
-Wpointer-arith -Wcast-align -Wwrite-strings -Wcast-qual -Wvla\
-Wswitch-enum -Wconversion -Wformat=2 -Wswitch-default -Wstrict-overflow -std=c++0x

# Flags for debugging builds
CDFLAGS := $(CPPFLAGS) -g -O2 -fstack-protector-all -Wstack-protector -Wstrict-overflow=4
# Flags for normal builds
CNFLAGS := $(CPPFLAGS) -O3 -fno-stack-protector

all: default 
default: clean rglupload rglexecute rglinject rglpatchversion rglpoke rglpeek rglserialtest
rglupload:
	@$(CC) $(CDFLAGS) $(INCLUDEFLAGS) src/rglupload.cpp src/serial_com.cpp src/rigol_com.cpp src/code_binary.cpp -o bin/rglupload
rglexecute:
	@$(CC) $(CDFLAGS) $(INCLUDEFLAGS) src/rglexecute.cpp src/serial_com.cpp src/rigol_com.cpp -o bin/rglexecute
rglpoke:
	@$(CC) $(CDFLAGS) $(INCLUDEFLAGS) src/rglpoke.cpp src/serial_com.cpp src/rigol_com.cpp -o bin/rglpoke
rglpeek:
	@$(CC) $(CDFLAGS) $(INCLUDEFLAGS) src/rglpeek.cpp src/serial_com.cpp src/rigol_com.cpp -o bin/rglpeek
rglinject:
	@$(CC) $(CDFLAGS) $(INCLUDEFLAGS) src/rglinject.cpp -o bin/rglinject
rglpatchversion:
	@$(CC) $(CDFLAGS) $(INCLUDEFLAGS) src/rglpatchversion.cpp -o bin/rglpatchversion
rglserialtest:
	@$(CC) $(CDFLAGS) $(INCLUDEFLAGS) src/rglserialtest.cpp src/serial_com.cpp src/rigol_com.cpp -o bin/rglserialtest


install: default
	cp bin/* /usr/bin/
	mkdir -p /opt/rigol/
	cp -rf include /opt/rigol/
	
clean:
	@$(RM) -rf bin/*

