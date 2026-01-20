#!/bin/bash
# ============================================================
# COMMAND: remove_env
# DESCRIPTION: Completely wipes the project environment
# ============================================================

# cmd_remove_env function
cmd_remove_env() {
  local project_prefix="${COMPOSE_PROJECT_NAME:-devstack}"

  # confirmation and action
  remove_env_warn "$project_prefix"
  confirm_action "Are you sure you want to destroy the environment?" || return 1

  # down containers
  cmd_down

  # remove project env
  spinner "Removing $project_prefix environment"  _docker_compose down -v --rmi all --remove-orphans || return 1
}