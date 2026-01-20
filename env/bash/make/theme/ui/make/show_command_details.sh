show_command_details() {
  local cmd="$1"
  local clean_cmd="${cmd//-/_}"

  local var_name="cmd_${clean_cmd}_name"
  local var_desc="cmd_${clean_cmd}_desc"
  local var_note="cmd_${clean_cmd}_note"
  local var_usage="cmd_${clean_cmd}_usage"
  local var_group="cmd_${clean_cmd}_group"

  local name="${!var_name}"
  local desc="${!var_desc}"
  local note="${!var_note}"
  local group="${!var_group}"
  local usage_list="${!var_usage}"

  # set default values if not specified
  local display_desc="${desc:-details not specified yet in commands.registry}"
  local display_usage="${usage_list:-make ${name:-$cmd}}"

  # trimming
  display_usage="${display_usage#"${display_usage%%[![:space:]]*}"}"
  display_usage="${display_usage%"${display_usage##*[![:space:]]}"}"

  # UI printing
  printf "  %b%bCOMMAND:%b %b%b%b\n" \
    "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${name:-$cmd}" "${C_NC}"
  printf "  %b%bGROUP:%b   %b%b%b\n" \
    "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${group:-GENERAL}" "${C_NC}"

  printf "  ------------------------------------------------------------\n"
  printf "  %b%bDESCRIPTION: %b%b%b\n" \
    "${COLOR_YELLOW}" "${C_BOLD}" "${COLOR_CYAN}" "$display_desc" "${C_NC}"

  printf "  %b%bUSAGE%b:       %b%b%b\n" \
    "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "$display_usage" "${C_NC}"

  [[ -n "$note" ]] && printf "\n  %b%bNOTE:%b        %b\n" \
      "${COLOR_YELLOW}" "${C_BOLD}" "${C_NC}" "$note"
  printf "  ------------------------------------------------------------\n"
}