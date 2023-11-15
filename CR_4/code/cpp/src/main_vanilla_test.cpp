/*****************************************************************//**
 * @file main_vanilla_test.cpp
 *
 * @brief Basic test of 4 basic i/o cores
 *
 * @author p chu
 * @version v1.0: initial release
 *********************************************************************/

//#define _DEBUG
#include "chu_init.h"
#include "gpio_cores.h"
#include "sseg_core.h"
#include "spi_core.h"

static const uint8_t sseg_pattern[2] = {0b0011100, 0b0100011}; // top, bottom

void gsensor_check(SpiCore *spi_p, SsegCore *sseg_p) {
   const uint8_t RD_CMD = 0x0b;
   const uint8_t PART_ID_REG = 0x02;
   const uint8_t DATA_REG = 0x08;
   const float raw_max = 127.0 / 2.0;  //128 max 8-bit reading for +/-2g

   int8_t xraw, yraw, zraw;
   float x, y, z;
   int id;

   spi_p->set_freq(400000);
   spi_p->set_mode(0, 0);
   // check part id
   spi_p->assert_ss(0);    // activate
   spi_p->transfer(RD_CMD);  // for read operation
   spi_p->transfer(PART_ID_REG);  // part id address
   id = (int) spi_p->transfer(0x00);
   spi_p->deassert_ss(0);

   spi_p->assert_ss(0);    // activate
   spi_p->transfer(RD_CMD);  // for read operation
   spi_p->transfer(DATA_REG);  //
   xraw = spi_p->transfer(0x00);
   yraw = spi_p->transfer(0x00);
   zraw = spi_p->transfer(0x00);
   spi_p->deassert_ss(0);
   x = (float) xraw / raw_max;
   y = (float) yraw / raw_max;
   z = (float) zraw / raw_max;
   //uart.disp("x/y/z axis g values: ");
   uart.disp(x, 3);
   uart.disp(" / ");
   uart.disp(y, 3);
   uart.disp(" / ");
   uart.disp(z, 3);
   uart.disp("\n\r");

   // custom sseg output logic
   for (int i = 0; i < 8; i++) {
	   sseg_p->write_1ptn(0xff, i);
   }
   sseg_p->set_dp(0x00);
   //sseg_p->write_1ptn(0b0111111, 0);
   //sseg_p->write_1ptn(0b0111111, 1);

   // x
   if(x > 0.2) {
	   sseg_p->write_1ptn(sseg_pattern[1], 0);
	   sseg_p->write_1ptn(sseg_pattern[1], 1);
   }
   else if (x < -0.2) {
	   sseg_p->write_1ptn(sseg_pattern[0], 0);
	   sseg_p->write_1ptn(sseg_pattern[0], 1);
   }

   // y
   if(y > 0.2) {
   	   sseg_p->write_1ptn((sseg_pattern[0] & sseg_pattern[1]), 1);
      }
   else if (y < -0.2) {
	   sseg_p->write_1ptn((sseg_pattern[0] & sseg_pattern[1]), 0);
   }


   sleep_ms(100);

}
// instantiate spi and leds
SsegCore sseg(get_slot_addr(BRIDGE_BASE, S8_SSEG));
SpiCore spi(get_slot_addr(BRIDGE_BASE, S9_SPI));

int main() {
	while (true) {
		gsensor_check(&spi, &sseg);
	}

} //main

