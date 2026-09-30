//Lab 4: Digital Audio
//GPIO Header File
//Joaquin Gonzalez-Salgado
//jgonzalezsalgado@hmc.edu

#ifndef GPIO_H
#define GPIO_H

#include <stdint.h> 


#define GPIOA_BASE  (0x48000000)  //GPIO Starting address

//GPIO TypeDef Struct
typedef struct {
    volatile uint32_t MODER;   //Offset: 0x00
    volatile uint32_t OTYPER;  //Offset: 0x04
    volatile uint32_t OSPEEDR; //Offset: 0x08
    volatile uint32_t PUPDR;   //Offset: 0x0C
    volatile uint32_t IDR;     //Offset: 0x10
    volatile uint32_t ODR;     //Offset: 0x14
    volatile uint32_t BSRR;    //Offset: 0x18
    volatile uint32_t LCKR;    //Offset: 0x1C
    volatile uint32_t AFRL;    //Offset: 0x20
    volatile uint32_t AFRH;    //Offset: 0x24
    volatile uint32_t BRR;     //Offset: 0x28
    volatile uint32_t ASCR;    //Offset: 0x2C
} GPIO_TypeDef;

//Pointer to the GPIO_TypeDef
#define GPIOA ((GPIO_TypeDef *) GPIOA_BASE)

#endif