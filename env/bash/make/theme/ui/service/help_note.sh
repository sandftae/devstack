#!/bin/bash
# ============================================================
# UI: list_note
# DESCRIPTION: print header for list command
# ============================================================

# list_note function
list_note() {
  printf "%b================================================================================================\n" "${COLOR_YELLOW}"
  printf "  [✎] NOTE: This output is generated from '##' comments.   \n"
  printf "  Please do not change '##' location.\n"
  printf "  You can safely update the comment text.\n"
  printf "  Use the same pattern to add a new command to the command list: \n"
  printf "\n"
  printf "          .PHONY: command \n"
  printf "          command: ## your fancy comment will go here after these double hashtags \n"
  printf "             <command execution content> \n"
  printf "================================================================================================%b\n" "${C_NC}"
}