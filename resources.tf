#	resources.tf

resource "digitalocean_domain" "domains" {
  for_each = toset(local.domains)
  name     = each.value
}

resource "digitalocean_record" "records" {
  for_each = {
    for item in local.records : "${item.type}:${item.name}.${item.domain}" => item
  }

  domain   = each.value.domain
  name     = each.value.name
  type     = each.value.type
  value    = each.value.data
  ttl      = each.value.ttl
  priority = each.value.priority

  # Domain needs to be created before records
  depends_on = [digitalocean_domain.domains]
}
