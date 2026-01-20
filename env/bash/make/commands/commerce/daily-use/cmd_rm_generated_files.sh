#!/bin/bash
# ============================================================
# COMMAND: rm_generated_files
# DESCRIPTION: remove generated, cache, logs, and static folders
# ============================================================

# cmd_rm_generated_files function
cmd_rm_generated_files() {
  # execute
  if rm -rf \
      ./src/php-app/generated/ \
      ./src/php-app/var/cache/ \
      ./src/php-app/var/log/ \
      ./src/php-app/var/page_cache \
      ./src/php-app/pub/static/ \
      ./src/php-app/var/view_preprocessed/; then
      printf "%b%b[✓] Directories cleaned successfully%b\n" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}"
    return 0
  fi

  printf "%b%b[!] ERROR%b: failed to remove some directories. Check permissions.\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
  return 1
}