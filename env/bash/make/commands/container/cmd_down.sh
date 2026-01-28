#!/bin/bash
# ============================================================
# COMMAND: down
# DESCRIPTION: stops docker containers
# ============================================================

# cmd_down function
cmd_down() {
  # run the shutdown
  if spinner "Shutting down containers" _docker_compose down; then
    down_footer
    return 0
  fi

  return 1
}