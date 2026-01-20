#!/bin/bash
# ============================================================
# COMMAND: restart
# DESCRIPTION: performs a down/up cycle
# ============================================================

# cmd_restart function
cmd_restart() {
  # start shutdown phase
  if ! spinner "Shutting down containers" _docker_compose down; then
    return 1
  fi
  down_footer
  # end shutdown phase

  # start startup phase
  up_header
  if ! spinner "Launching fresh containers" _docker_compose up -d; then
    return 1
  fi
  up_footer
  # end startup phase
}