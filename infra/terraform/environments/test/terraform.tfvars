# ---------------------------------------------------------------------------
# TEST environment variable values
# ---------------------------------------------------------------------------

azure_subscription_id = "" # ENTER_SUBSCRIPTION_ID_HERE
location              = "southcentralus"
environment           = "test"
project_name          = "csp"

# ── Network ──────────────────────────────────────────────────
deploy_vnet          = true
vnet_name            = "vnet-csp-test-scus"
vnet_address_space   = "10.20.0.0/16"
snet_app_name        = "snet-csp-app-test"
snet_app_prefix      = "10.20.1.0/24"
snet_data_name       = "snet-csp-data-test"
snet_data_prefix     = "10.20.3.0/24"

# ── Monitoring ───────────────────────────────────────────────
deploy_log_analytics = true
law_name             = "log-csp-test-scus"

# ── Security ─────────────────────────────────────────────────
deploy_key_vault     = true
kv_name              = "kv-csp-test-scus"

# ── Web ──────────────────────────────────────────────────────
deploy_web           = true
web_rg_name          = "rg-csp-web-test"
web_asp_name         = "asp-csp-web-test"
web_app_name         = "app-csp-web-test"
web_appi_name        = "appi-csp-web-test"
web_sku_name         = "B2"

# ── Data ─────────────────────────────────────────────────────
deploy_data          = true
data_rg_name         = "rg-csp-data-test"
data_psql_name       = "psql-csp-test"
data_redis_name      = "redis-csp-test"
data_storage_name    = "stcsptestscus001"
data_search_name     = "srch-csp-test"
psql_sku_name        = "GP_Standard_D2ds_v4"
psql_storage_mb      = 65536
redis_sku_name       = "Standard"
redis_capacity       = 1
storage_replication  = "GRS"
