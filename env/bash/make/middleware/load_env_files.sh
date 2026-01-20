#!/bin/bash
# ============================================================
# MIDDLEWARE: load_env_files
# DESCRIPTION: it loads env files
# ============================================================

# this function loads custom env files
_load_env_files() {
  local file
  local full_path
  local env_path="$1"

  # loop through the defined files in the PROJECT_ENV_FILES array
  for file in "${PROJECT_ENV_FILES[@]}"; do
    full_path="$env_path/$file"
    # if file does not exist, show error and exit the function
    [[ ! -f "$full_path" ]] && printf "%b%b[!] ERROR%b: missing %s\n" "${COLOR_RED}"  "${C_BOLD}" "${C_NC}" "$full_path" && return 1

    set -a
    # shellcheck source=/dev/null
    source "$full_path"
    set +a
  done

  return 0
}