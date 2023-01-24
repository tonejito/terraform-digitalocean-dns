#	outputs.tf

output "domains" {
  description = "Domains created"
  value = digitalocean_domain.domains
}

output "records" {
  description = "Records created"
  value = digitalocean_record.records
}
