# Define the target microcontroller
TARGET = stm32f446re

# Define the toolchain
CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
GDB = arm-none-eabi-gdb

# Define the flags
CFLAGS = -mcpu=cortex-m4 -mthumb -g -O0 -Wall
LDFLAGS = -T linker_script.ld -nostartfiles
ASFLAGS = -mcpu=cortex-m4 -mthumb

# Define files
SRCS = main.c
BUILD_DIR = build
OBJS = $(patsubst %.c,$(BUILD_DIR)/%.o,$(SRCS))

# Output binary filename
OUTPUT = $(BUILD_DIR)/firmware

# Create the build directory if it doesn't exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Default rule to compile and link
all: $(BUILD_DIR) $(OUTPUT).bin

# Compile the C files into object files
$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Compile the assembly files into object files (if needed)
$(BUILD_DIR)/%.o: %.s | $(BUILD_DIR)
	$(AS) $(ASFLAGS) -c $< -o $@

# Link the object files into an ELF file
$(OUTPUT).elf: $(OBJS)
	$(CC) $(LDFLAGS) $^ -o $@

# Convert the ELF file into a binary file
$(OUTPUT).bin: $(OUTPUT).elf
	$(OBJCOPY) -O binary $< $@

# Flash the binary onto the board using st-flash
flash: $(OUTPUT).bin
	st-flash write $(OUTPUT).bin 0x8000000

# Open a GDB session for debugging
gdb: $(OUTPUT).elf
	$(GDB) -ex "target extended-remote :3333" -ex "monitor reset halt" -ex "load" -ex "monitor reset init"

# Clean up object files and binaries
clean:
	rm -rf $(BUILD_DIR)

# View the serial output via minicom
view:
	minicom -D /dev/ttyACM0 -b 115200

.PHONY: all flash clean gdb view
