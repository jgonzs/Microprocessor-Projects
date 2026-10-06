// encoder_polling.c
// Josh Brake
// jbrake@hmc.edu
// 10/31/22

#include <stdio.h>
#include "main.h"

//Printf function
int _write(int file, char *ptr, int len) {
  int i = 0;
  for (i = 0; i < len; i++) {
    ITM_SendChar((*ptr++));
  }
  return len;
}

int main(void) {
    // Enable encoder channels as inputs
    gpioEnable(GPIO_PORT_A);
    pinMode(ENC_A_PIN, GPIO_INPUT);
    pinMode(ENC_B_PIN, GPIO_INPUT);
    GPIOA->PUPDR |= (0b01 << 2*gpioPinOffset(ENC_A_PIN)); // Set PA6 as pull-up
    GPIOA->PUPDR |= (0b01 << 2*gpioPinOffset(ENC_B_PIN)); // Set PA8 as pull-up

    // Initialize timer
    RCC->APB1ENR1 |= (1 << 0); // TIM2EN
    initTIM(DELAY_TIM);

    int volatile cur_a = digitalRead(ENC_A_PIN);
    int volatile cur_b = digitalRead(ENC_B_PIN);
    int volatile prev_a = cur_a;
    int volatile prev_b = cur_b;
    int32_t volatile enc_count = 0;
    int ms = 0; //ms elapsed in current sample window

    while(1){
        prev_a = cur_a;
        prev_b = cur_b;
        cur_a = digitalRead(ENC_A_PIN);
        cur_b = digitalRead(ENC_B_PIN);
        if (cur_a != prev_a) enc_count += (cur_a != cur_b) ? 1 : -1;
        if (cur_b != prev_b) enc_count += (cur_a == cur_b) ? 1 : -1;
        delay_millis(DELAY_TIM, 1);

        //Print speed once per sample window
        if (++ms >= SAMPLE_WINDOW_MS) {
            //rev/s = counts/CPR/window, with negative being Counterclockwise
            printf("Speed: %.2f rev/s\n", (float)enc_count * 1000 / ((float)ENC_CPR * SAMPLE_WINDOW_MS));
            enc_count = 0; //reset encoder count
            ms = 0;
        }
    }
}
