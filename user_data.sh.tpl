#!/bin/sh

# Mount the volume
mkdir -p ${volume_mountpoint}
mount -o discard,defaults /dev/disk/by-label/${volume_name} ${volume_mountpoint}
echo /dev/disk/by-label/${volume_name} ${volume_mountpoint} ext4 defaults,nofail,discard 0 0 | sudo tee -a /etc/fstab

yum makecache
yum install php httpd
systemctl enable httpd.service
echo LoadModule rewrite_module modules/mod_rewrite.so > /etc/httpd/conf.d/addModule-mod_rewrite.conf
systemctl restart httpd.service
yum install php-gd
semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/dokuwiki/conf(/.*)?"
semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/dokuwiki/data(/.*)?"
restorecon -Rv /var/www/html/dokuwiki/conf
restorecon -Rv /var/www/html/dokuwiki/data

setsebool -P httpd_can_network_connect on
setsebool -P httpd_can_sendmail on

semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/dokuwiki/lib/plugins(/.*)?"
restorecon -Rv /var/www/html/dokuwiki/lib/plugins
semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/dokuwiki/lib/tpl(/.*)?"
restorecon -Rv /var/www/html/dokuwiki/lib/tpl