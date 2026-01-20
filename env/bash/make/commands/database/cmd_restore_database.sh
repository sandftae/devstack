#!/bin/bash
# ============================================================
# COMMAND: restore_database
# DESCRIPTION: restores a gzipped SQL dump into the database
# ============================================================

# cmd_restore_database function
cmd_restore_database() {
  local db_name
  local file_name
  local db_service
  local table_count
  local source_path
  local restore_cmd
  local db_container

  db_name=$(get_param "db" "$@")
  file_name=$(get_param "file" "$@")

  db_container=$(_get_db_container)
  db_service=${DATABASE_SERVICE_NAME:-mysql}
  source_path="$PROJECT_DIR/${EXPORT_DIR:-var/export}/$file_name"

  # ensure the service exists and its container is running
  check_service_status "$db_service" || return 1

  # check db args was provided
  if [[ -z "$db_name" ]]; then
    printf "\n%b[!] ERROR:%b db name required.\n" "${COLOR_RED}" "${C_NC}"
    printf "Usage: %bmake restore-database file=dump.sql.gz db=dbname%b\n\n" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  # pre-flight checks
  if [[ -z "$file_name" || ! -f "$source_path" ]]; then
    printf "\n%b[!] ERROR:%b dump file %b%s%b not found in the %bexport%b folder\n" "${COLOR_RED}" "${C_NC}" "${C_BOLD}" "$file_name" "${C_NC}" "${C_BOLD}" "${C_NC}"
    printf "%b[✎] NOTE:%b %bmake restore-database%b works with export folder only\n" "${COLOR_YELLOW}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  if ! _db_exists "$db_name"; then
    printf "\n%b%b[!] ERROR:%b Database '%b%s%b' does not exist.\n\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "$db_name" "${C_NC}"
    return 1
  fi

  printf "\nRestoring:   %b%s%b\n" "${COLOR_YELLOW}" "$file_name" "${C_NC}"
  printf "To Database: %b%s%b\n" "${COLOR_BLUE}" "$db_name" "${C_NC}"
  printf "\n%b%bWARNING:%b This will overwrite existing data.\n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}"
  confirm_action "Proceed with drop" || return 1

  # define the command string for the spinner
  restore_cmd="gunzip -c '$source_path' | docker exec -i '$db_container' mysql -u '$DB_USER' -p'$DB_PASSWORD' '$db_name'"

  # execute restore
  if ! spinner "Restoring database $db_name" bash -c "$restore_cmd"; then
    return 1
  fi

# count tables after restore to confirm success
table_count=$(docker exec -i "$db_container" mysql -u "$DB_USER" -p"$DB_PASSWORD" -N -s -e \
              "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$db_name';" 2>/dev/null)

printf "\n%b%b[✓] Database %s restored:%b %b%s%b table{s}\n" "${COLOR_GREEN}" "${C_BOLD}" "$db_name" "${C_NC}" "${C_BOLD}" "$table_count" "${C_NC}"
return 0
}