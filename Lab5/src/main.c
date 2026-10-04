// main.c
// Josh Brake
// jbrake@hmc.edu
// 10/31/22
//
// Modified for Lab 5 to measure motor speed with a quadrature encoder.

#include <stdio.h>
#include "main.h"

// Encoder count, updated by the ISR and read/cleared by main
volatile int32_t enc_count = 0;

// Function used by printf to send characters to the laptop
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

    // 1. Enable SYSCFG clock domain in RCC
    RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN;
    // 2. Configure EXTICR for the encoder interrupts (port A)
    SYSCFG->EXTICR[1] &= ~SYSCFG_EXTICR2_EXTI6;
    SYSCFG->EXTICR[2] &= ~SYSCFG_EXTICR3_EXTI8;

    // Enable interrupts globally
    __enable_irq();

    // Configure interrupt for both edges of both encoder pins
    uint32_t enc_mask = (1 << gpioPinOffset(ENC_A_PIN)) | (1 << gpioPinOffset(ENC_B_PIN));
    // 1. Configure mask bits
    EXTI->IMR1 |= enc_mask;
    // 2. Enable rising edge trigger
    EXTI->RTSR1 |= enc_mask;
    // 3. Enable falling edge trigger
    EXTI->FTSR1 |= enc_mask;
    // 4. Turn on EXTI interrupt in NVIC_ISER
    NVIC->ISER[0] |= (1 << EXTI9_5_IRQn);

    while(1){
        delay_millis(DELAY_TIM, SAMPLE_WINDOW_MS);

        // Grab and reset the count without the ISR changing it in between
        __disable_irq();
        int32_t counts = enc_count;
        enc_count = 0;
        __enable_irq();

        // rev/s = counts / CPR / window, printed with 4 decimals (x10000)
        int32_t speed = (counts * 10000 * (1000 / SAMPLE_WINDOW_MS)) / ENC_CPR;
        int32_t mag = (speed < 0) ? -speed : speed;
        int32_t frac = mag % 10000;
        // Print each decimal digit separately (SES printf has no %04ld support)
        printf("Speed: %ld.%ld%ld%ld%ld rev/s  Direction: %s\n",
               (long)(mag / 10000), (long)(frac / 1000), (long)((frac / 100) % 10),
               (long)((frac / 10) % 10), (long)(frac % 10),
               (speed > 0) ? "forward" : (speed < 0) ? "reverse" : "stopped");
    }
}

void EXTI9_5_IRQHandler(void){
    uint32_t a_bit = (1 << gpioPinOffset(ENC_A_PIN));
    uint32_t b_bit = (1 << gpioPinOffset(ENC_B_PIN));
    uint32_t pending = EXTI->PR1 & (a_bit | b_bit);

    // Check that an encoder pin was what triggered our interrupt
    if (pending){
        // If so, clear the interrupt (NB: Write 1 to reset.)
        EXTI->PR1 = pending;

        // Read both channels directly (faster than digitalRead)
        int a = (GPIOA->IDR & a_bit) != 0;
        int b = (GPIOA->IDR & b_bit) != 0;

        // Direction: on an A edge, A != B is forward; on a B edge, A == B is forward
        if (pending & a_bit) enc_count += (a != b) ? 1 : -1;
        if (pending & b_bit) enc_count += (a == b) ? 1 : -1;
    }
}
