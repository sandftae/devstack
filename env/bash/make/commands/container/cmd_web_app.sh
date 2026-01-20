#!/bin/bash
# ============================================================
# COMMAND: web-app
# DESCRIPTION: enters the web-app docker container interactively
# as 'node' user
# ============================================================

# cmd_web_app
cmd_web_app() {
  local service_name
  local node_container

  service_name="${WEB_APP_SERVICE_NAME:-web-app}"

  # ensure the service exists and its node_container is running
  check_service_status "$service_name" || return 1

  node_container=$(build_container_name_by_service "$service_name") || return 1

  docker exec -it -u node "$node_container" sh
}