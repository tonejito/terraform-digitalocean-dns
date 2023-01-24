<!--
	= ^ . ^ =
-->

# `terraform-digitalocean-dns`

Create DNS zones and records on [Digital Ocean DNS][digitalocean-dns].

- **Author**: Andrés Hernández (`tonejito`)
- **Version**: 1.0

## Module Sources

Include this module in another terraform implementation

```
module "digitalocean-dns" {
  source = "git::https://github.com/tonejito/terraform-digitalocean-dns.git"
}
```

## Authentication

You need to create a [_Personal Access Token_ on the Digital Ocean control panel][digitalocean-api-token], and provide the token to the `digitalocean_token` variable.

## Required modules

- [`digitalocean/digitalocean`][digitalocean-terraform] v2.25

## Input variables

Set the variables in the `terraform.tfvars` file (see the `terraform.tfvars.example` file for more info)

- Digital Ocean API authentication token

```
digitalocean_token = "dop_v1_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

- Name of the CSV file with the DNS records, default name is "records.csv"

```
records_csv = "payload.csv"
```

- The structure of the `records.csv` file is the following (see the `records.csv.example` file for more info)

```
domain,name,type,ttl,data,priority
example.net,@,A,60,127.0.0.1,0
example.net,@,AAAA,60,::1,0
example.net,www,CNAME,60,example.local.,0
example.net,@,MX,60,example.com.,1
example.net,@,TXT,60,Insert coin,0
```

- List of DNS records

```
records_list = {
  "example.com" = [
    {
      name = "@"
      type = "A"
      data = "127.0.0.1"
      ttl  = 60
    },
    {
      name = "@"
      type = "AAAA"
      data = "::1"
      ttl  = 60
    },
    {
      name = "www"
      type = "CNAME"
      data = "example.com."
      ttl  = 60
    },
    {
      name     = "@"
      type     = "MX"
      data     = "example.com."
      ttl      = 60
      priority = 1
    },
    {
      name = "@"
      type = "TXT"
      data = "Insert coin"
      ttl  = 60
    },
  ],
}
```

## Module outputs

- List of domains created ([`digitalocean_domain`][digitalocean-terraform-domain])
- List of records created ([`digitalocean_record`][digitalocean-terraform-record])

--------------------------------------------------------------------------------

[digitalocean-api-token]: https://docs.digitalocean.com/reference/api/create-personal-access-token/
[digitalocean-terraform]: https://registry.terraform.io/providers/digitalocean/digitalocean/2.25.2

[digitalocean-terraform-domain]: https://registry.terraform.io/providers/digitalocean/digitalocean/2.25.2/docs/resources/domain
[digitalocean-terraform-record]: https://registry.terraform.io/providers/digitalocean/digitalocean/2.25.2/docs/resources/record

[digitalocean-dns]: https://docs.digitalocean.com/products/networking/dns/
[digitalocean-dns-tutorial]: https://www.digitalocean.com/community/tutorial_series/an-introduction-to-managing-dns
