#	locals.tf

locals {
  # Some DNS record types require the data to have a dot at the very end
  dotted_record_types = ["CNAME", "NS", "MX"]
  # Read DNS records from a variable
  digitalocean_records_list = flatten([
    for domain, items in var.digitalocean_records_list : [
      for element in items : {
        domain = domain
        name   = element["name"]
        type   = element["type"]
        ttl    = tonumber(element["ttl"])
        # Add a dot at the end of the 'data' field if needed
        data = ((contains(local.dotted_record_types, element["type"])) && !(endswith(element["data"], "."))) ? format("%s.", element["data"]) : element["data"]
        # 'priority' is set only if type is 'MX'
        priority = (element["type"] == "MX") ? tonumber(element["priority"]) : null
      }
    ]
  ])
  # Parse DNS domain names from a variable
  digitalocean_domains_list = distinct([
    for item in local.digitalocean_records_list : item["domain"]
  ])
  # Read DNS records from CSV files
  digitalocean_records_csv = flatten([
    for input_file in var.digitalocean_records_csv : [
      for element in csvdecode(file(input_file)) : {
        domain = element["domain"]
        name   = element["name"]
        type   = element["type"]
        ttl    = tonumber(element["ttl"])
        # Add a dot at the end of the 'data' field if needed
        data = ((contains(local.dotted_record_types, element["type"])) && !(endswith(element["data"], "."))) ? format("%s.", element["data"]) : element["data"]
        # 'priority' is set only if type is 'MX'
        priority = (element["type"] == "MX") ? tonumber(element["priority"]) : null
      }
    ]
  ])
  # Parse DNS domain names from CSV files
  digitalocean_domains_csv = distinct([
    for item in local.digitalocean_records_csv : item["domain"]
  ])
  # Merged DNS domains and records from variables and CSV files
  digitalocean_records = flatten(distinct([local.digitalocean_records_list, local.digitalocean_records_csv]))
  digitalocean_domains = flatten(distinct([local.digitalocean_domains_list, local.digitalocean_domains_csv]))
}
