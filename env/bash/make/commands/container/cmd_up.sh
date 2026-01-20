#!/bin/bash
# ============================================================
# COMMAND: up
# DESCRIPTION: up docker environment
# ============================================================

# cmd_up function
cmd_up() {
  # show the header
  up_header

  # run the docker compose ... command
  if spinner "Starting containers" _docker_compose up -d; then
    # show the footer
    up_footer

    return 0
  fi

  printf "\n%b%b[!] ERROR:%b something went wrong\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
  return 1
}