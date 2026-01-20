#!/bin/bash
# ============================================================
# COMMAND: phpcs
# DESCRIPTION: run vendor/bin/phpcs <params>
# ============================================================

# cmd_phpcs function
cmd_phpcs() {
  local report
  local cpu_cores
  local target_dir
  local report_path
  local cs_base_cmd
  local modules_list
  local service_name
  local php_container
  local base_scan_dir="app/code"
  local report_filename="report.txt"
  local report_destination="src/php-app/var/cs_report"

  service_name="${PHP_APP_SERVICE_NAME:-php-app}"

  # ensure the service exists and its node_container is running
  check_service_status "$service_name" || return 1

  php_container=$(build_container_name_by_service "$service_name") || return 1

  cpu_cores=$(_get_cpu_cores)
  report=$(get_param "report" "$@")
  modules_list=$(get_param "modules" "$@")

  # collect all paths
  for mod in ${modules_list:-.}; do
    local tmp_mod="${mod#/}"
    target_dir="$target_dir ${base_scan_dir}/${tmp_mod%/}"
  done

  report_path="$report_destination/$report_filename"

  # create command to call
  cs_base_cmd="vendor/bin/phpcs -q -s --parallel=$cpu_cores --standard=Magento2 --extensions=php,phtml,html"

  printf "%b%bINFO:%b %bphpcs%b analysis in progress, please %b%bwait%b..\n" \
        "${COLOR_BLUE}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}"

  if [[ "$report" == "true" ]]; then
    mkdir -p "$report_destination"
    docker exec -it -u php "$php_container" sh -c "export TERM=xterm-256color &&  $cs_base_cmd $target_dir" > "$report_path" 2>/dev/null
    printf "%b%b[✓] DONE:%b report saved to %b%s%b" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "$report_path" "${C_NC}"
    return 0
  fi

  # cli output
  docker exec -it -u php "$php_container" sh -c "export TERM=xterm-256color && $cs_base_cmd -p $target_dir"
  printf "%b%b[✓] DONE%b" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}"

  return 0
}