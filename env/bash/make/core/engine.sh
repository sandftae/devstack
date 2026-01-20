#!/bin/bash
# ============================================================
# CORE: engine
# DESCRIPTION: it maps the CLI string to a bash function
# ============================================================

# author notes:
#   - this is function-based engine
#   - from my point of view, in this case it is better that file-based one
engine() {
  local command=$1
  shift # everything else in "$@" are the args

  local target_func="cmd_${command}"

  # check the function exists and call it
  if declare -f "$target_func" > /dev/null; then
    "$target_func" "$@"
    return 0
  fi

  printf "%b%b[!] ERROR:%b command %b%s%b not found.\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "$command" "${C_NC}"

  return 1
}