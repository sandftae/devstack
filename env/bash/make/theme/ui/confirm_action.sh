# ============================================================
# UTILS: confirm_action
# DESCRIPTION: standard yes/no prompt with color interpretation
# ============================================================

# confirm_action function
confirm_action() {
  local message="$1"
  local confirmation

  printf "%b%b[?]%b %b %b%b(y/n)%b: " \
      "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" \
      "$message" \
      "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}"

  read -r confirmation

  if [[ ! "$confirmation" =~ ^[Yy]$ ]]; then
    printf "\n%b%b[CANCELLED]%b: no further steps executed\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  return 0
}