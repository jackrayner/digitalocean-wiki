# Author: Jack Rayner <hello@jrayner.net>

variable "domain" {
  type        = string
  description = "Domain name."
}

variable "hostname" {
  type        = string
  default     = "wiki"
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

variable "droplet_size" {
  type        = string
  description = "Droplet size."
}

variable "droplet_image" {
  type        = string
  default     = "ubuntu-20-04-x64"
  description = "Droplet image."
}

variable "dokuwiki_version" {
  type        = string
  default     = "2018-04-22c"
  description = "Dokuwiki version."
}

variable "volume_size" {
  type        = number
  default     = 5
  description = "Droplet volume size."
}

variable "use_volume" {
  type        = string
  default     = "true"
  description = "Use a volume for storing the wiki data."
}

variable "admin_email" {
  type        = string
  description = "Apache admin email."
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