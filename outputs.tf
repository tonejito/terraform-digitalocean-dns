#	outputs.tf

output "domains" {
  description = "Domains created"
  value       = sort(distinct([for item in digitalocean_domain.domains : item.name]))
}

output "records" {
  description = "Records created"
  value       = sort(distinct([for item in digitalocean_record.records : format("%s:%s:%s.%s", item.domain, item.type, item.name, item.domain)]))
}
