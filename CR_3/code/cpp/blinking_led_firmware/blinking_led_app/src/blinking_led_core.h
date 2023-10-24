#ifndef _BLINKING_LED_H_INCLUDED
#define _BLINKING_LED_H_INCLUDED

#include "chu_init.h"

class BlinkingLedCore {
public:
   /**
    * register map
    *
    */
   enum {
      DATA_0_REG = 0, /**< input data registers */
	  DATA_1_REG = 1,
	  DATA_2_REG = 2,
	  DATA_3_REG = 3
   };
   /**
    * constructor.
    *
    */
   BlinkingLedCore(uint32_t core_base_addr);
   ~BlinkingLedCore();                  // not used

   /**
    * write a 32-bit word
    * @param data 32-bit data
    *
    */
   void write(uint32_t data, uint8_t led_select);


private:
   uint32_t base_addr;
   uint32_t wr_data;      // same as GPO core data reg
};

#endif  // _BLINKING_LED_H_INCLUDED
