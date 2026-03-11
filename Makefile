# Makefile for Archi - ArchiMate Modelling Editor
# Cross-platform build tool for Windows, Linux, and macOS

# ==============================================================================
# Configuration
# ==============================================================================

SHELL := /bin/bash
MVN := mvn
MVN_FLAGS := -B
PRODUCT_PROFILE := -P product
TEST_PROFILE := -P tests

# Version extraction from pom.xml (compatible with macOS and Linux grep)
VERSION := $(shell grep '<revision>' pom.xml | sed -n 's/.*<revision>\(.*\)<\/revision>.*/\1/p')

# Output directories
BUILD_DIR := build
PRODUCT_DIR := com.archimatetool.editor.product/target/products/com.archimatetool.editor.product

# Platform-specific settings
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

ifeq ($(UNAME_S),Darwin)
    OS_NAME := macos
    ifeq ($(UNAME_M),arm64)
        OS_ARCH := aarch64
    else
        OS_ARCH := x86_64
    endif
else ifeq ($(UNAME_S),Linux)
    OS_NAME := linux
    OS_ARCH := x86_64
else ifeq ($(OS),Windows_NT)
    OS_NAME := windows
    OS_ARCH := x86_64
else
    OS_NAME := unknown
    OS_ARCH := unknown
endif

# ==============================================================================
# Targets
# ==============================================================================

.PHONY: all clean build product test help deps validate

## Default target
all: build

## Display help information
help:
	@printf "\033[0;34mArchi Build System\033[0m\n"
	@printf "====================\n"
	@printf "\n"
	@printf "Usage: make [target]\n"
	@printf "\n"
	@printf "Targets:\n"
	@printf "  \033[0;32mall\033[0m      - Build all modules (default)\n"
	@printf "  \033[0;32mbuild\033[0m    - Compile all modules\n"
	@printf "  \033[0;32mproduct\033[0m  - Build distributable products for all platforms\n"
	@printf "  \033[0;32mtest\033[0m     - Run tests\n"
	@printf "  \033[0;32mclean\033[0m    - Clean build artifacts\n"
	@printf "  \033[0;32mdeps\033[0m     - Download all dependencies\n"
	@printf "  \033[0;32mvalidate\033[0m - Validate project structure\n"
	@printf "\n"
	@printf "Platform-specific product builds:\n"
	@printf "  \033[0;32mproduct-win\033[0m    - Build Windows product only\n"
	@printf "  \033[0;32mproduct-linux\033[0m  - Build Linux product only\n"
	@printf "  \033[0;32mproduct-mac\033[0m    - Build macOS product only\n"
	@printf "\n"
	@printf "Current environment:\n"
	@printf "  OS: $(OS_NAME)\n"
	@printf "  Arch: $(OS_ARCH)\n"
	@printf "  Version: $(VERSION)\n"

## Validate project structure
validate:
	@printf "\033[0;34mValidating project structure...\033[0m\n"
	@$(MVN) $(MVN_FLAGS) validate
	@printf "\033[0;32m✓ Project validation successful\033[0m\n"

## Download all dependencies
deps:
	@printf "\033[0;34mDownloading dependencies...\033[0m\n"
	@$(MVN) $(MVN_FLAGS) dependency:resolve
	@printf "\033[0;32m✓ Dependencies downloaded\033[0m\n"

## Build all modules
build: validate
	@printf "\033[0;34mBuilding all modules...\033[0m\n"
	@$(MVN) $(MVN_FLAGS) clean package
	@printf "\033[0;32m✓ Build completed successfully\033[0m\n"

## Build with tests
test: validate
	@printf "\033[0;34mRunning tests...\033[0m\n"
	@$(MVN) $(MVN_FLAGS) clean test
	@printf "\033[0;32m✓ Tests completed\033[0m\n"

