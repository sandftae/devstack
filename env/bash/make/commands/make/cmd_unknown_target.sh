#!/bin/bash
# ============================================================
# COMMAND: unknown_target
# DESCRIPTION: Intercepts typos and suggests valid targets
# ============================================================

# cmd_unknown_target function
cmd_unknown_target() {
  local target="$1"
  local all_targets
  local broad_matches
  local suggestions=""
  local full_input="$*"

  # no actions for line with these symbols
  if [[ "$target" == *"://"* || "$target" == *"/"* ]]; then
    return 0
  fi

  # gather all valid .PHONY targets/commands
  all_targets=$(grep "^.PHONY:" Makefile | sed 's/.PHONY://g' | tr ' ' '\n' | \
                grep -vE '^(unknown_target|.DEFAULT|all|\.|#|$$)' | sort -u)

  # check if any word in the input is a valid command
  # if yes, we assume the engine/observer already handled it or will handle it
  for word in $full_input; do
    if echo "$all_targets" | grep -qw "$word"; then
      return 0
    fi
  done

  # matching logic for typos (like 'make lits')
  if [[ -n "$target" ]]; then
    broad_matches=$(echo "$all_targets" | grep -iE "^${target:0:3}")
    if [[ ${#target} -ge 5 ]]; then
      local search_term="${target:3}"
      suggestions=$(echo "$broad_matches" | grep -iE "$search_term")
    fi

    if [[ -z "$suggestions" ]]; then
      local start="${target:0:2}"
      local end="${target: -2}"
      suggestions=$(echo "$all_targets" | grep -iE "^$start" | grep -iE "$end")
    fi

    if [[ -z "$suggestions" ]]; then
      suggestions=$(echo "$all_targets" | grep -iE "^${target:0:2}")
    fi
  fi

  local formatted_suggestions
  formatted_suggestions=$(echo "$suggestions" | tr '\n' ' ' | xargs)

  # show ui output
  unknown_target_alert "$target" "$formatted_suggestions"
  return 0
}
