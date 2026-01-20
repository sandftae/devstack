  #!/bin/bash
  # ============================================================
  # COMMAND: unknown_target
  # DESCRIPTION: handles calls to undefined Makefile targets
  # ============================================================

  # unknown_target function
  cmd_unknown_target() {
    local target="$1"
    local full_input="$*"
    local suggestions=""
    local all_targets
    local broad_matches

    all_targets=$(grep "^.PHONY:" Makefile | sed 's/.PHONY://g' | tr ' ' '\n' | \
                  grep -vE '^(unknown_target|.DEFAULT|all|\.|#|$$)' | sort -u)

    # iterate through input words to check if any valid target exists
    # it prevent case like 'make list test_param_ot_args'
    for word in $full_input; do
      if echo "$all_targets" | grep -qw "$word"; then
        return 0
      fi
    done

    # matching logic (only if no valid command was found)
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