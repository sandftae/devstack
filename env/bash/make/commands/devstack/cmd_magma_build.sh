#!/bin/bash
# ============================================================
# COMMAND: magma_build
# DESCRIPTION: rebuilds the environment
# ============================================================

# cmd_magma_build function
cmd_magma_build() {
  local compose_file
  local compose_args=()
  local build_compose_file
  local network="environment_builder_network"

  compose_file="${PROJECT_DIR}/env/compose.yml"
  build_compose_file="${PROJECT_DIR}/env/compose.env-build.yml"

  # safety check
  _confirm_environment_rebuild "$compose_file" "$build_compose_file" || return 1

  # down containers
  cmd_silent_down

  # build env files flag arg
  for file in "${PROJECT_ENV_FILES[@]}"; do
    local full_env_path="$PROJECT_DIR/$file"
    if [[ -f "$full_env_path" ]]; then
      compose_args+=("--env-file" "$full_env_path")
    fi
  done

  # execute
  _docker_compose -f "$build_compose_file" run --rm \
     -e COLUMNS="$(tput cols)" \
     -e LINES="$(tput lines)" \
     magma bash launcher || return 1

  # up fresh env
  if _docker_compose -f "$compose_file" up -d --build; then
    docker network rm "$network" >/dev/null 2>&1 || true
    up_footer
    return 0
  fi

  return 1
}