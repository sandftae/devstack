#!/bin/bash
# ============================================================
# CORE: bootstrap
# DESCRIPTION: executes load dependencies, files, and etc
# ============================================================

# bootstrap function configure the app before it is run
bootstrap() {
  local script_dir
  local project_dir
  local folder
  local target_path

  # assign vars for the manage context
  script_dir="${1}"
  project_dir="${2}"

  # ensure the script actually received the paths
  if [[ -z "$script_dir" || -z "$project_dir" ]]; then
    printf "[!] ERROR: bootstrap initiated without required paths.\n"
    return 1
  fi

  # ensure all scripts are executable
  find "$script_dir" -type f -name "*.sh" ! -executable -exec chmod +x {} + 2>/dev/null

  # ordered autoload
  folders=("config" "theme" "utils" "observers" "middleware" "commands" "etc")

  for folder in "${folders[@]}"; do
    target_path="$script_dir/$folder"

    if [[ -d "$target_path" ]]; then
      for plugin in $(find "$target_path" -type f \( -name "*.sh" -o -name "*.registry" \) | sort); do
        if [[ -f "$plugin" ]]; then
          # shellcheck source=/dev/null
          source "$plugin"
        fi
      done
    fi
  done

  return 0
}