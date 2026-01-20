#!/bin/bash
# ============================================================
# UTILS: get_wish
# DESCRIPTION: Returns a random wish, with special logic for Fridays
# ============================================================

# get_wish function
get_wish() {
  local index
  local day_of_week
  day_of_week=$(date +%u)

  if [[ "$day_of_week" -eq 5 && ${#FRIDAY_WISHES[@]} -gt 0 ]]; then
    if [[ $(( RANDOM % 10 )) -lt 3 ]]; then
      index=$(( RANDOM % ${#FRIDAY_WISHES[@]} ))
      printf "%s" "${FRIDAY_WISHES[$index]}"
      return
    fi
  fi

  # fallback logic
  if [[ ${#PROJECT_WISHES[@]} -gt 0 ]]; then
    index=$(( RANDOM % ${#PROJECT_WISHES[@]} ))
    printf "%s" "${PROJECT_WISHES[$index]}"
  else
    printf "Keep up the great work!"
  fi
}