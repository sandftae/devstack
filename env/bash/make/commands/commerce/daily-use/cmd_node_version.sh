#!/bin/bash
# ============================================================
# COMMAND: cmd_node_version
# DESCRIPTION: check node version data
# ============================================================

# cmd_node_version function
cmd_node_version() {
  local npm_version
  local yarn_version
  local node_version
  local service_name
  local node_container

  service_name="${WEB_APP_SERVICE_NAME:-web-app}"

  # ensure the service exists and its node_container is running
  check_service_status "$service_name" || return 1

  node_container=$(build_container_name_by_service "$service_name") || return 1

  # extract versions: I did not find better ways, tbh...
  node_version=$(docker exec "$node_container" node -v 2>/dev/null)
  npm_version=$(docker exec "$node_container" npm -v 2>/dev/null)
  yarn_version=$(docker exec "$node_container" yarn -v 2>/dev/null)

  # print
  printf "%bNODE[web-app] enviroment:%b\n" "${C_BOLD}" "${C_NC}"

  printf "%b  node:%b      %s\n" "${COLOR_GREEN}" "${C_NC}" "${node_version:-not installed}"
  printf "%b  yarn:%b      %s\n" "${COLOR_GREEN}" "${C_NC}" "${yarn_version:-not installed}"
  printf "%b  npm:%b       %s\n" "${COLOR_GREEN}" "${C_NC}" "${npm_version:-not installed}"

  return 0
}