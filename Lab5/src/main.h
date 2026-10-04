// main.h
// Josh Brake
// jbrake@hmc.edu
// 10/31/22

#ifndef MAIN_H
#define MAIN_H

#include "STM32L432KC.h"
#include <stm32l432xx.h>

///////////////////////////////////////////////////////////////////////////////
// Custom defines
///////////////////////////////////////////////////////////////////////////////

#define ENC_A_PIN PA6
#define ENC_B_PIN PA8
#define DELAY_TIM TIM2

#define ENC_PPR 408                 // pulses per output shaft rev (one channel)
#define ENC_CPR (4 * ENC_PPR)       // counts per rev using both edges of A and B
#define SAMPLE_WINDOW_MS 500        // 2 Hz update rate

#endif // MAIN_H
