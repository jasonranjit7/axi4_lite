# ==============================================================================
# Verilator UVM Makefile (AXI4-Lite UVM Testbench)
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Path & Tool Configuration
# ------------------------------------------------------------------------------
# Fallback to verilator-compatible UVM library if UVM_HOME is unset
UVM_HOME     ?= $(HOME)/uvm-verilator/src

# Simulator Configuration
VERILATOR    := verilator
TOP_MODULE   := tb_top
SIM_NAME     := V$(TOP_MODULE)
BUILD_DIR    := obj_dir
WAVE_FILE    := dump.vcd

# Source Files
TB_SRCS      := tb_top.sv
DUT_SRCS     := $(wildcard ../dut/*.v) $(wildcard ../dut/*.sv) $(wildcard ./dut/*.v) $(wildcard ./dut/*.sv)
UVM_PKG      := $(UVM_HOME)/uvm_pkg.sv

# Directory Includes (-I) to search subdirectories for `include files
INC_DIRS     := -I. \
                -I./agent \
                -I./environment \
                -I./tests \
                +incdir+$(UVM_HOME)

# Verilator Compilation Flags
VERILATOR_FLAGS := \
	--binary \
	-sv \
	--timing \
	+define+UVM_NO_DPI \
	$(INC_DIRS) \
	-Wno-lint \
	-Wno-style \
	-Wno-fatal \
	-j 0 \
	--trace
# ------------------------------------------------------------------------------
# 2. Build Rules & Targets
# ------------------------------------------------------------------------------

.PHONY: all build run wave clean check-env help

# Default target: check env, compile, and execute simulation
all: check-env build run

# Verify UVM_HOME directory exists before proceeding
check-env:
	@if [ ! -d "$(UVM_HOME)" ]; then \
		echo "ERROR: UVM_HOME directory '$(UVM_HOME)' does not exist."; \
		echo "Run: export UVM_HOME=/path/to/uvm-verilator/src"; \
		exit 1; \
	fi

# Compile HDL and UVM package into executable binary
build: $(BUILD_DIR)/$(SIM_NAME)

$(BUILD_DIR)/$(SIM_NAME): $(UVM_PKG) $(TB_SRCS)
	@echo "==> Compiling design with Verilator..."
	$(VERILATOR) $(VERILATOR_FLAGS) $(UVM_PKG) $(DUT_SRCS) $(TB_SRCS) --top-module $(TOP_MODULE)

# Run simulation binary
run: $(BUILD_DIR)/$(SIM_NAME)
	@echo "==> Running UVM Simulation..."
	./$(BUILD_DIR)/$(SIM_NAME)

# View VCD waveform in GTKWave
wave:
	@if [ -f "$(WAVE_FILE)" ]; then \
		echo "==> Opening $(WAVE_FILE) in GTKWave..."; \
		gtkwave $(WAVE_FILE) & \
	else \
		echo "ERROR: Waveform file '$(WAVE_FILE)' not found."; \
	fi

# Clean up build artifacts and simulation outputs
clean:
	@echo "==> Cleaning generated build directory and temporary files..."
	rm -rf $(BUILD_DIR) *.vcd *.fst *.log

# Display help information
help:
	@echo "Available targets:"
	@echo "  make         - Compile and run simulation (default)"
	@echo "  make build   - Compile Verilator binary"
	@echo "  make run     - Run compiled simulation binary"
	@echo "  make wave    - Open GTKWave to view dump.vcd"
	@echo "  make clean   - Remove build output directory and log files"
