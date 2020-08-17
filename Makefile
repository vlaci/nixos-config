##
# Project Title
#
# @file
# @version 0.1
.ONESHELL:
SHELL = bash
.SHELLFLAGS = -euo pipefail -c
.DEFAULT_GOAL :=

BOLD   = \033[1m
GREEN  = \033[32m
YELLOW = \033[33m
RESET  = \033[0m

###############################################################################
## General
.PHONY: help
help:  ## Show this help message
#
# Parses help message from Makefile. Messages must appear after target or
# variable specification. Description must start with at least one whitespace
# character and followed by `##` characters. If global variables section is not
# needed, remove or comment out its section.
#
# Suggested Makefile layout:
#   GLOBAL_VARIABLES ?= dummy  ## Global variables
#   PRIVATE_VARIABLE ?= private  # No help shown here
#   ...
#
#   ## Section header
#   help: ## Show this help message
#       ...
#
#   ## Another section
#   target:  ## Shows target description
#       ...
#   target: TARGET_SPECIFIC ?=  ## This description appears at target's help
#
ifeq (, $(shell which gawk))
 $(error "This target requires 'gawk'. Install that first.")
endif
	@echo -e "Usage: $(BOLD)make$(RESET) $(YELLOW)<target>$(RESET) [$(GREEN)VARIABLE$(RESET)=value, ...]"
	@echo
	@echo -e "$(BOLD)Global variables:$(RESET)"
	gawk 'match($$0, /^## (.+)$$/, m) {
		printf "\n$(BOLD)%s targets:$(RESET)\n", m[1]
	}
	match($$0, /^([^: ]+)\s*:\s*[^#=]+## +(.*)/, m) {
		if (length(m[1]) < 10) {
			printf "  $(YELLOW)%-10s$(RESET) %s\n", m[1], m[2]
		} else {
			printf "  $(YELLOW)%s$(RESET)\n%-12s %s\n", m[1], "", m[2]
		}
	}
	match($$0, /^([^?= ]+)\s*\?=\s*([^# ]+)?\s*## +(.*)/, m) {
		if (length(m[2]) == 0) {
			m[2] = "unset"
		}
		printf "  $(GREEN)%s$(RESET): %s (default: $(BOLD)%s$(RESET))\n", m[1], m[3], m[2]
	}
	match($$0, /^[^: ]+\s*:\s*([^?= ]+)\s*\?=\s*([^# ]+)?\s*## +(.*)/, m) {
		if (length(m[2]) == 0) {
			m[2] = "unset"
		}
		printf "%-13s- $(GREEN)%s$(RESET): %s (default: $(BOLD)%s$(RESET))\n", "", m[1], m[3], m[2]
	}
	' $(MAKEFILE_LIST)

dev:  ## Setup repository for development
	git config --local include.path .gitconfig

# end
