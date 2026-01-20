#!/bin/bash
# ============================================================
# UTILS: _get_cpu_cores
# DESCRIPTION: get cpu cores to speed-up phpcs
# ============================================================

# _get_cpu_cores function
_get_cpu_cores() {
  case "$(uname -s)" in
    Linux*)  nproc 2>/dev/null || echo 2 ;;
    Darwin*) sysctl -n hw.ncpu 2>/dev/null || echo 2 ;;
    CYGWIN*|MINGW*|MSYS*) echo "$NUMBER_OF_PROCESSORS" ;;
    *) echo 2 ;; # if not found/fallback
  esac
}