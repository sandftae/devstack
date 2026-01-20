#!/bin/bash
# ============================================================
# UTILS: build_container_name
# DESCRIPTION: build container name based on name given
# ============================================================


# standardized container name resolution
build_container_name_by_service() {
  local service_name="$1"
  local project_name="${COMPOSE_PROJECT_NAME}"

  # check service name has been given
  if [[ -z "$service_name" ]]; then
    printf "\n%b%b[!] ERROR:%b no %bservice name%b has been provided!\n" \
    "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  # check COMPOSE_PROJECT_NAME var has been set
  if [[ -z "$project_name" ]]; then
    printf "\n%b%b[!] ERROR:%b no %bCOMPOSE_PROJECT_NAME%b variable has %bbeen set%b!\n" \
    "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  printf "%s_%s" "$project_name" "$service_name"
}
