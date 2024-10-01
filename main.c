#define RCC_BASE 0x40023800
#define GPIOA_BASE 0x40020000
#define GPIOC_BASE 0x40020800

#define RCC_AHB1ENR *(volatile unsigned int *)(RCC_BASE + 0x30)
// #define GPIOA_MODER *(volatile unsigned int *)(GPIOA_BASE + 0x00)
#define GPIOA_MODER 0x40020000
#define GPIOA_BSRR *(volatile unsigned int *)(GPIOA_BASE + 0x18)
#define GPIOC_MODER *(volatile unsigned int *)(GPIOC_BASE + 0x00)
#define GPIOC_IDR *(volatile unsigned int *)(GPIOC_BASE + 0x10)

void delay(volatile int time) {
  while (time--) {
    // simple delay loop
  }
}

int main(void) {
  // Enable clock for GPIOA and GPIOC
  RCC_AHB1ENR |= (1 << 0); // Enable GPIOA clock
  RCC_AHB1ENR |= (1 << 2); // Enable GPIOC clock

  // Set PA5 as output for LD2
  GPIOA_MODER &= ~(0x3 << (5 * 2)); // Clear mode bits for PA5
  GPIOA_MODER |= (0x1 << (5 * 2));  // Set PA5 to output mode (01)

  // Set PC13 as input for the user button
  GPIOC_MODER &= ~(0x3 << (13 * 2)); // Clear mode bits for PC13 (input mode)

  while (1) {
    // Check if the button is pressed (PC13 is low)
    if (!(GPIOC_IDR & (1 << 13))) {
      // Turn off LD2 (reset PA5)
      GPIOA_BSRR |= (1 << (5 + 16)); // Reset PA5 (LED off)
    } else {
      // Turn on LD2 (set PA5)
      GPIOA_BSRR |= (1 << 5); // Set PA5 (LED on)
    }

    delay(100000); // Short delay for button debouncing
  }

  return 0;
}

/*

#define GPIOA_MODER  0x40020000

#define GPIOA_OTYPER  0x40020004

#define GPIOA_OSPEEDR  0x40020008

#define GPIOA_PUPDR  0x4002000C

#define GPIOA_IDR  0x40020010

#define GPIOA_ODR  0x40020014

#define GPIOA_BSRR  0x40020018

#define GPIOA_BSRR  0x40020018

#define GPIOA_LCKR  0x4002001C

#define GPIOA_AFRL  0x40020020

#define GPIOA_AFRH  0x40020024



*/