//Lab 5: Interrupts
//main.c File
//Joaquin Gonzalez-Salgado
//jgonzalezsalgado@hmc.edu

#include <stdio.h>
#include "main.h"

//Encoder count
volatile int32_t enc_count = 0;

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
    GPIOA->PUPDR |= (0b01 << 2*gpioPinOffset(ENC_A_PIN)); //Set PA6 as pull-up
    GPIOA->PUPDR |= (0b01 << 2*gpioPinOffset(ENC_B_PIN)); //Set PA8 as pull-up

    // Initialize timer
    RCC->APB1ENR1 |= (1 << 0); // TIM2EN
    initTIM(DELAY_TIM);

    // 1. Enable SYSCFG clock domain in RCC
    RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN;
    // 2. Configure EXTICR for the encoder interrupts
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

        int32_t counts = enc_count; //holds last total, this is what gets displayed
        enc_count = 0; //reset encoder count

        //rev/s = counts/CPR/window, with negative being Counterclockwise
        printf("Speed: %.2f rev/s\n", (float)counts * 1000 / ((float)ENC_CPR * SAMPLE_WINDOW_MS));
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

        //Used to compare direction
        int a = (GPIOA->IDR & a_bit) != 0;
        int b = (GPIOA->IDR & b_bit) != 0;

        //Direction
        if (pending & a_bit) enc_count += (a != b) ? 1 : -1;
        if (pending & b_bit) enc_count += (a == b) ? 1 : -1;
    }
}
