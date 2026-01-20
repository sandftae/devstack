#!/bin/bash
# ============================================================
# COMMAND: cmd_list
# DESCRIPTION: parses the Makefile to generate a command list
# ============================================================

# cmd_list function
cmd_list() {
  local name
  local padding
  local file="${1:-Makefile}"
  local name_raw="${COMPOSE_PROJECT_NAME:-Project}"

  name=$(echo "$name_raw" | tr '[:lower:]' '[:upper:]')

  list_note

  padding=$(grep -E '^[a-zA-Z0-9_-]+:.*##' "$file" | awk -F: '{print length($1)}' | sort -rn | head -1)
  padding=${padding:-20}
  padding=$((padding + 2))

  printf "\n%bMAINTENANCE COMMANDS FOR %s%b\n" "${COLOR_BLUE}" "$name" "${C_NC}"
  printf "Usage: make %b<command>%b\n" "${COLOR_CYAN}" "${C_NC}"
  printf "Help:\n"
  printf "  ➜ make %b<command>%b help\n" "${COLOR_CYAN}" "${C_NC}"
  printf "  ➜ make %b<command>%b h\n" "${COLOR_CYAN}" "${C_NC}"

  while IFS= read -r line || [[ -n "$line" ]]; do
    case "$line" in
      "# @@ "*) printf "\n%b%s%b\n" "${COLOR_YELLOW}" "${line#\# @@ }" "${C_NC}" ;;
      *:[[:blank:]]*"## "*)
        local target="${line%%:*}"
        local desc="${line##*## }"
        printf "  %b%-${padding}s%b %s\n" "${COLOR_CYAN}" "$target" "${C_NC}" "$desc" ;;
    esac
  done < "$file"
  printf "\n"

  return 0
}