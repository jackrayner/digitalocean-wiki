#!/bin/sh
# Author: Jack Rayner <hello@jrayner.net>

# Create the document root
mkdir -p ${document_root}

%{ if use_volume == "true" }
# Mount the volume
mount -o discard,defaults /dev/disk/by-label/${volume_name} ${document_root}
echo /dev/disk/by-label/${volume_name} ${document_root} ext4 defaults,nofail,discard 0 0 | sudo tee -a /etc/fstab
%{ endif }

# Install packages
add-apt-repository universe
apt-get update
apt-get install --assume-yes php php-xml apache2 libapache2-mod-php php-mbstring certbot python3-certbot-apache

# Apache configuration
a2enmod rewrite
a2enconf dokuwiki
a2dissite 000-default
a2ensite 010-dokuwiki

# Download and extract DokuWiki
cd /tmp
wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-${dokuwiki_version}.tgz
tar xvf dokuwiki-${dokuwiki_version}.tgz
'cp' -af dokuwiki-${dokuwiki_version}/* ${document_root}/
chown -R www-data:www-data ${document_root}
rm -rf dokuwiki-${dokuwiki_version}.tgz dokuwiki-${dokuwiki_version}/
cd ${document_root}
grep -Ev '^($|#)' data/deleted.files | xargs -n 1 rm -vf

# Use certbot to generate certificates
certbot -n --apache --agree-tos --email ${certbot_email} --domains ${hostname}.${domain} --redirect

# Restart apache
service apache2 restart