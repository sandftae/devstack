#!/bin/bash
# ============================================================
# COMMAND: drop_database
# DESCRIPTION: permanently deletes a database after confirmation
# ============================================================

# cmd_drop_database function
cmd_drop_database() {
  local db_size
  local drop_sql
  local error_msg
  local clean_error
  local db_name="$1"
  local db_container
  local db_service=${DATABASE_SERVICE_NAME:-mysql}

  # prepare SQL
  drop_sql="DROP DATABASE \`$db_name\`;"

  if [[ -z "$db_name" ]]; then
    printf "\n%b%b[!] ERROR:%b %bdb%b argument is missing!\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    printf "Usage: %bmake drop-database db=dbname%b\n\n" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  db_container=$(_get_db_container)

  check_service_status "$db_service" || return 1

  if _is_protected "$db_name"; then
    printf "\n%b%b[!] CRITICAL ERROR:%b database '%b%s%b' is a system schema and is %bcan not be removed ;=)%b.\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "$db_name" "${C_NC}" "${C_BOLD}" "${C_NC}"
    printf "\n%bAction denied to prevent database corruption.%b\n\n" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  if ! _db_exists "$db_name"; then
    printf "\n%b%b[!] ERROR:%b database '%b%s%b' does not exist.\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "$db_name" "${C_NC}"
    printf "%b%b[✎] NOTE:%b  use %bmake list-database%b command to see database listed.\n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  db_size=$(_get_db_size "$db_name")

  # some output data the customer to be aware of
  printf "Target Database: %b%b%s%b\n" "${COLOR_RED}" "${C_BOLD}" "$db_name" "${C_NC}"
  printf "Current Size:    %b%b%s MB%b\n" "${COLOR_YELLOW}" "${C_BOLD}" "$db_size" "${C_NC}"
  printf "\n%b%bWARNING:%b This action is %bPERMANENT%b. All tables and data will be destroyed.\n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"

  confirm_action "Proceed with drop" || return 1

  printf "\n%b-> Deleting database...%b\n" "${COLOR_CYAN}" "${C_NC}"
  if error_msg=$(docker exec -i "$db_container" sh -c "MYSQL_PWD='$DB_PASSWORD' mysql -u $DB_USER -e '$drop_sql'" 2>&1); then
    printf "\n%b✔ SUCCESS:%b database deleted.\n\n" "${COLOR_GREEN}" "${C_NC}"
    return 0
  fi

  clean_error=$(printf "%s" "$error_msg" | grep -v "World-writable" | grep -i "error")
  printf "\n%b%b[!] ERROR:%b could not drop database.\n""${C_BOLD}" "${COLOR_RED}" "${C_NC}"
  printf "%bReason:%b %s\n\n" "${COLOR_YELLOW}" "${C_NC}" "${clean_error:-$error_msg}"

  return 1
}