#	variables.tf

variable "digitalocean_token" {
  type = string
}

variable "records_list" {
  description = "DNS records"
  type        = map(list(map(string)))
  default     = {}
}

variable "records_csv" {
  description = "CSV file with DNS records"
  type        = string
  default     = "records.csv"
}
