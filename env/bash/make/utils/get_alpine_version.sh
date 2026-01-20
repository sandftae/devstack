#!/bin/bash
# ============================================================
# UTILS: get_alpine_version
# DESCRIPTION: returns the optimal alpine version for a given PHP version
# ============================================================

# get_alpine_version function
get_alpine_version() {
  local php_version="$1"
  local target_map="$PHP_ALPINE_MAP"

  for pair in $target_map; do
    if [[ "$pair" == "$php_version:"* ]]; then
      printf "%s" "${pair#*:}"
      return 0
    fi
  done

  # default fallback
  printf "edge"
}