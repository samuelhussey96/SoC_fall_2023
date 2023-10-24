#include "blinking_led_core.h"

/**********************************************************************
 * BlinkingLedCore
 **********************************************************************/
BlinkingLedCore::BlinkingLedCore(uint32_t core_base_addr) {
   base_addr = core_base_addr;
   wr_data = 0;
}

BlinkingLedCore::~BlinkingLedCore() {
}

void BlinkingLedCore::write(uint32_t data, uint8_t led_select) {
   wr_data = data;

   switch(led_select) {
   	   case 0:
   		   io_write(base_addr, DATA_0_REG, wr_data);
   		   break;
   	   case 1:
   		   io_write(base_addr, DATA_1_REG, wr_data);
   		   break;
   	   case 2:
   		   io_write(base_addr, DATA_2_REG, wr_data);
   		   break;
   	   case 3:
   		   io_write(base_addr, DATA_3_REG, wr_data);
   		   break;
   	   default:
   		   return;
   		   break;
   }

}
