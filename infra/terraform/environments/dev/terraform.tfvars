# ---------------------------------------------------------------------------
# DEV environment variable values
# ---------------------------------------------------------------------------

azure_subscription_id = "" # ENTER_SUBSCRIPTION_ID_HERE
azure_tenant_id       = "" # ENTER_TENANT_ID_HERE
azure_client_id       = "" # ENTER_CLIENT_ID_HERE
azure_client_secret   = "" # ENTER_CLIENT_SECRET_HERE
location              = "southcentralus"
environment           = "dev"
project_name          = "csp"

# ── Network ──────────────────────────────────────────────────
deploy_vnet          = true
vnet_name            = "vnet-csp-dev-scus"
vnet_address_space   = "10.10.0.0/16"
snet_app_name        = "snet-csp-app-dev"
snet_app_prefix      = "10.10.1.0/24"
snet_data_name       = "snet-csp-data-dev"
snet_data_prefix     = "10.10.3.0/24"

# ── Monitoring ───────────────────────────────────────────────
deploy_log_analytics = true
law_name             = "log-csp-dev-scus"

# ── Security ─────────────────────────────────────────────────
deploy_key_vault     = true
kv_name              = "kv-csp-dev-scus"

# ── Web ──────────────────────────────────────────────────────
deploy_web           = true
web_asp_name         = "asp-csp-web-dev"
web_app_name         = "app-csp-web-dev"
web_appi_name        = "appi-csp-web-dev"
web_sku_name         = "B1"

# ── Data ─────────────────────────────────────────────────────
deploy_data          = true
data_psql_name       = "psql-csp-dev"
data_redis_name      = "redis-csp-dev"
data_storage_name    = "stcspdevscus001"
data_search_name     = "srch-csp-dev"
psql_sku_name        = "B_Standard_B1ms"
psql_storage_mb      = 32768
redis_sku_name       = "Basic"
redis_capacity       = 0
storage_replication  = "LRS"
