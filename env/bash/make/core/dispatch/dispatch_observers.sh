#!/bin/bash
# ============================================================
# CORE/OBSERVER: dispatch_observers
# DESCRIPTION:call observers, like HELP, DRY_RUN, etc
# ============================================================

# dispatch_observers function
dispatch_observers() {
  local pool
  local observer
  local action="$1"
  local args=("${@:2}")

  # get observer pool
  pool=$(observer_get_all)

  # if it is empty just return
  [[ -z "$pool" ]] && return 0

  # walk through observer`s pool and call one-by-one
  # until one of them return 1 -> stop
  for observer in $pool; do
    if declare -f "$observer" > /dev/null; then
      if ! "$observer" "$action" "${args[@]}"; then
        return 1
      fi
    fi
  done

  return 0
}