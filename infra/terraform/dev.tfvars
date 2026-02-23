# ---------------------------------------------------------------------------
# DEV environment variable values
# Sensitive values (credentials) are NOT stored here – pass them via
# environment variables or GitHub Actions secrets at plan/apply time:
#
#   TF_VAR_azure_tenant_id       = ${{ secrets.AZURE_TENANT_ID }}
#   TF_VAR_azure_subscription_id = ${{ secrets.AZURE_SUBSCRIPTION_ID }}
#   TF_VAR_azure_client_id       = ${{ secrets.AZURE_CLIENT_ID }}
#   TF_VAR_azure_client_secret   = ${{ secrets.AZURE_CLIENT_SECRET }}
# ---------------------------------------------------------------------------

environment  = "dev"
project_name = "csp"
location     = "southcentralus"
deploy_web   = true
deploy_data  = true
