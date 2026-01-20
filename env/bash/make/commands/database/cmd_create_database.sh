#!/bin/bash
# ============================================================
# COMMAND: database_create
# DESCRIPTION: creates a new database
# ============================================================

# cmd_create_database function
cmd_create_database() {
  local sql_cmd
  local db_name="$1"
  local db_service="${DATABASE_SERVICE_NAME:-mysql}"

  # ensure the service exists and its container is running
  check_service_status "$db_service" || return 1

  # check arguments
  if [[ -z "$db_name" ]]; then
    printf "\n%b%bERROR:%b %bdb%b argument is not specified!\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    printf "Usage: %bmake create-database db=dbname%b\n\n" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  # handle existing database
  if _db_exists "$db_name"; then
    printf "Database %b%s%b already %bexists%b." "${C_BOLD}" "$db_name" "${C_NC}" "${COLOR_YELLOW}" "${C_NC}"
    confirm_action "Do you want to overwrite it?" || return 1

    # drop and create
    sql_cmd="DROP DATABASE \`$db_name\`; CREATE DATABASE \`$db_name\`;"
    spinner "Re-creating database ${COLOR_CYAN}$db_name${C_NC}" \
      _docker_compose exec -T "$db_service" mysql -u "$DB_USER" -p"$DB_PASSWORD" -e "$sql_cmd"
    return 0
  fi

  # create sql command and run it
  sql_cmd="CREATE DATABASE \`$db_name\`;"
  if ! spinner "Creating database ${COLOR_CYAN}$db_name${C_NC}" \
    _docker_compose exec -T "$db_service" mysql -u "$DB_USER" -p"$DB_PASSWORD" -e "$sql_cmd"; then
      printf "\n%b%bERROR:%b can not create database!\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"

      return 1
  fi

  printf "\n%b✔%b Database %b%s%b is ready.\n\n" "${COLOR_GREEN}" "${C_NC}" "${C_BOLD}" "$db_name" "${C_NC}"
}