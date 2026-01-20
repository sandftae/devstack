#!/bin/bash
# ============================================================
# COMMAND: cmd_ps_simple_output
# DESCRIPTION: run docker ps with predefined table format
# ============================================================

# cmd_ps_simple_output function
cmd_ps_simple_output() {
  local format_table

  # define the format
  format_table="table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{printf \"%.45s\" .Ports}}\t{{.Names}}\t{{.Networks}}"

  if ! docker ps --format "$format_table"; then
    printf "\n%b%b[!] ERROR:%b Failed to list containers. Is the Docker daemon running?\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
    return 1
  fi
}