# ============================================================================================
# ============================================================================================
#
# Makefile command list
#
# This Makefile contains CLI command needed to run environment configurator.
# Command to manage stack and perform any other manipulations will added after
# environment deployment is done
#
# ============================================================================================
# ============================================================================================

# linuxoids
SHELL := /bin/bash

# windows-specific tweaks
ifeq ($(OS),Windows_NT)
	SHELL := bash.exe
endif

# filter command help flags
HELP_FLAGS := h help
IS_HELP := $(filter $(HELP_FLAGS),$(MAKECMDGOALS))

# export mode for bash
ifneq ($(IS_HELP),)
  export HELP_MODE=true
endif

# manager/orchestrator of the commands
manage = bash ./env/bash/make/manage

# ============================================================================================
# @@ devstack docker environment builder
# ============================================================================================
.PHONY: magma-build
magma-build: ## helper command is used to up docker environment builder
	@$(manage) magma_build

# ============================================================================================
# @ MAKEFILE TECHNICAL SECTION
# ============================================================================================

# set behavior for unknown commands
.PHONY: .DEFAULT
.DEFAULT: # a hammer trying to be a ballerina
	@$(if $(ALREADY_REPORTED), \
		:, \
		$(eval ALREADY_REPORTED=1)$(manage) unknown_target $(filter-out $(HELP_FLAGS),$(MAKECMDGOALS)) \
	)

# "catch-all" help/h and do nothing
$(HELP_FLAGS): %:
	@:

# did the user print only "make" words? get command list!
.DEFAULT_GOAL := list
