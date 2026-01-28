#!/bin/bash
# ============================================================
# UTILS: update_env_var
# DESCRIPTION: updates a variable in a file using cross-platform sed
# USAGE: update_env_var "KEY" "VALUE" "FILEPATH"
# ============================================================

# update_env_var function
update_env_var() {
  local key="$1"
  local value="$2"
  local file="$3"
  local escaped_value

  # check if the file exists
  if [[ ! -f "$file" ]]; then
    return 1
  fi

  # escape any forward slashes in the value to prevent sed delimiter errors
  escaped_value=$(printf '%s' "$value" | sed 's/[\/&]/\\&/g')

  # determine sed flavor and update the variable
  if sed --version >/dev/null 2>&1; then
    # GNU sed
    sed -i "s/^${key}=.*/${key}=${escaped_value}/g" "$file"
  else
    # BSD sed (macOS)
    sed -i '' "s/^${key}=.*/${key}=${escaped_value}/g" "$file"
  fi
}