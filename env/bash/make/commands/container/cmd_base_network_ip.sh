#!/bin/bash
# ============================================================
# COMMAND: base_network_ip
# DESCRIPTION: get base network ip address
# ============================================================

# cmd_base_network_ip function
cmd_base_network_ip() {
  local network_ip_address=""
  local base_network=${DEVSTACK_BASE_NETWORK:-devstack_base_network}

  network_ip_address=$(docker network inspect -f '{{range .IPAM.Config}}{{.Gateway}}{{end}}' "$base_network" 2>/dev/null)
  if [ -z "$network_ip_address" ]; then
      printf "%b%b[!] ERROR:%b could not find IP for the network %b%s%b" \
      "${COLOR_RED}" "${C_BOLD}" "${C_NC}"  "${C_BOLD}" "$base_network" "${C_NC}"
      return 1
    fi

  echo "$network_ip_address"
}