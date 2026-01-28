#!/bin/bash
# ============================================================
# COMMAND: commerce_version
# DESCRIPTION: parses composer.json without sed for speed
# ============================================================

# cmd_commerce_version
cmd_commerce_version() {
  local line
  local domain
  local version_val
  local edition_name
  local composer_file
  local db_name

  composer_file="${PROJECT_DIR}/src/php-app/composer.json"

  if [[ ! -f "$composer_file" ]]; then
    printf "\n%b%b[!] NOTICE:%b Adobe Commerce is not installed yet.\n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}"
    printf "Run %bmake create-ee%b or %bmake create-ce%b to begin.\n\n" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  domain="${DOMAIN:-localhost [not specified]}"
  db_name="${DB_NAME:-not specified}"

  # extract edition name
  line=$(grep '"name":' "$composer_file" | head -1)
  edition_name="${line#*\"name\": \"}"
  edition_name="${edition_name%\"*}"

  # extract version
  line=$(grep '"version":' "$composer_file" | head -1)
  version_val="${line#*\"version\": \"}"
  version_val="${version_val%\"*}"

  [[ -z "$edition_name" || "$edition_name" == *":"* ]] && edition_name="Unknown"
  [[ -z "$version_val" || "$version_val" == *":"* ]] && version_val="Not specified"

  # print
  printf "%bCOMMERCE metadata:%b\n" "${C_BOLD}" "${C_NC}"
  printf "  %b%-10s%b %s\n" "${COLOR_GREEN}" "edition:" "${C_NC}" "$edition_name"
  printf "  %b%-10s%b %s\n" "${COLOR_GREEN}" "version:" "${C_NC}" "$version_val"
  printf "  %b%-10s%b %s\n" "${COLOR_GREEN}" "domain:" "${C_NC}" "$domain"
  printf "  %b%-10s%b %b%b%s%b\n" "${COLOR_GREEN}" "database:" "${C_NC}" "${COLOR_YELLOW}" "${C_BOLD}" "$db_name" "${C_NC}"

  return 0
}
