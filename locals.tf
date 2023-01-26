#	locals.tf

locals {
  dotted_record_types = ["CNAME", "NS", "MX"]
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
  digitalocean_domains_list = distinct([
    for item in local.digitalocean_records_list : item["domain"]
  ])
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
  digitalocean_domains_csv = distinct([
    for item in local.digitalocean_records_csv : item["domain"]
  ])
  digitalocean_records = flatten(distinct([local.digitalocean_records_list, local.digitalocean_records_csv]))
  digitalocean_domains = flatten(distinct([local.digitalocean_domains_list, local.digitalocean_domains_csv]))
}
