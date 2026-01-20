#!/bin/bash
# ============================================================
# UI: down_footer
# DESCRIPTION: prints messages using theme constants
# ============================================================

# down_footer function
down_footer() {
  printf "\n%b%b[AMAZING DAY]%b You did a great job today! Have a great evening with your loved ones!\n" "${COLOR_GREEN}" "${C_BOLD}"  "${C_NC}"
  printf "%b%b[GRATITUDE]%b Grateful, Blessed, and highly Favored!\n\n" "${COLOR_GREEN}" "${C_BOLD}" "${C_NC}"
}