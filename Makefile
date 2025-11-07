# Cross-platform Makefile for Fortran 2008 (.f08)
# All objects in objs/, entry point f.f08 → executable f
.SUFFIXES:

FC := gfortran

# Detect OS, CPU, compiler
OS := $(shell uname -s 2>/dev/null || echo Windows)
CPU := $(shell uname -m 2>/dev/null || echo unknown)
FCVER := $(shell $(FC) --version 2>/dev/null | head -n1)

# Detect cores for -j
NPROCS := $(shell nproc 2>/dev/null || sysctl -n hw.logicalcpu 2>/dev/null || echo 1)
MAKEFLAGS += -j$(NPROCS)

# CPU optimization flags
ifeq ($(findstring GNU Fortran,$(FCVER)),GNU Fortran)
  ifeq ($(CPU),x86_64)
    CPU_FLAGS := -march=native
  else ifeq ($(CPU),arm64)
    CPU_FLAGS := -mcpu=apple-m1
  else ifeq ($(CPU),aarch64)
    CPU_FLAGS := -march=armv8-a
  else
    CPU_FLAGS :=
  endif
else ifneq (,$(findstring Intel,$(FCVER)))
  CPU_FLAGS := -xHost
else
  CPU_FLAGS :=
endif

# Windows flags
ifeq ($(OS),Windows)
  EXTRA_FLAGS := -fno-stack-protector
else
  EXTRA_FLAGS :=
endif

FFLAGS := -std=f2008 -O3 -Wall $(CPU_FLAGS) $(EXTRA_FLAGS)

# Directories
SRCDIR := src
OBJDIR := objs

# Source files
SRCS := $(wildcard $(SRCDIR)/*.f08)
OBJS := $(patsubst $(SRCDIR)/%.f08,$(OBJDIR)/%.o,$(SRCS))

# Executable = entry point f.f08 → f
TARGET := f

.PHONY: all clean info

all: info $(TARGET)

# Link all objects into executable
$(TARGET): $(OBJS)
	$(FC) $(FFLAGS) $(OBJS) -o $(TARGET)

# Compile objects
$(OBJDIR)/%.o: $(SRCDIR)/%.f08 | $(OBJDIR)
	$(FC) $(FFLAGS) -c $< -o $@

# Ensure object directory exists
$(OBJDIR):
	mkdir -p $(OBJDIR)

info:
	@echo "Detected OS:   $(OS)"
	@echo "CPU arch:      $(CPU)"
	@echo "Compiler:      $(FCVER)"
	@echo "Cores used:    $(NPROCS)"
	@echo "Flags:         $(FFLAGS)"
	@echo "Sources:       $(SRCS)"
	@echo "Objects dir:   $(OBJDIR)"
	@echo "Executable:    $(TARGET)"

# Clean objects and binary
clean:
	@echo "Cleaning object files and executable..."
	rm -rf $(OBJDIR) $(TARGET)

