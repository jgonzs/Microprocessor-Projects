//Lab 4: Digital Audio
//Timer-2 Header File
//Joaquin Gonzalez-Salgado
//jgonzalezsalgado@hmc.edu

#ifndef TIM2_H
#define TIM2_H

#include <stdint.h> //Include stdint header

#define TIM2_BASE  (0x40000000) //TIM2 Base Address

// TIM2 register structs here
typedef struct {
    volatile uint32_t CR1;      // Offset 0x00
    volatile uint32_t CR2;      // Offset 0x04
    volatile uint32_t SMCR;     // Offset 0x08
    volatile uint32_t DIER;     // Offset 0x0C
    volatile uint32_t SR;       // Offset 0x10
    volatile uint32_t EGR;      // Offset 0x14
    volatile uint32_t CCMR1;    // Offset 0x18
    volatile uint32_t CCMR2;    // Offset 0x1C
    volatile uint32_t CCER;     // Offset 0x20
    volatile uint32_t CNT;      // Offset 0x24
    volatile uint32_t PSC;      // Offset 0x28
    volatile uint32_t ARR;      // Offset 0x2C
    volatile uint32_t RESERVED; // Offset 0x30 — reserved
    volatile uint32_t CCR1;     // Offset 0x34
    volatile uint32_t CCR2;     // Offset 0x38
    volatile uint32_t CCR3;     // Offset 0x3C
    volatile uint32_t CCR4;     // Offset 0x40
    volatile uint32_t RESERVED2;// Offset 0x44 — reserved
    volatile uint32_t DCR;      // Offset 0x48
    volatile uint32_t DMAR;     // Offset 0x4C
    volatile uint32_t OR1;      // Offset 0x50
    volatile uint32_t RESERVED3;// Offset 0x54 — reserved
    volatile uint32_t RESERVED4;// Offset 0x58 — reserved
    volatile uint32_t RESERVED5;// Offset 0x5C — reserved
    volatile uint32_t OR2;      // Offset 0x60
} TIM_TypeDef;

#define TIM2 ((TIM_TypeDef *) TIM2_BASE)

#endif