#!/bin/bash
# ============================================================
# COMMAND: list_database
# DESCRIPTION: displays a formatted table of databases and sizes
# ============================================================

# cmd_list_database
cmd_list_database() {
  local color
  local output
  local stats_sql
  local db_service
  # column widths
  local NAME_W=40
  local SIZE_W=15

  db_service=${DATABASE_SERVICE_NAME:-mysql}

  # ensure the service exists
  check_service_status "$db_service" || return 1

  # SQL query to get Name and Size
  stats_sql="SELECT schema_name, COALESCE(ROUND(SUM(data_length + index_length) / 1024 / 1024, 2), 0) FROM information_schema.schemata LEFT JOIN information_schema.tables ON schema_name = table_schema GROUP BY schema_name;"

  # execute and capture
  output=$(docker exec -i "${COMPOSE_PROJECT_NAME}_${db_service}" sh -c "MYSQL_PWD='$DB_PASSWORD' mysql -u root -N -s -e \"$stats_sql\"" 2>/dev/null)

  # print header
  printf "\n%b%b%-*s | %-*s%b\n" "${C_BOLD}" "${COLOR_BLUE}" $NAME_W "DATABASE NAME" $SIZE_W "SIZE (MB)" "${C_NC}"
  printf -- "------------------------------------------------------------\n"

  # process rows
  while read -r name size; do
    [[ -z "$name" ]] && continue

    # highlight protected databases in a different color
    color=$C_BOLD
    if _is_protected "$name"; then
        color=$COLOR_YELLOW
    fi

    printf "%b%-*s%b | %-*s MB\n" "$color" $NAME_W "$name" "${C_NC}" $SIZE_W "$size"
  done <<< "$output"

  printf -- "------------------------------------------------------------\n"
  printf "%b[✎] NOTE:%b databases in %byellow%b are system/protected schemas.\n" "${COLOR_YELLOW}" "${C_NC}" "${COLOR_YELLOW}" "${C_NC}"
  printf "          white entries are user-defined databases.\n"
  printf -- "------------------------------------------------------------\n\n"
}