## Build distributable products for all platforms (Windows, Linux, macOS)
product: clean
	@printf "\033[0;34mBuilding products for all platforms...\033[0m\n"
	@printf "\033[0;33mNote: This will create unsigned bundles. Production builds require additional signing/notarization.\033[0m\n"
	@$(MVN) $(MVN_FLAGS) $(PRODUCT_PROFILE) clean package
	@echo ""
	@printf "\033[0;32m✓ Product build completed\033[0m\n"
	@echo ""
	@echo "Products exported to:"
	@echo "  $(PRODUCT_DIR)/"
	@echo ""
	@echo "Platform bundles (with embedded JRE):"
	@echo "  - Windows x64:  $(PRODUCT_DIR)/win32/win32/x86_64/Archi/"
	@echo "  - Linux x64:    $(PRODUCT_DIR)/linux/gtk/x86_64/Archi/"
	@echo "  - macOS Intel:  $(PRODUCT_DIR)/macosx/cocoa/x86_64/Archi.app"
	@echo "  - macOS ARM64:  $(PRODUCT_DIR)/macosx/cocoa/aarch64/Archi.app"

## Build Windows product only
product-win: clean
	@printf "\033[0;34mBuilding Windows product...\033[0m\n"
	@$(MVN) $(MVN_FLAGS) $(PRODUCT_PROFILE) clean package -Dtycho.buildQualifiers=false
	@printf "\033[0;32m✓ Windows product built (with embedded JRE)\033[0m\n"
	@echo "Output: $(PRODUCT_DIR)/win32/win32/x86_64/Archi/"

## Build Linux product only
product-linux: clean
	@printf "\033[0;34mBuilding Linux product...\033[0m\n"
	@$(MVN) $(MVN_FLAGS) $(PRODUCT_PROFILE) clean package -Dtycho.buildQualifiers=false
	@printf "\033[0;32m✓ Linux product built (with embedded JRE)\033[0m\n"
	@echo "Output: $(PRODUCT_DIR)/linux/gtk/x86_64/Archi/"

## Build macOS product only
product-mac: clean
	@printf "\033[0;34mBuilding macOS product...\033[0m\n"
	@$(MVN) $(MVN_FLAGS) $(PRODUCT_PROFILE) clean package -Dtycho.buildQualifiers=false
	@printf "\033[0;32m✓ macOS product built (with embedded JRE)\033[0m\n"
	@echo "Output: $(PRODUCT_DIR)/macosx/cocoa/"

## Clean build artifacts
clean:
	@printf "\033[0;34mCleaning build artifacts...\033[0m\n"
	@$(MVN) $(MVN_FLAGS) clean
	@rm -rf $(BUILD_DIR)
	@printf "\033[0;32m✓ Clean completed\033[0m\n"

## Install to local Maven repository
install:
	@printf "\033[0;34mInstalling to local Maven repository...\033[0m\n"
	@$(MVN) $(MVN_FLAGS) clean install
	@printf "\033[0;32m✓ Installation completed\033[0m\n"

## Quick build without tests
quick: validate
	@printf "\033[0;34mQuick build (skipping tests)...\033[0m\n"
	@$(MVN) $(MVN_FLAGS) clean package -DskipTests
	@printf "\033[0;32m✓ Quick build completed\033[0m\n"

## Verify build environment
verify-env:
	@echo "Build Environment Check"
	@echo "======================="
	@echo ""
	@echo "Checking prerequisites..."
	@which $(MVN) > /dev/null 2>&1 && echo "✓ Maven installed: $$($(MVN) --version | head -1)" || echo "✗ Maven not found"
	@if command -v java >/dev/null 2>&1; then \
		echo "✓ Java version: $$(java -version 2>&1 | head -1)"; \
	else \
		echo "✗ Java not found"; \
	fi
	@echo ""
	@echo "Current directory: $$(pwd)"
	@echo "Build OS: $(OS_NAME) ($(OS_ARCH))"
	@echo "Archi Version: $(VERSION)"
