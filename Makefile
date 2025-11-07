# Cross-platform Makefile for Fortran 2008 (.f90) - Dynamic module handling
.SUFFIXES:

FC := gfortran
RM := rm -rf

OS := $(shell uname -s 2>/dev/null || echo Windows)
CPU := $(shell uname -m 2>/dev/null || echo unknown)
FCVER := $(shell $(FC) --version 2>/dev/null | head -n1)

NPROCS := $(shell nproc 2>/dev/null || sysctl -n hw.logicalcpu 2>/dev/null || echo 1)
MAKEFLAGS += -j$(NPROCS)

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
  UNSIGNED_FLAG := -funsigned
else ifneq (,$(findstring Intel,$(FCVER)))
  CPU_FLAGS := -xHost
  UNSIGNED_FLAG :=
else
  CPU_FLAGS :=
  UNSIGNED_FLAG :=
endif

ifeq ($(OS),Windows)
  EXTRA_FLAGS := -fno-stack-protector
else
  EXTRA_FLAGS :=
endif

FFLAGS := -std=f2008 -O3 -Wall $(CPU_FLAGS) $(EXTRA_FLAGS) $(UNSIGNED_FLAG) -Jsrc

SRCDIR := src
OBJDIR := objs

SRCS := $(wildcard $(SRCDIR)/*.f90)

# Detect module files (any .f90 that contains a "module" declaration, not "program")
MODULES := $(shell grep -iRl '^[[:space:]]*module[[:space:]]' $(SRCS) | grep -vi 'program')
# Main programs are everything else
MAINS := $(filter-out $(MODULES),$(SRCS))

OBJS := $(patsubst $(SRCDIR)/%.f90,$(OBJDIR)/%.o,$(MODULES) $(MAINS))
TARGET := f

.PHONY: all clean info

all: info $(TARGET)

$(TARGET): $(OBJS)
	$(FC) $(FFLAGS) $(OBJS) -o $(TARGET)

# Compile objects
$(OBJDIR)/%.o: $(SRCDIR)/%.f90 | $(OBJDIR)
	$(FC) $(FFLAGS) -c $< -o $@

# Ensure object directory exists
$(OBJDIR):
	mkdir -p $(OBJDIR)

# Dynamically add dependencies: if a file uses a module, depend on the corresponding .o
define generate_deps
$(OBJDIR)/$(notdir $(1:.f90=.o)): $(foreach mod,$(MODULES),$(OBJDIR)/$(notdir $(mod:.f90=.o)))
endef
$(foreach file,$(MODULES) $(MAINS),$(eval $(call generate_deps,$(file))))

info:
	@echo "Detected OS:      $(OS)"
	@echo "CPU arch:         $(CPU)"
	@echo "Compiler:         $(FCVER)"
	@echo "Cores used:       $(NPROCS)"
	@echo "Flags:            $(FFLAGS)"
	@echo "Module sources:   $(MODULES)"
	@echo "Main sources:     $(MAINS)"
	@echo "Objects dir:      $(OBJDIR)"
	@echo "Executable:       $(TARGET)"

clean:
	@echo "Cleaning object files, module files, and executable..."
	$(RM) $(OBJDIR) $(TARGET) $(SRCDIR)/*.mod
