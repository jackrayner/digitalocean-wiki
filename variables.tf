variable "domain" {
  type        = string
  description = "Domain name."
}

variable "region" {
  type        = string
  description = "DigitalOcean region."
}

variable "ssh_ip_range" {
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
  description = "List of IP addresses or IP ranges for SSH access."
}

variable "droplet_name" {
  type        = string
  description = "Name for the wiki droplet."
}

variable "droplet_size" {
  type        = string
  description = "DigitalOcean droplet size."
}

variable "volume_size" {
  type        = number
  default     = 5
  description = "DigitalOcean volume size."
}

variable "ssh_keys" {
  type        = list(string)
  description = "List of SSH keys for droplet access."
}

variable "tags" {
  type        = list(string)
  description = "List of droplet tags."
}

variable "dns_ttl" {
  type        = number
  description = "TTL value for the DNS records. 0 value is useful when testing."
  default     = 3600
}