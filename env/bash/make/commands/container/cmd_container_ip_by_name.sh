#!/bin/bash
# ============================================================
# COMMAND: container_ip_by_name
# DESCRIPTION: get container ip by service name
# ============================================================

# cmd_container_ip_by_name function
cmd_container_ip_by_name() {
  local name=""
  local raw_name=""
  local container_name=""
  local container_ip_address=""
  local project_prefix="${COMPOSE_PROJECT_NAME:-devstack}"
  local base_network=${DEVSTACK_BASE_NETWORK:-devstack_base_network}

  raw_name=$(get_param "name" "$@")

  if [ -z "$raw_name" ]; then
    printf "%b%b[!] ERROR:%b %bname%b argument missing!\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  # strip the 'devstack_' prefix if the user provided it
  name="${raw_name#${project_prefix}_}"

  # ensure the service exists and its container is running
  check_service_status "$name" || return 1
  container_name="${project_prefix}_${name}"

  container_ip_address=$(docker inspect -f "{{.NetworkSettings.Networks.${base_network}.IPAddress}}" "$container_name" 2>/dev/null)
  if [ -z "$container_ip_address" ]; then
      printf "%b[!] ERROR:%b Could not find IP for container %s in network %s\n" \
        "${COLOR_RED}" "${C_NC}" "$container_name" "$base_network"
      return 1
    fi

  echo "$container_ip_address"
}
