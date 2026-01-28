#!/bin/bash
# ============================================================
# UTILS: get_param
# DESCRIPTION: Resolves specific key values or returns all args.
#              It allows the customer to miss order params the
#              the customer uses, like make-cmd arg1=test arg2=test2
#              is equivalent make-cmd arg2=test2 arg1=test
# ============================================================

# get_param function
get_param() {
  local target_key="$1"
  shift

  # if no key is requested, return the raw list of all arguments
  if [[ -z "$target_key" ]]; then
    echo "$@"
    return 0
  fi

  # if a key is requested, find and return only that value
  for arg in "$@"; do
    case "$arg" in
      "${target_key}="*)
        echo "${arg#*=}"
        return 0
        ;;
    esac
  done

  return 1 # key not found, otherwise
}