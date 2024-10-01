/* Linker script for STM32F446RE */
MEMORY
{
  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 512K
  RAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 128K
}

SECTIONS
{
  .text :
  {
    KEEP(*(.isr_vector)) /* Keep interrupt vectors */
    *(.text*)            /* Program code */
    *(.rodata*)          /* Read-only data */
  } > FLASH

  .data : AT (ADDR(.text) + SIZEOF(.text))
  {
    *(.data*)  /* Initialized data */
  } > RAM

  .bss :
  {
    *(.bss*)  /* Zero-initialized data */
  } > RAM
}
