#!/bin/bash
# ============================================================
# COMMAND: metrics
# DESCRIPTION: show docker containers metrics using ctop
# ============================================================

# cmd_metrics function
cmd_metrics() {
  local sock_path="/var/run/docker.sock"

  if [ ! -r "$sock_path" ]; then
    printf "\n%b%b[!] ERROR:%b cannot read %s\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}" "$sock_path"
    printf "    Run %bmake chmod-sock%b to fix permissions\n\n" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  # execution
  if ! docker run --rm -ti \
      --name=devstack_metrics \
      --volume "${sock_path}:/var/run/docker.sock:ro" \
      quay.io/vektorlab/ctop; then

    printf "\n%b%b[!] ERROR:%b failed to launch metrics container\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
    return 1
  fi
}