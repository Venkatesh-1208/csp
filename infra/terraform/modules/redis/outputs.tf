output "id" { value = one(azurerm_redis_cache.this[*].id) }
output "hostname" { value = one(azurerm_redis_cache.this[*].hostname) }
output "primary_access_key" { value = one(azurerm_redis_cache.this[*].primary_access_key); sensitive = true }
