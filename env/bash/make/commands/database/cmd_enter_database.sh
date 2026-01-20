#!/bin/bash
# ============================================================
# COMMAND: enter_database
# DESCRIPTION: opens an interactive database terminal
# ============================================================

# cmd_enter_database function
cmd_enter_database() {
  local db_service=${DATABASE_SERVICE_NAME:-mysql}
  local db_container="${COMPOSE_PROJECT_NAME}_${db_service}"

  # ensure the service exists and its container is running
  check_service_status "$db_service" || return 1

  # execute container
  docker exec -it "$db_container" sh -c "MYSQL_PWD='$DB_PASSWORD' mysql -u $DB_USER"
}