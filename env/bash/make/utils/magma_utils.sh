#!/bin/bash
# ============================================================
# UTILS: environment_checks
# DESCRIPTION: verifies docker status
# ============================================================

# prompts user before overwriting existing config
_confirm_environment_rebuild() {
  local compose_file="$1"
  local build_compose_file="$2"
  local build_compose_file_name="compose.env-build.yml"

  # check if the source build file exists
  if [[ ! -f "$build_compose_file" ]]; then
    printf "%b%b[!] CRITICAL:%b %bDEVSTACK%b environment compose file not detected!\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    printf "%bThe required configuration file is missing:%b\n" "${COLOR_YELLOW}" "${C_NC}"
    printf "\n\t%b%b./env/%s%b\n\n" "${COLOR_GREEN}" "${C_BOLD}" "$build_compose_file_name" "${C_NC}"
    printf "Clone the %b%s%b from the github!\n" "${C_BOLD}" "$build_compose_file_name" "${C_NC}"
    return 1
  fi

  # check if the base compose file
  if [[ -f "$compose_file" ]]; then
    printf "%b%b⚠ [!] WARNING:%b Docker compose file already exists:\n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}"
    printf "\n    %b%b./env/compose.yml%b\n\n" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}"
    printf " This action will stop the running docker environment,\n"
    printf " and %boverwrite/rebuild%b the existing compose file.\n" "${C_BOLD}" "${C_NC}"
    printf " It's generally a safe procedure, but it depends on your project.\n\n"

    confirm_action "Do you want to continue and run the builder?" || return 1
  fi

  return 0
}

# verifies compose file existence before commands
_check_docker_env_ready() {
  local file_path="env/compose.yml"
  local compose_file="${PROJECT_DIR}/$file_path"

  # check  if docker daemon is running
  if ! docker info >/dev/null 2>&1; then
    printf "\n%b%b[!] ERROR:%b the docker daemon is not running!\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
    printf "%bPlease start Docker desktop/service%b\n\n" "${COLOR_YELLOW}" "${C_NC}"
    return 1
  fi

  # check if the environment is built
  if [[ ! -f "$compose_file" ]]; then
    printf "\n%b[!] ERROR:%b %bDEVSTACK%b environment not detected.\n" "${COLOR_RED}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    printf "\n%bThe required configuration file is missing:%b\n" "${COLOR_YELLOW}" "${C_NC}"
    printf "   %b%s%b\n" "${C_BOLD}" "$file_path" "${C_NC}"
    printf "\n %bPlease run:%b %bmake magma-build%b first!\n\n" "${COLOR_CYAN}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  return 0
}