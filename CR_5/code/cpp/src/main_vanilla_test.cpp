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
#include "i2c_core.h"

static const uint8_t sseg_pattern[2] = {0b0011100, 0b0100011}; // top, bottom

uint32_t dec2bcd(uint32_t dec) {
    uint32_t result = 0;
    int shift = 0;

    while (dec)
    {
        result +=  (dec % 10) << shift;
        dec = dec / 10;
        shift += 4;
    }
    return result;
}

void adt7420_check(I2cCore *adt7420_p, SsegCore *sseg_p) {
   const uint8_t DEV_ADDR = 0x4b;
   uint8_t wbytes[2], bytes[2];
   //int ack;
   uint16_t tmp;
   float tmpC;
   float tempF;
   uint32_t temp_f;
   uint32_t temp_bcd;
   uint8_t dig0;
   uint8_t dig1;
   uint8_t dig2;
   uint8_t dig3;

   wbytes[0] = 0x00;
   adt7420_p->write_transaction(DEV_ADDR, wbytes, 1, 1);
   adt7420_p->read_transaction(DEV_ADDR, bytes, 2, 0);

   // conversion
   tmp = (uint16_t) bytes[0];
   tmp = (tmp << 8) + (uint16_t) bytes[1];
   if (tmp & 0x8000) {
      tmp = tmp >> 3;
      tmpC = (float) ((int) tmp - 8192) / 16;
   } else {
      tmp = tmp >> 3;
      tmpC = (float) tmp / 16;
   }

   tempF = (tmpC * 1.8) + 32;
   tempF *= 100;
   temp_f = (uint32_t) tempF;
   temp_bcd = dec2bcd(temp_f);

   dig0 = (uint8_t) ((temp_bcd & 0x0000000f) >> 0);
   dig1 = (uint8_t) ((temp_bcd & 0x000000f0) >> 4);
   dig2 = (uint8_t) ((temp_bcd & 0x00000f00) >> 8);
   dig3 = (uint8_t) ((temp_bcd & 0x0000f000) >> 12);

   uart.disp("temperature (F): ");
   uart.disp((int)temp_f);
   uart.disp("\n\r");
   uart.disp((int)temp_bcd);
   uart.disp("\n\r");
   uart.disp((int)dig3);
   uart.disp((int)dig2);
   uart.disp((int)dig1);
   uart.disp((int)dig0);
   uart.disp("\n\r");



   for (int i = 0; i < 8; i++) {
	   sseg_p->write_1ptn(0xff, i);
   }
   sseg_p->set_dp(0x08);

   sseg_p->write_1ptn(sseg_p->h2s(15), 0);
   sseg_p->write_1ptn(sseg_p->h2s(dig0), 1);

   sseg_p->write_1ptn(sseg_p->h2s(dig1), 2);
   sseg_p->write_1ptn(sseg_p->h2s(dig2), 3);
   sseg_p->write_1ptn(sseg_p->h2s(dig3), 4);

   sleep_ms(300);
}

// instantiate spi and leds
GpoCore led(get_slot_addr(BRIDGE_BASE, S2_LED));
SsegCore sseg(get_slot_addr(BRIDGE_BASE, S8_SSEG));
I2cCore adt7420(get_slot_addr(BRIDGE_BASE, S10_I2C));

int main() {
	while (true) {
		adt7420_check(&adt7420, &sseg);
	}

} //main

