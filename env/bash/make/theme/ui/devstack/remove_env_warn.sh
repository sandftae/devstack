#!/bin/bash
# ============================================================
# UI: remove_env_warn
# DESCRIPTION: renders warnings before confirmation
# ============================================================

# remove_env_warn function
remove_env_warn() {
  local project_prefix="$1"

   printf "%b%b[!] DANGER:%b\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
   printf "This will permanently delete:\n"
   printf "  - %bcontainers%b\n" "${C_BOLD}" "${C_NC}"
   printf "  - %bimages%b\n" "${C_BOLD}" "${C_NC}"
   printf "  - %bvolumes%b\n" "${C_BOLD}" "${C_NC}"
   printf "  - %bnetworks%b\n" "${C_BOLD}" "${C_NC}"
   printf "for the %b%s%b environment\n\n" "${C_BOLD}" "$project_prefix" "${C_NC}"
}