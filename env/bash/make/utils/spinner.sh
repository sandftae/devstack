#!/bin/bash
# ============================================================
# UTILS: spinner
# DESCRIPTION: Executes a command with Braille animation
# ============================================================

# spinner function
spinner() {
  # braille symbols
  local SYMBOLS=( "⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏" )
  local MSG="$1"
  local TEMP_LOG
  shift # remove message, leaving only the command + args in "$@"

  local LOG_DIR="${LOG_DIR_NAME:-./log/devstack}"
  local LOG_FILE="$LOG_DIR/$ERROR_LOG_NAME"
  mkdir -p "$LOG_DIR"

  tput civis
  TEMP_LOG=$(mktemp)
  local LAST_LINE=""

  # execute the background command
  "$@" > "$TEMP_LOG" 2>&1 &
  local PID=$!

  # initial UI positioning: move up one line to start the loop
  printf "\n\033[1A"

  # animation loop
  while kill -0 "$PID" 2>/dev/null; do
    for s in "${SYMBOLS[@]}"; do
      if ! kill -0 "$PID" 2>/dev/null; then break; fi

      printf "\033[1G\033[2K%b%s%b %b..." "${COLOR_GREEN}" "$s" "${C_NC}" "$MSG"

      # live status line
      local CURRENT_LINE
      CURRENT_LINE=$(tail -n 1 "$TEMP_LOG" 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g' | cut -c1-75)

      if [[ -n "$CURRENT_LINE" && "$CURRENT_LINE" != "$LAST_LINE" ]]; then
          printf "\n\033[1G\033[2K%b└─ %s%b\033[1A" "${C_BOLD}" "$CURRENT_LINE" "${C_NC}"
          LAST_LINE="$CURRENT_LINE"
      else
          printf "\r"
      fi
      sleep 0.1
    done
  done

  wait "$PID"
  local EXIT_STATUS=$?

  # clean up the UI lines before showing final result
  printf "\033[1G\033[2K\n\033[2K\033[1A\r"
  tput cnorm # ensure cursor is restored

  if [ $EXIT_STATUS -eq 0 ]; then
    printf "%b✔%b %b %bsuccessful!%b\n" "${COLOR_GREEN}" "${C_NC}" "$MSG" "${COLOR_GREEN}" "${C_NC}"
    rm -f "$TEMP_LOG"
    return 0
  else
    # log error to file without ANSI color codes
    {
        printf "DATE: %s\n" "$(date '+%Y-%m-%d %H:%M:%S')"
        printf "STEP: %s\n" "$MSG"
        printf "ERRORS:\n"
        sed 's/\x1b\[[0-9;]*m//g' "$TEMP_LOG"
        printf "\n\n"
    } >> "$LOG_FILE"

    printf "%b✘%b %b %bfailed!%b\n" "${COLOR_RED}" "${C_NC}" "$MSG" "${COLOR_RED}" "${C_NC}"
    printf "➜ %bCheck: %s%b\n\n" "${COLOR_YELLOW}" "$LOG_FILE" "${C_NC}"
    rm -f "$TEMP_LOG"
    return 1
  fi
}