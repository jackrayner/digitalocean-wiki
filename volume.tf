# Author: Jack Rayner <hello@jrayner.net>

resource "digitalocean_volume" "wiki_volume" {
  region                   = var.region
  name                     = "wiki-volume"
  size                     = var.volume_size
  initial_filesystem_label = "wiki-volume"
  initial_filesystem_type  = "ext4"
}

resource "digitalocean_volume_attachment" "wiki_volume" {
  droplet_id = digitalocean_droplet.wiki.id
  volume_id  = digitalocean_volume.wiki_volume.id
}