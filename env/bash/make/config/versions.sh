#!/bin/bash
# ============================================================
# CONFIG: non-static variables
# DESCRIPTION: this file contains vars that is changeable and
#              can not be treated as static
# ============================================================

# node-app configs
export NODE_DIST="https://nodejs.org/dist/index.json"
export NODE_SAFE_LIST="14 16 18 20 22 23"

# php-app configs
export PHP_DIST="https://www.php.net/releases/index.php?json"
export PHP_SAFE_LIST="8.4 8.3 8.2 8.1 7.4"
export PHP_ALPINE_MAP="8.4:3.21 8.3:3.20 8.2:3.19 8.1:3.18 8.0:3.15 7.4:3.15"

# php-app code standard
export PHP_CS_STANDARD="PSR12"