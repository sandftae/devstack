#!/bin/bash
# ============================================================
# CONFIG: local
# DESCRIPTION: system identity configs
# ============================================================

# system identity vars that provides host user/group IDs for docker permissions
export HOST_UID="${HOST_UID:-$(id -u 2>/dev/null || echo 1000)}"
export HOST_GID="${HOST_GID:-$(id -g 2>/dev/null || echo 1000)}"
