#!/bin/bash
# shellcheck disable=SC2086

# ============================================================
# COMMAND: eslint
# DESCRIPTION: run npx eslint <params>
# ============================================================

# cmd_eslint function
cmd_eslint() {
  local suffix
  local clean_mod
  local modules_list
  local target_paths=""
  local base_scan_dir="."
  local service_name
  local node_container

  service_name="${WEB_APP_SERVICE_NAME:-web-app}"

  check_service_status "$service_name" || return 1

  node_container=$(build_container_name_by_service "$service_name") || return 1

  modules_list=$(get_param "modules" "$@")
  if [ -z "$modules_list" ]; then
      printf "%b[!] WARNING%b: no modules specified, ESLint will scan the %bENTIRE%b project.\n" "${COLOR_YELLOW}" "${C_NC}" "${C_BOLD}" "${C_NC}"
      confirm_action "Are you sure you want to continue" "${C_BOLD}" "${C_NC}" || return 1
    fi

  for mod in ${modules_list:-.}; do
    clean_mod="${mod#/}"; clean_mod="${clean_mod%/}"
    suffix="${clean_mod#.}"
    target_paths+="${target_paths:+ }${base_scan_dir}${suffix:+/$suffix}"
  done

  docker exec -it -u node "$node_container" sh -c "export TERM=xterm-256color && npx eslint $target_paths --fix";

  return 0
}