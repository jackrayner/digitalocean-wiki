provider "digitalocean" {
}

terraform {
  backend "s3" {}
}

resource "digitalocean_droplet" "wiki" {
  image     = var.droplet_image
  name      = var.droplet_name
  region    = var.region
  size      = var.droplet_size
  ssh_keys  = var.ssh_keys
  tags      = var.tags
  user_data = data.cloudinit_config.user_data.rendered
}

output "fqdn" {
  value = "ssh -o \"UserKnownHostsFile /dev/null\" root@${digitalocean_record.wiki.fqdn}"
}