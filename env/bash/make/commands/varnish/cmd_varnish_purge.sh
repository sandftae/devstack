#!/bin/bash
# ============================================================
# COMMAND: varnish_purge
# DESCRIPTION: purges the varnish cache without restarting
# ============================================================

# cmd_varnish_purge function
cmd_varnish_purge() {
  if spinner "Purging varnish cache"  _docker_compose exec varnish varnishadm "ban req.url ~ ."; then
    return 0
  fi

  printf "\n%b%b[!] ERROR%b: failed to purge Varnish cache. Is the %bservice running%b?\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
  return 1
}