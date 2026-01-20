#!/bin/bash
# ============================================================
# MIDDLEWARE: gatekeeper
# DESCRIPTION: blocks runtime commands if env is not built
# ============================================================

# gatekeeper function
gatekeeper() {
  local action="$1"
  local skip

  # commands that don't need a compose file
  local skip_commands=("magma_build" "list")

  # check if we should skip
  for skip in "${skip_commands[@]}"; do
    [[ "$action" == "$skip" ]] && return 0
  done

  # perform the environment check
  _check_docker_env_ready || return 1

  # load custom env files
  _load_env_files "$PROJECT_DIR"

  # validate critical variables are sourced
  _validate_env_vars || return 1
}