#!/bin/bash
# ============================================================
# COMMAND: top
# DESCRIPTION: shows resource usage (CPU/MEM)
# ============================================================

# cmd_top function
cmd_top() {
  local format_table="table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}"

  if ! docker info > /dev/null 2>&1; then
      printf "\n%b%b[!] ERROR:%b could not connect to Docker. Is the daemon running?\n" \
            "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
      return 1
  fi

  [ -n "$(docker ps -q)" ] && docker stats --no-stream --format "$format_table" ||
    printf "%b%b[!] INFO%b: docker environment is %bdown!%b Run %bmake up%b first." \
      "${C_BOLD}" "${COLOR_BLUE}" "${C_NC}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"

  printf "\n%b%b[✎] NOTE:%b For  better experience use %bmake metrics%b command \n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
  return 0
}