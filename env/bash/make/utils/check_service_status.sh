#!/bin/bash
# ============================================================
# UTILS: check_service_status
# DESCRIPTION: unified check for service existence and state
# ============================================================

# check_service_status function
check_service_status() {
  local service_name="$1"

  # check if the service is defined in the yml/yaml
  if ! _docker_compose config --services | grep -qw "$service_name"; then
    printf "\n%b%b[!] ERROR:%b Service %b%s%b is not defined in your compose files!\n\n" \
      "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "$service_name" "${C_NC}"
    return 1
  fi

  # check if the service is running
  if ! _docker_compose ps --filter "status=running" --services | grep -qw "$service_name"; then
    printf "\n%b%b[!] ERROR:%b Service %b%s%b is not running!\n" \
      "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "$service_name" "${C_NC}"
    printf "\t   Please run %bmake up%b first.\n\n" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  return 0
}