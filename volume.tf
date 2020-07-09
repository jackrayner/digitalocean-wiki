# Author: Jack Rayner <hello@jrayner.net>

resource "digitalocean_volume" "wiki_volume" {
  count = var.use_volume == "true" ? 1 : 0

  region                   = var.region
  name                     = "dokuwiki-${terraform.workspace}"
  size                     = var.volume_size
  initial_filesystem_label = "dokuwiki-${terraform.workspace}"
  initial_filesystem_type  = "ext4"
}

resource "digitalocean_volume_attachment" "wiki_volume" {
  count = var.use_volume == "true" ? 1 : 0

  droplet_id = digitalocean_droplet.wiki.id
  volume_id  = digitalocean_volume.wiki_volume[0].id
}