#	variables.tf

variable "digitalocean_token" {
  description = "Digital Ocean API token"
  type        = string
}

variable "digitalocean_records_list" {
  description = "DNS record specification"
  type        = map(list(map(string)))
  default     = {}
}

variable "digitalocean_records_csv" {
  description = "List of CSV files with DNS records"
  type        = list(string)
  default     = []
}
