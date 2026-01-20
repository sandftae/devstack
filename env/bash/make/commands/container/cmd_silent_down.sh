#!/bin/bash
# ============================================================
# COMMAND: not specified
# DESCRIPTION: prevent stop with no info
# ============================================================

# cmd_silent_down function
cmd_silent_down() {
  # run the shutdown
  _check_env_state || return 1
  cmd_down || return 1
}

# check that all required files and vars exits
_check_env_state() {
  local default_compose_file="${PROJECT_DIR}/env/compose.yml"

  if [[ ! -f "$default_compose_file" ]]; then
    return 1
  fi

  for file in "${PROJECT_ENV_FILES[@]}"; do
    if [[ ! -f "${PROJECT_DIR}/${file}" ]]; then
      return 1
    fi
  done

  return 0
}