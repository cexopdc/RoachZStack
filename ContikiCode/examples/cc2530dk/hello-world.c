/**
 * \file
 *         Basic hello world example for the IMU. This file was once the hello world file for cc2530dk
 * \editor
 *         Talha Agcayazi <tmagcaya@ncsu.edu>
 */

#include "contiki.h"
#include <time.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h> /* For printf() */
#include "spi_master.h" 
#include "SFE_LSM9DS0.h" 

/*---------------------------------------------------------------------------*/
PROCESS(hello_world_process, "Hello world process");
AUTOSTART_PROCESSES(&hello_world_process);
/*---------------------------------------------------------------------------*/
PROCESS_THREAD(hello_world_process, ev, data)
{
  PROCESS_BEGIN();
  clock_init(); //try declaring the variable. 
  begin(G_SCALE_245DPS, A_SCALE_2G, M_SCALE_2GS, G_ODR_95_BW_125, A_ODR_50, M_ODR_50);

  //P0SEL &= (1 << 6);
  //P0DIR |= (1 << 6);
  //P0    |= (1 << 6);


  while (1){
    printf("\n");
    readGyro();
    printf("gx: %d\n", (int)(calcGyro(gx)*1000.0));
    printf("gy: %d\n", (int)(calcGyro(gy)*1000.0));
    printf("gz: %d\n", (int)(calcGyro(gz)*1000.0));
    printf("\n");
    readAccel();
    printf("ax: %d\n", (int)(1000.0*calcAccel(ax)));
    printf("ay: %d\n", (int)(1000.0*calcAccel(ay)));
    printf("az: %d\n", (int)(1000.0*calcAccel(az)));
    printf("\n");
    readMag();
    printf("mx: %d\n", (int)(1000.0*calcMag(mx)));
    printf("my: %d\n", (int)(1000.0*calcMag(my)));
    printf("mz: %d\n", (int)(1000.0*calcMag(mz)));

    //___________________________________________________________//
    //Some more functions that could come useful. 
    // Taken from an arduino program so need to convert some stuff. 

    // printHeading((mx, my;
    // printOrientation(calcAccel(ax), calcAccel(ay), 
    //                calcAccel(az));
  }
  PROCESS_END();
}
/*---------------------------------------------------------------------------*/
