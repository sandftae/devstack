#!/bin/bash
# ============================================================
# COMMAND: varnish_meta
# DESCRIPTION: provides varnish meta data
# ============================================================

# cmd_varnish_meta function
cmd_varnish_meta() {
  local service_name
  local status_msg="enabled/unsilenced"

  service_name="${VARNISH_SERVICE_NAME:-varnish}"

  # ensure the service exists and its container is running
  check_service_status "$service_name" || return 1

  if [[ "$DEVELOPER_MODE_BYPASS_VARNISH" == "true" ]]; then
    status_msg="disabled/silenced"
  fi

  printf "%b%bVarnish%b is %brunning%b, and is %b%b%s%b\n" \
    "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}" \
    "${COLOR_YELLOW}" "${C_BOLD}" "$status_msg" "${C_NC}"

  return 1
}