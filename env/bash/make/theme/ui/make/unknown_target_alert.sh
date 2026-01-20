#!/bin/bash
# ============================================================
# UI: unknown_target_alert
# DESCRIPTION: renders the 'bad guy' error message
# ============================================================

# unknown_target_alert
unknown_target_alert() {
  local suggestion
  local target="$1"
  local suggestions="$2"

  printf "\n%b%b  WHOA THERE, REBEL!%b\n" "${COLOR_BLUE}" "${C_BOLD}" "${C_NC}"
  printf "  ------------------------------------------------------------\n"
  printf "  Command: %b'%s'%b\n" "${COLOR_RED}" "$target" "${C_NC}"

  if [[ -n "$suggestions" ]]; then
    printf "  %b➜ Did you mean one of these?%b\n" "${COLOR_CYAN}" "${C_NC}"
    for suggestion in $suggestions; do
      if [[ -n "$suggestion" ]]; then
        printf "      • %bmake %s%b\n" "${C_BOLD}" "$suggestion" "${C_NC}"
      fi
    done
  fi

  printf "\n  %b%b➜ Try this:%b run %bmake list%b to see the all commands.\n" "${COLOR_CYAN}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
  printf "  ------------------------------------------------------------\n\n"
}