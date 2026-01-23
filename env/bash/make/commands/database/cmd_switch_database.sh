#!/bin/bash
# ============================================================
# COMMAND: switch_database
# DESCRIPTION: switch database
# ============================================================

# cmd_switch_database function
cmd_switch_database() {
  local db="$1"
  local db_service="${DATABASE_SERVICE_NAME:-mysql}"

  # ensure the service exists and its container is running
  check_service_status "$db_service" || return 1

  # check arguments
  if [[ -z "$db" ]]; then
    printf "\n%b%bERROR:%b %bdb%b argument is not specified!\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    printf "Usage: %bmake switch-database db=dbname%b\n\n" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  # handle existing database
  if ! _db_exists "$db"; then
    printf "%b%b [!] ERROR:%b database %b%b%s%b does not %bexists%b.\n" "${COLOR_RED}" \
    "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "${C_BOLD}" "$db" "${C_NC}" "${C_BOLD}" "${C_NC}"

    printf "Run %bmake create-database db=your_database_name%b first.\n" "${C_BOLD}" "${C_NC}"

    return 1
  fi

  update_env_var "DB_NAME" "$db" "$COMMERCE_ENV_FILE"


  printf "%b✔%b Database is switched to %b%s%b.\n" "${COLOR_GREEN}" "${C_NC}" "${C_BOLD}" "$db" "${C_NC}"

  return 0
}