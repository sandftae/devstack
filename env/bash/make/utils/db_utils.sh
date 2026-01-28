#!/bin/bash
# ============================================================
# UTILS: database_utils
# DESCRIPTION: shared logic for database manipulation scripts
# ============================================================

# standardized container name resolution
_get_db_container() {
  # defaulting to 'mysql' if DATABASE_SERVICE_NAME is not set
  printf "%s_%s" "${COMPOSE_PROJECT_NAME}" "${DATABASE_SERVICE_NAME:-mysql}"
}

# standardized existence check
_db_exists() {
  local db="$1"
  local container

  container=$(_get_db_container)

  docker exec -i "$container" sh -c "MYSQL_PWD='root' mysql -u $DB_USER -N -s -e 'SHOW DATABASES LIKE \"$db\"'" 2>/dev/null \
    | tr -d '\r' \
    | grep -qw "$db"
}

# standardized protected database check
_is_protected() {
  local db="$1"
  local protected

  # iterating through the array of protected databases defined in config
  for protected in "${PROTECTED_DBS[@]}"; do
    [[ "$db" == "$protected" ]] && return 0
  done

  return 1
}

# standardized size check
_get_db_size() {
  local size
  local query
  local db="$1"
  local container

  container=$(_get_db_container)

  query="SELECT COALESCE(ROUND(SUM(data_length + index_length) / 1024 / 1024, 2), 0) FROM information_schema.TABLES WHERE table_schema = '$db';"
  size=$(docker exec -i "$container" sh -c "MYSQL_PWD='root' mysql -u $DB_USER -N -s -e \"$query\"" 2>/dev/null | tr -d '\r')

  # return 0.00 if the result is empty or invalid
  printf "%s" "${size:-0.00}"
}