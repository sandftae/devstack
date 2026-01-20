#!/bin/bash
# ============================================================
# OBSERVER/REGISTRY: registry
# DESCRIPTION: private state management for the observer pool
# ============================================================

# declare an array if not exists yet
if [ -z "${_OBSERVER_POOL+x}" ]; then
    _OBSERVER_POOL=()
fi

# observer_register adds a function name to the registry
observer_register() {
  local observer_name="$1"
  _OBSERVER_POOL+=("$observer_name")
}

# observer_get_all  returns the array elements for the dispatcher
observer_get_all() {
  printf "%s " "${_OBSERVER_POOL[@]}"
}

# observer_get_by_index return name by index given
observer_get_by_index() {
  local index="$1"
  echo "${_OBSERVER_POOL[$index]}"
}