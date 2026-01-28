#!/bin/bash
# ============================================================
# UTILS: commerce_utils
# DESCRIPTION: shared logic for commerce manipulation scripts
# ============================================================

# validate _validate_env_vars installed/configured
_validate_env_vars() {
  local required_vars=("DOMAIN" "DB_NAME" "DB_USER" "DB_PASSWORD" "ADMIN_USER")
  local missing=()
  local var
  local m

  for var in "${required_vars[@]}"; do
    if [[ -z "${!var}" ]]; then
      missing+=("$var")
    fi
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    printf "\n%b%b[!] ERROR:%b\n" "${COLOR_RED}" "${C_BOLD}" "${C_NC}"
    printf "The following required variables are empty or missing:\n"
    for m in "${missing[@]}"; do
      printf "  - %s\n" "$m"
    done
    printf "\nPlease check your %b.docker.env%b or %b.commerce.env%b files.\n\n" "${C_BOLD}" "${C_NC}" "${C_BOLD}" "${C_NC}"
    return 1
  fi

  return 0
}

# get commerce install args
get_commerce_install_args() {
  printf "%s" "--base-url=https://${DOMAIN}/ \
    --base-url-secure=https://${DOMAIN}/ \
    --db-host=${DATABASE_SERVICE_NAME} \
    --db-name=${DB_NAME} \
    --db-user=${DB_USER} \
    --db-password=${DB_PASSWORD} \
    --backend-frontname=${BACKEND_FRONTNAME} \
    --admin-firstname=${ADMIN_FIRSTNAME} \
    --admin-lastname=${ADMIN_LASTNAME} \
    --admin-email=${ADMIN_EMAIL} \
    --admin-user=${ADMIN_USER} \
    --admin-password=${ADMIN_PASSWORD} \
    --language=${LANGUAGE} \
    --currency=${CURRENCY} \
    --timezone=${TIMEZONE} \
    --use-rewrites=${USE_REWRITE} \
    --search-engine=${SEARCH_ENGINE} \
    --opensearch-host=${OPENSEARCH_HOST} \
    --opensearch-port=${OPENSEARCH_PORT} \
    --opensearch-index-prefix=${OPENSEARCH_INDEX_PREFIX}"
}

# get commerce admin update args
get_commerce_set_admin_args() {
  printf "%s" "--admin-user=${ADMIN_USER} \
    --admin-password=${ADMIN_PASSWORD} \
    --admin-email=${ADMIN_EMAIL} \
    --admin-firstname=${ADMIN_FIRSTNAME} \
    --admin-lastname=${ADMIN_LASTNAME}"
}

# get commerce opensearch configuration commands
get_commerce_opensearch_args() {
  printf "%s" "bin/magento config:set catalog/search/engine opensearch && \
    bin/magento config:set catalog/search/opensearch_server_hostname ${OPENSEARCH_HOST:-opensearch} && \
    bin/magento config:set catalog/search/opensearch_server_port ${OPENSEARCH_PORT:-9200}"
}