resource "digitalocean_record" "wiki" {
  domain = var.domain
  name   = var.droplet_name
  type   = "A"
  value  = digitalocean_droplet.wiki.ipv4_address
  ttl    = var.dns_ttl
}

resource "digitalocean_firewall" "wiki" {
  name = "wiki-firewall"

  droplet_ids = [digitalocean_droplet.wiki.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.ssh_ip_range
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
