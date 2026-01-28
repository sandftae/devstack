#!/bin/bash
# ============================================================
# CONFIG: database
# DESCRIPTION: database dumps folders an baned list
# ============================================================

# database related config
export IMPORT_DIR="env/dumps/import"
export EXPORT_DIR="env/dumps/export"
export SEED_DIR="env/dumps/seed"

# baned list
export PROTECTED_DBS=("mysql" "information_schema" "performance_schema" "sys")