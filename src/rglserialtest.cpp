/*
   This program is part of the development Toolchain for Rigol Oscilloscopes

   Andreas Schuler <andreas at schulerdev.de>
   Matthew Ellis <matthewellis1995 at gmail.com>

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
#include <stdlib.h>

#include "rigol_com.h"



int main(int argc, char *argv[])
{
    rigol_com rigol;

    printf("Rigol Serial Conection Test v1.0\n\nCopyright 2012 by\nAndreas Schuler and\nMatthew Ellis\nLicensed under GPL v2\n\n");

    if(argc<2)
       {
        printf("Usage:    rglserialtest port\n");
	printf("Example:  rglserialtest /dev/ttyUSB0\n\n");
	return -1;
        }

	printf("Opening port \n");
	if(rigol.open_rigol(argv[1])<0)
		return -1;
		printf("Port open \n\n");
	//rigol.custom_command("",0);

	printf("Scope identification:\n%s\n",rigol.identify());
	rigol.keylock_disable();
	printf("Keypad unlocked\n");
        printf("Closing connection... bye bye :)\n\n");
	rigol.close_rigol();


}
  
