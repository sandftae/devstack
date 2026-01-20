cmd_remove_images() {
  local project_prefix="${COMPOSE_PROJECT_NAME:-devstack}"

  confirm_action "Are you sure you want to delete all project images" || return 1

  # down containers
  cmd_down

  # remove project env
  spinner "Removing $project_prefix environment"  _docker_compose down --rmi all --remove-orphans || return 1
}