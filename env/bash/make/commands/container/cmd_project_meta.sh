#!/bin/bash
# ============================================================
# COMMAND: project_meta
# DESCRIPTION: view project meta data like php meta, node meta,
#              composer meta, commerce meta, and etc
# ============================================================

# cmd_project_meta function
cmd_project_meta() {
  local tmp_dir
  local spinner_status
  local php_service

  php_service="${PHP_APP_SERVICE_NAME:-php-app}"

  check_service_status "$php_service" || return 1

  tmp_dir=$(mktemp -d 2>/dev/null || mktemp -d -t 'metatmp') || return 1

  spinner "Loading environment metadata" __run_parallel_meta "$tmp_dir"

  spinner_status=$?
  if [ "$spinner_status" -eq 0 ]; then
    [ -s "$tmp_dir/comm" ] && printf "\n" && cat "$tmp_dir/comm" && printf "\n"
    [ -s "$tmp_dir/php" ]  && cat "$tmp_dir/php"  && printf "\n"

    # node container may be not installed, so ti should be managed
    if [ -f "$tmp_dir/node_success" ] && [ -s "$tmp_dir/node" ]; then
      cat "$tmp_dir/node"
    fi
  fi

  rm -rf "$tmp_dir"
  return "$spinner_status"
}

# helper function
__run_parallel_meta() {
  local dir="$1"

  # background tasks
  cmd_commerce_version > "$dir/comm" 2>&1 &
  cmd_php_version      > "$dir/php"  2>&1 &

  # run node and create a success flag only if exit code is 0
  { cmd_node_version > "$dir/node" 2>&1 && touch "$dir/node_success"; } &

  wait
  return 0
}