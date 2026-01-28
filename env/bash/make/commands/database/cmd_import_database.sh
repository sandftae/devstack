#!/bin/bash
# ============================================================
# COMMAND: import_database
# DESCRIPTION: imports a SQL dump into a specific database
# ============================================================

# cmd_import_database function
cmd_import_database() {
  local full_path
  local file_size
  local db_service
  local db_name="$1"
  local file_name="$2"

  db_name=$(get_param "db" "$@")
  file_name=$(get_param "file" "$@")

  db_service="${DATABASE_SERVICE_NAME:-db}"
  full_path="$PROJECT_DIR/$IMPORT_DIR/$file_name"

  # ensure the service exists and its container is running
  check_service_status "$DATABASE_SERVICE_NAME" || return 1

  # check args
  if [[ -z "$db_name" ]] || [[ -z "$file_name" ]]; then
    printf "\n%b%b[!] ERROR:%b %bdb%b or %bfile%b argument missing!\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    printf "Usage: %bmake import-database db=dbname file=filename.sql%b\n\n" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  # check file existence
  if [[ ! -f "$full_path" ]]; then
    printf "\n%b%b[!] ERROR:%b file not found: %b%s/%s%b\n\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "$IMPORT_DIR" "$file_name" "${C_NC}"
    return 1
  fi

  if _is_protected "$db_name"; then
    printf "\n%b%b[!] ERROR:%b target %b%s%b is a protected system schema.\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "$db_name" "${C_NC}"
    printf "\n%bAction denied to prevent database corruption.%b\n\n" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  # check if database exists
  if ! _db_exists "$db_name"; then
    printf "\n%b%b[!] ERROR:%b database %b%s%b does not exist.\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "$db_name" "${C_NC}"
    printf "Create it first: %bmake create-database db=%s%b\n\n" "${C_BOLD}" "$db_name" "${C_NC}"
    return 1
  fi

  # confirmation
  file_size=$(du -h "$full_path" | cut -f1)
  printf "Database:    %b%s%b\n" "${COLOR_BLUE}" "$db_name" "${C_NC}"
  printf "Source file: %b%s/%s%b (%b%s%b)\n" "${COLOR_BLUE}" "$IMPORT_DIR" "$file_name" "${C_NC}" "${COLOR_YELLOW}" "$file_size" "${C_NC}"
  printf "\n%b%bWARNING:%b This will overwrite existing data\n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}"

  confirm_action "Proceed with import" || return 1

  printf " ->Importing may %btake a while%b...\n" "${C_BOLD}" "${C_NC}"

  # stream the file into the container
  if _docker_compose exec -T "$db_service" sh -c " MYSQL_PWD='$DB_PASSWORD' mysql -u '$DB_USER' '$db_name' < /import/$file_name" ; then
    printf "\n%b%b✔%b Import completed %bsuccessfully%b!\n\n" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    return 0
  fi

  printf "\n%b%b[!] ERROR:%b import failed during execution.\n\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
  return 1
}
