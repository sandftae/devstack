#!/bin/bash
# ============================================================
# COMMAND: remove_networks
# DESCRIPTION: removes project related networks
# ============================================================

# cmd_remove_networks function
cmd_remove_networks() {
    local nets_list
    local existing_nets

    # filter the global STATIC_NETS to find only those that actually exist
    existing_nets=$(docker network ls --format '{{.Name}}' | grep -E "^($(echo "$STATIC_NETS" | tr ' ' '|'))$")
    if [[ -z "$existing_nets" ]]; then
        printf "%bNo networks found to remove%b\n" "${COLOR_GREEN}" "${C_NC}"
        return 0
    fi

    # flatten for the spinner
    nets_list=$(echo "$existing_nets" | tr '\n' ' ')

    # remove containers first
    cmd_remove_containers || return 1

    # execute
    spinner "Removing networks" sh -c "docker network rm $nets_list" || return 1
}