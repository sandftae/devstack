#!/bin/bash
# shellcheck disable=SC2086
# ============================================================
# COMMAND: phpcbf
# DESCRIPTION: run vendor/bin/phpcbf <params>
# ============================================================

# cmd_phpcbf function
cmd_phpcbf() {
  local suffix
  local clean_mod
  local bf_base_cmd
  local modules_list
  local php_container
  local target_paths=""
  local base_scan_dir="app/code"
  local standard="${PHP_CS_STANDARD:-PSR12}"
  local service_name="${PHP_APP_SERVICE_NAME:-php-app}"

  check_service_status "$service_name" || return 1
  php_container=$(build_container_name_by_service "$service_name") || return 1

  modules_list=$(get_param "modules" "$@")
  for mod in ${modules_list:-.}; do
    clean_mod="${mod#/}"
    clean_mod="${clean_mod%/}"
    suffix="${clean_mod#.}"
    target_paths+="${target_paths:+ }${base_scan_dir}${suffix:+/$suffix}"
  done

  bf_base_cmd="vendor/bin/phpcbf -p --standard=$standard --extensions=php --ignore=vendor,node_modules $target_paths"
  docker exec -it -u php "$php_container" sh -c "export TERM=xterm-256color && $bf_base_cmd"

  local exit_code=$?

  if [ $exit_code -eq 2 ]; then
    printf "\n%b%b[!] INFO%b: auto-fix partially done.\n" "${COLOR_BLUE}" "${C_BOLD}" "${C_NC}"
    confirm_action "Do you want to run %bCodeSniffer%b to check what left?" "${C_BOLD}" "${C_NC}" && cmd_phpcs "$@"
  fi

  printf "\n%b%b[!] DONE%b" "${COLOR_BLUE}" "${C_BOLD}" "${C_NC}"
  return 0
}