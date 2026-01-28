#!/bin/bash
# ============================================================
# COMMAND: stats
# DESCRIPTION: shows a snapshot of container resource usage
# ============================================================

# cmd_stats function
cmd_stats() {
  local format_table="table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}"

  # --no-stream ensures the command prints once and exits immediately
  if ! docker stats --no-stream --format "$format_table"; then
    printf "\n%b%b[!] ERROR:%b could not retrieve container statistics. Are the Docker demon running?\n" \
          "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
    return 1
  fi
}