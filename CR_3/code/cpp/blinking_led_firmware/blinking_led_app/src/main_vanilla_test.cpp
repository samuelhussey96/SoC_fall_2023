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
#include "blinking_led_core.h"


void blinking_led_check(BlinkingLedCore *led_p, uint32_t interval, uint8_t led_select) {
	led_p->write(interval, led_select);
}

// instantiate leds
BlinkingLedCore led(get_slot_addr(BRIDGE_BASE, S4_USER));

int main() {

	blinking_led_check(&led, 500, 0);
	blinking_led_check(&led, 1000, 1);
	blinking_led_check(&led, 2000, 2);
	blinking_led_check(&led, 4000, 3);

} //main

