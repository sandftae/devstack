#!/bin/bash
# ============================================================
# OBSERVER: help_observer
# DESCRIPTION: check if this is 'help' mode command call
# ============================================================

# help_observer function
help_observer() {
  local action="$1"

  if [[ "$HELP_MODE" == "true" ]]; then
    show_command_details "$action"

    # return 1 to stop dispatcher
    return 1
  fi

  return 0
}

# ------------------------------------------------------------
# self-register
# ------------------------------------------------------------
observer_register "help_observer"