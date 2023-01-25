#	locals.tf

locals {
  records_list = flatten([
    for domain, items in var.records_list : [
      for element in items : {
        domain = domain
        name   = element["name"]
        type   = element["type"]
        data   = element["data"]
        ttl    = element["ttl"]
        # priority is set only if type is 'MX'
        priority = element["type"] == "MX" ? element["priority"] : 0
      }
    ]
  ])
  domains_list = distinct([
    for item in local.records_list : item["domain"]
  ])
  records_csv = csvdecode(file(var.records_csv))
  domains_csv = distinct([
    for item in local.records_csv : item["domain"]
  ])
  records = flatten([local.records_list, local.records_csv])
  domains = flatten([local.domains_list, local.domains_csv])
}
