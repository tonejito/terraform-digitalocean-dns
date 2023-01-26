#	locals.tf

locals {
  dotted_record_types = ["CNAME", "NS", "MX"]
  records_list = flatten([
    for domain, items in var.records_list : [
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
  domains_list = distinct([
    for item in local.records_list : item["domain"]
  ])
  records_csv = flatten([
    for input_file in var.records_csv : [
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
  domains_csv = distinct([
    for item in local.records_csv : item["domain"]
  ])
  records = flatten(distinct([local.records_list, local.records_csv]))
  domains = flatten(distinct([local.domains_list, local.domains_csv]))
}
