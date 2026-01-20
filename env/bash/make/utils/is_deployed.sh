#!/bin/bash
# ============================================================
# UTILS: get_wish
# DESCRIPTION: well, lets try to check if the AC is deployed
#             already or not (do not judge, pls)
# ============================================================

# is_deployed function
is_deployed() {
  local file_sub_path="src/php-app/pub/index.php"
  if [ -f "$PROJECT_DIR/$file_sub_path" ]; then
    return 0
  fi

  return 1
}