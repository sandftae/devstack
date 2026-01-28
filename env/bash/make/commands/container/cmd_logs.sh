#!/bin/bash
# ============================================================
# COMMAND: logs
# DESCRIPTION: streams logs for one or all services
# ============================================================

# cmd_logs function
cmd_logs() {
  local raw_name="$1"
  local tail_lines="${2:-${LOG_TAIL:-200}}"

  local service_name="${raw_name#devstack_}"

  if [[ -z "$(_docker_compose ps --status running -q)" ]]; then
    printf "\n%b[!] ERROR:%b no containers are currently %brunning%b in this project\n\n" "${COLOR_RED}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  if [[ -n "$service_name" ]]; then
    check_service_status "$service_name" || return 1
    printf "\n%b-> Showing logs for:%b %b%s%b (tail: %s)\n\n" "${COLOR_CYAN}" "${C_NC}" "${C_BOLD}" "$service_name" "${C_NC}" "$tail_lines"
    _docker_compose logs -f --tail="$tail_lines" "$service_name"

    return 0
  fi

  printf "\n%b-> Showing all logs (tail: %s). Press Ctrl+C to stop.%b\n\n" "${COLOR_CYAN}" "$tail_lines" "${C_NC}"
  _docker_compose logs -f --tail="$tail_lines"

  return 0
}