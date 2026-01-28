#!/bin/bash
# ============================================================
# COMMAND: process_status_output
# DESCRIPTION: run docker ps [-a] with predefined table format
# ============================================================

# cmd_process_status_output function
cmd_process_status_output() {
  local input_flags="$1"
  local target_width=35
  local cid img status ports name networks
  local padding padding_len display_name color_code clean_line_len state_label id_color
  local docker_format="{{.ID}}|{{.Image}}|{{.Status}}|{{.Ports}}|{{.Names}}|{{.Networks}}"

  local d_args=()
  [[ -n "$input_flags" ]] && d_args+=("$input_flags")

  printf "${C_BOLD}%-13s %-35s %-30s %-45s %-35s %-s${C_NC}\n" \
   "ID" "IMAGE" "STATUS" "PORTS" "NAMES" "NETWORKS"
  printf "%.s-" {1..175}; echo

  docker ps "${d_args[@]}" --format "$docker_format" | while IFS="|" read -r cid img status ports name networks; do
    state_label=""
    color_code=""
    id_color=""

    [[ "$status" == *"Exited"* ]] && id_color="${COLOR_BLUE}${C_BOLD}"

    case "$name" in
     *"varnish"*)
       state_label=" (SILENCED)"
       color_code="${COLOR_YELLOW}${C_BOLD}"
       if [[ "$DEVELOPER_MODE_BYPASS_VARNISH" == "false" ]]; then
         state_label=" (UNSILENCED)"
         color_code="${COLOR_GREEN}${C_BOLD}"
       fi ;;
    esac

    clean_line_len=$((${#name} + ${#state_label}))
    padding_len=$((target_width - clean_line_len))
    padding=""
    [[ $padding_len -gt 0 ]] && padding=$(printf "%${padding_len}s" " ")

    display_name="${name}${color_code}${state_label}${C_NC}${padding}"

    printf "%b%-13s${C_NC} %-35.35s %-25.25s %-45.45s %b %-s\n" \
     "$id_color" "$cid" "$img" "$status" "$ports" "$display_name" "$networks"
  done
}