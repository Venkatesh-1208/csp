output "resource_group_name" { value = module.resource_group.name }
output "vnet_id" { value = module.network.vnet_id }
output "web_app_hostname" { value = module.web_app.default_hostname }
output "postgresql_fqdn" { value = module.postgresql.fqdn }
