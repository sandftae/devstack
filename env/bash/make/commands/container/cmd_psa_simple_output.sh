#!/bin/bash
# ============================================================
# COMMAND: psa_simple_output
# DESCRIPTION: run docker ps -a with predefined table format
# ============================================================

# cmd_psa_simple_output function
cmd_psa_simple_output() {
  local format_table

  # define the format
  format_table="table {{.ID}}\t{{printf \"%.38s\" .Image}}\t{{.Status}}\t{{printf \"%.35s\" .Ports}}\t{{.Names}}\t{{.Networks}}"

  if ! docker ps -a --format "$format_table"; then
    printf "\n%b%b[!] ERROR:%b Failed to list containers. Is the Docker daemon running?\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
    return 1
  fi
}

