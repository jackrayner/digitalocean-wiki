#!/bin/sh
# Author: Jack Rayner <hello@jrayner.net>

# Mount the volume
mkdir -p ${volume_mountpoint}
mount -o discard,defaults /dev/disk/by-label/${volume_name} ${volume_mountpoint}
echo /dev/disk/by-label/${volume_name} ${volume_mountpoint} ext4 defaults,nofail,discard 0 0 | sudo tee -a /etc/fstab

# Install packages
add-apt-repository universe
apt-get update
apt-get install --assume-yes php php-xml apache2 libapache2-mod-php php-mbstring certbot python3-certbot-apache

# Enable apache rewrite module
a2enmod rewrite
a2dissite 000-default

ln -s /etc/apache2/conf-available/dokuwiki.conf /etc/apache2/conf-enabled/dokuwiki.conf
ln -s /etc/apache2/sites-available/010-dokuwiki.conf /etc/apache2/sites-enabled/010-dokuwiki.conf

# Download and extract DokuWiki
cd /tmp
wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-${dokuwiki_version}.tgz
tar xvf dokuwiki-${dokuwiki_version}.tgz
'cp' -af dokuwiki-${dokuwiki_version}/* ${volume_mountpoint}/
chown -R www-data:www-data ${volume_mountpoint}
cd ${volume_mountpoint}
grep -Ev '^($|#)' data/deleted.files | xargs -n 1 rm -vf

# Use certbot to generate certificates
certbot -n --apache --agree-tos --email ${certbot_email} --domains ${hostname}.${domain} --redirect

# Restart apache
service apache2 restart