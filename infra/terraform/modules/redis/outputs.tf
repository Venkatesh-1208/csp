output "id" { value = try(azurerm_redis_cache.this[0].id, null) }
output "hostname" { value = try(azurerm_redis_cache.this[0].hostname, null) }
output "primary_access_key" { value = try(azurerm_redis_cache.this[0].primary_access_key, null); sensitive = true }
