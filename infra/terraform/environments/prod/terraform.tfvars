# ---------------------------------------------------------------------------
# PROD environment variable values
# ---------------------------------------------------------------------------

azure_subscription_id = "" # ENTER_SUBSCRIPTION_ID_HERE
location              = "southcentralus"
environment           = "prod"
project_name          = "csp"

# ── Network ──────────────────────────────────────────────────
deploy_vnet          = true
vnet_name            = "vnet-csp-prod-scus"
vnet_address_space   = "10.30.0.0/16"
snet_app_name        = "snet-csp-app-prod"
snet_app_prefix      = "10.30.1.0/24"
snet_data_name       = "snet-csp-data-prod"
snet_data_prefix     = "10.30.3.0/24"

# ── Monitoring ───────────────────────────────────────────────
deploy_log_analytics = true
law_name             = "log-csp-prod-scus"

# ── Security ─────────────────────────────────────────────────
deploy_key_vault     = true
kv_name              = "kv-csp-prod-scus"

# ── Web ──────────────────────────────────────────────────────
deploy_web           = true
web_rg_name          = "rg-csp-web-prod"
web_asp_name         = "asp-csp-web-prod"
web_app_name         = "app-csp-web-prod"
web_appi_name        = "appi-csp-web-prod"
web_sku_name         = "P1v3"

# ── Data ─────────────────────────────────────────────────────
deploy_data          = true
data_rg_name         = "rg-csp-data-prod"
data_psql_name       = "psql-csp-prod"
data_redis_name      = "redis-csp-prod"
data_storage_name    = "stcspprodscus001"
data_search_name     = "srch-csp-prod"
psql_sku_name        = "GP_Standard_D4ds_v4"
psql_storage_mb      = 131072
redis_sku_name       = "Premium"
redis_capacity       = 1
storage_replication  = "GZRS"
