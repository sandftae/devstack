#!/bin/bash
# ============================================================
# UTILS: _docker_compose
# DESCRIPTION: core wrapper for docker compose with auto-config
#              and refreshing functionality of the env files
# ============================================================

# _docker_compose function
_docker_compose() {
  local file
  local full_env_path
  local compose_args=()
  local default_file_args=("-f" "${PROJECT_DIR}/env/compose.yml")

  # check if a custom compose file was passed in the arguments
  for arg in "$@"; do
    if [[ "$arg" == "-f" ]] || [[ "$arg" == "--file" ]]; then
      default_file_args=()
    fi
  done

  # refresh variables from environment files
  for file in "${PROJECT_ENV_FILES[@]}"; do
    full_env_path="${PROJECT_DIR}/${file}"
    if [[ -f "$full_env_path" ]]; then
      compose_args+=("--env-file" "$full_env_path")
      set -a
      # shellcheck source=/dev/null
      source "$full_env_path"
      set +a
    fi
  done

  # execute
  env HOST_UID="$HOST_UID" HOST_GID="$HOST_GID" \
      docker compose "${compose_args[@]}" \
      "${default_file_args[@]}" \
      "$@"
}