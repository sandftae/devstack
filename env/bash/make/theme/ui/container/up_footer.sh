#!/bin/bash
# ============================================================
# UI: up_footer
# DESCRIPTION: print footer for up command
# ============================================================

# up_footer function
up_footer() {
  local wish
  wish=$(get_wish 2>/dev/null || echo "Have a productive session!")

  printf "\n%b ═════════════════════════════════════════════════════════════════════════%b\n" "${COLOR_BLUE}" "${C_NC}"
  printf "%b%b  [✓] SUCCESS:%b Dev environment is configured.\n" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}"
  printf "%b%b  [✓] SUCCESS:%b Service dashboard is ready.\n\n\n" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}"

  printf "  %b[➜] DOMAIN:%b  %bhttps://%s/%b\n" "${C_BOLD}" "${C_NC}" "${COLOR_CYAN}" "${DOMAIN}" "${C_NC}"
  printf "  %b[➜] BOARD:%b   %bhttps://%s/devstack/%b\n\n" "${C_BOLD}" "${C_NC}" "${COLOR_CYAN}" "${DOMAIN}" "${C_NC}"
  if ! is_deployed; then
    printf "  %b%b[➜] NOTE:%b %b   Please ensure the Adobe Commerce instance is installed,%b\n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "${C_NC}"
    printf "               %botherwise, you will encounter a%b %bsite is not reachable%b %berror.%b\n\n" "${COLOR_YELLOW}" "${C_NC}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "${C_NC}"
  fi
  printf "  %b[i] INFO:%b    %bRun make list to see more commands%b\n" "${C_BOLD}" "${C_NC}" "${COLOR_CYAN}" "${C_NC}"
  printf "  %b[i] INFO:%b    The dashboard displays all manageable services,\n" "${C_BOLD}" "${C_NC}"
  printf "               including those currently inactive or unselected.\n\n"

  printf "  %b%b[★] WISH:%b    %b%s%b\n" "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "${COLOR_YELLOW}" "$wish" "${C_NC}"
  printf "%b════════════════════════════════════════════════════════════════════════%b\n" "${COLOR_BLUE}" "${C_NC}"
}