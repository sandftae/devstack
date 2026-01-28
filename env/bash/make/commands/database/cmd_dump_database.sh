#!/bin/bash
# ============================================================
# COMMAND: dump_database
# DESCRIPTION: exports database tables one-by-one with progress
# ============================================================

# cmd_dump_database function
cmd_dump_database() {
  local full_file_path
  local db_container
  local total_tables
  local start_time
  local final_size
  local db_service
  local timestamp
  local dest_path
  local dump_name
  local duration
  local percent
  local elapsed
  local db_name
  local tables
  local db_size

  db_name="$1"
  db_container=$(_get_db_container)
  db_service=${DATABASE_SERVICE_NAME:-mysql}

  # ensure the service exists and its container is running
  check_service_status "$db_service" || return 1

  if [[ -z "$db_name" ]]; then
    printf "\n%b%b[!] ERROR:%b %bdb%b argument is missing!\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    printf "Usage: %bmake dump-database db=dbname%b\n\n" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  dest_path="$PROJECT_DIR/${EXPORT_DIR:-var/export}"

  if ! _db_exists "$db_name"; then
    printf "\n%b%b[!] ERROR:%b Database %b%s%b does not exist.\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "$db_name" "${C_NC}"
    printf "%b%b[✎] NOTE:%b  use %bmake list-database%b command to see database listed.\n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  # check directory and permissions
  if [[ ! -d "$dest_path" ]]; then
    mkdir -p "$dest_path" || { printf "%b[!] ERROR:%b cannot create %b%s%b! Got permission restrictions!\n" "${COLOR_RED}" "${C_NC}" "${C_BOLD}" "$dest_path" "${C_NC}"; return 1; }
  fi

  if [[ ! -w "$dest_path" ]]; then
    printf "%b[!] ERROR:%b directory %b%s%b is not writable!\n" "${COLOR_RED}" "${C_NC}" "${C_BOLD}" "$dest_path" "${C_NC}"
    return 1
  fi

  # get table list into array
  tables=$(docker exec -i "$db_container" mysql \
      -u "$DB_USER" \
      -p"$DB_PASSWORD" \
      -N -s \
      -e "SHOW TABLES FROM \`$db_name\`;" 2>/dev/null | tr -d '\r')

  if [[ -z "$tables" ]]; then
    printf "\n%b%b[!] ERROR:%b Database %s not found or empty.\n\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "$db_name"
    return 1
  fi

  readarray -t table_array <<< "$tables"
  total_tables=${#table_array[@]}

  #metadata & confirmation
  timestamp=$(date +%Y-%m-%d_%H-%M-%S)
  dump_name="${db_name}_dump-${timestamp}.sql.gz"
  full_file_path="$dest_path/$dump_name"
  db_size=$(_get_db_size "$db_name")

  printf "Database:    %b%b%s%b\n" "${COLOR_BLUE}" "${C_BOLD}" "$db_name" "${C_NC}"
  printf "Tables:      %b%b%s%b table(s)\n" "${COLOR_MAGENTA}" "${C_BOLD}" "$total_tables" "${C_NC}"
  printf "Size:        %b%b%s MB%b\n" "${COLOR_YELLOW}" "${C_BOLD}" "$db_size" "${C_NC}"

  confirm_action "Proceed with export" || return 1

  # execution loop
  start_time=$(date +%s)
  count=0

  # well, I know what you would like to say, but for the case when you want to show progress bar and there is no
  # guaranties the customer`s host machine has installed 'pv' tol, - this is nor so bad. Especially when we are
  # talking about local development.
  # please, fell free to DM if you have better solution to show progress bar keeping speed at the top w/o needs
  # to install additional tools on host machine.
  # thanks!
  for table in "${table_array[@]}"; do
    ((count++))
    percent=$(( count * 100 / total_tables ))
    elapsed=$(( $(date +%s) - start_time ))

    # UI progress
    printf "\r%b-> Exporting progress%b: %b[%s%%]%b %s/%s: %b%s%b (%ss) \e[K" "${C_BOLD}" "${C_NC}" "${COLOR_CYAN}" "$percent" "${C_NC}" "$count" "$total_tables" "${COLOR_YELLOW}" "${table}" "${C_NC}" "$elapsed"

    if [[ $count -eq 1 ]]; then
      # dump structure and database creation
      docker exec -i "$db_container" mysqldump \
          -u "$DB_USER" \
          -p"$DB_PASSWORD" \
          --no-create-db \
          "$db_name" \
          --no-data 2>/dev/null | gzip > "$full_file_path"
    fi

    # append table data
    docker exec -i "$db_container" mysqldump \
        -u "$DB_USER" \
        -p"$DB_PASSWORD" \
        --no-create-db \
        "$db_name" \
        "$table" 2>/dev/null | gzip >> "$full_file_path"
  done

  duration=$(( $(date +%s) - start_time ))
  final_size=$(du -h "$full_file_path" | cut -f1)

  printf "\n\n%b✔%b Successfully exported in %b%ss%b.\n" "${COLOR_GREEN}" "${C_NC}" "${C_BOLD}" "$duration" "${C_NC}"
  printf "File: %b%s%b (%barchive size %s%b)\n\n" "${C_BOLD}" "$dump_name" "${C_NC}" "${COLOR_YELLOW}" "$final_size" "${C_NC}"
}