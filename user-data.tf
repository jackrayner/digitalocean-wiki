# Author: Jack Rayner <hello@jrayner.net>

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data/user_data.sh.tpl")}"
  vars = {
    hostname          = var.droplet_name
    domain            = var.domain
    dokuwiki_version  = var.dokuwiki_version
    volume_name       = digitalocean_volume.wiki_volume.name
    certbot_email     = var.admin_email
    volume_mountpoint = "/var/www/dokuwiki"
  }
}

data "template_file" "apache_site_conf" {
  template = "${file("${path.module}/user-data/010-dokuwiki.conf.tpl")}"
  vars = {
    server_name        = var.droplet_name
    document_root      = "/var/www/dokuwiki"
    server_admin_email = var.admin_email
  }
}

data "template_file" "write_apache_site_conf" {
  template = "${file("${path.module}/user-data/write-file.tpl")}"
  vars = {
    owner   = "root"
    group   = "root"
    mode    = "0644"
    path    = "/etc/apache2/conf-available/dokuwiki.conf"
    content = base64encode("${data.template_file.apache_site_conf.rendered}")
  }
}

data "template_file" "write_apache_conf" {
  template = "${file("${path.module}/user-data/write-file.tpl")}"
  vars = {
    owner   = "root"
    group   = "root"
    mode    = "0644"
    path    = "/etc/apache2/conf-available/dokuwiki.conf"
    content = filebase64("${path.module}/user-data/dokuwiki.conf")
  }
}

data "cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.write_apache_conf.rendered
    merge_type   = "dict(recurse_array, no_replace) + list(append)"
  }
  part {
    content_type = "text/cloud-config"
    content      = data.template_file.write_apache_site_conf.rendered
    merge_type   = "dict(recurse_array, no_replace) + list(append)"
  }
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.user_data.rendered
    merge_type   = "dict(recurse_array, no_replace) + list(append)"
  }
}