provider "digitalocean" {
}

terraform {
  backend "s3" {}
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.sh.tpl")}"
  vars = {
    hostname          = var.droplet_name
    domain            = var.domain
    volume_name       = digitalocean_volume.wiki_volume.name
    volume_mountpoint = "/dokuwiki"
  }
}

resource "digitalocean_droplet" "wiki" {
  image     = "ubuntu-20-04-x64"
  name      = var.droplet_name
  region    = var.region
  size      = var.droplet_size
  ssh_keys  = var.ssh_keys
  tags      = var.tags
  user_data = data.template_file.user_data.rendered
}


output "fqdn" {
  value = [digitalocean_record.wiki.fqdn]
}