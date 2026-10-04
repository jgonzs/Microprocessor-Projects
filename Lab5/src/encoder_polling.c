// encoder_polling.c
// Josh Brake
// jbrake@hmc.edu
// 10/31/22

/*
  This program polls the motor encoder instead of using interrupts. It has a
  delay within the main loop to simulate the problems with polling for
  catching events. Build this instead of main.c, not alongside it.
*/

#include "main.h"

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

    while(1){
        prev_a = cur_a;
        prev_b = cur_b;
        cur_a = digitalRead(ENC_A_PIN);
        cur_b = digitalRead(ENC_B_PIN);
        if (cur_a != prev_a) enc_count += (cur_a != cur_b) ? 1 : -1;
        if (cur_b != prev_b) enc_count += (cur_a == cur_b) ? 1 : -1;
        delay_millis(DELAY_TIM, 1);
    }
}
