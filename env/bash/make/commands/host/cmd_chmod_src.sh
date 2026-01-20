#!/bin/bash
# ============================================================
# COMMAND: chmod_src
# DESCRIPTION: chmod 777 on src folder recursively
# ============================================================

# cmd_chmod_src function
cmd_chmod_src() {
  local target_dir="src/"

  # check if the directory exists
  if [ ! -d "$target_dir" ]; then
    printf "\n%b%b[!] ERROR:%b directory '%s' not found.\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "$target_dir"
    printf "    Ensure you are running this from the project root.\n\n"
    return 1
  fi

  # execute chmod
  if sudo chmod -R 777 "$target_dir"; then
    printf "%b%b[✓] Source folder permissions updated%b\n" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}"
    return 0
  fi

  printf "\n%b%b[!] ERROR%b: failed to update source folder permissions\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
  return 1
}