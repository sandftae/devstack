#!/bin/bash
# ============================================================
# COMMAND: remove_volumes
# DESCRIPTION: removes all docker volumes related to the project
# ============================================================

# cmd_remove_volumes function
cmd_remove_volumes() {
  local project_prefix="${COMPOSE_PROJECT_NAME:-devstack}"

  confirm_action "Are you sure you want to delete all project volumes" || return 1

  # down containers
  cmd_down

  # remove volumes
  spinner "Removing $project_prefix volumes"  _docker_compose down -v --remove-orphans || return 1

}