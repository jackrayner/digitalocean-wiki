#!/bin/sh

# Mount the volume
mkdir -p ${volume_mountpoint}
chown -R www-data:www-data ${volume_mountpoint}
mount -o discard,defaults /dev/disk/by-label/${volume_name} ${volume_mountpoint}
echo /dev/disk/by-label/${volume_name} ${volume_mountpoint} ext4 defaults,nofail,discard 0 0 | sudo tee -a /etc/fstab

# Install packages
apt-get update
apt-get install --assume-yes php php-xml apache2 libapache2-mod-php php-mbstring

# Enable apache rewrite module
a2enmod rewrite

ln -s /etc/apache2/conf-available/dokuwiki.conf /etc/apache2/conf-enabled/dokuwiki.conf
ln -s /etc/apache2/sites-available/010-dokuwiki.conf /etc/apache2/sites-enabled/010-dokuwiki.conf

# Download and extract DokuWiki
cd /tmp
wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-${dokuwiki_version}.tgz
tar xvf dokuwiki-${dokuwiki_version}.tgz
'cp' -af dokuwiki-${dokuwiki_version}/* ${volume_mountpoint}/
cd ${volume_mountpoint}
grep -Ev '^($|#)' data/deleted.files | xargs -n 1 rm -vf

# Restart apache
service apache2 restart