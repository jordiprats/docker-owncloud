#!/bin/bash

install_owncloud()
{
	# https://download.owncloud.org/community/owncloud-9.1.0.zip
	# OWNCLOUD_VERSION="9.1.0"

	wget https://download.owncloud.org/community/owncloud-${OWNCLOUD_VERSION}.tar.bz2 -O /usr/local/src/owncloud.tb2

	if [ ! -e "/usr/local/src/owncloud.tb2" ];
	then
		echo "error downloading owncloud"
		exit 1
	fi

	mkdir -p /var/www

	tar xf /usr/local/src/owncloud.tb2 -C /var/www
}

install_letsencrypt()
{
	if [ ! -d "/opt/letsencrypt" ];
	then
		cd /opt/
		git clone https://github.com/letsencrypt/letsencrypt
	fi
}

install_autorenew_letsencrypt()
{
	if [ ! -d "/opt/letsencrypt-nginx-autorenew" ];
	then
		cd /opt
		git clone https://github.com/jordiprats/letsencrypt-nginx-autorenew.git
	fi
}

phpfpm_conf()
{
	if [ -f "/etc/php/7.0/fpm/php-fpm.conf" ];
	then
		sed 's@error_log = .*@error_log = /dev/null@g' -i /etc/php/7.0/fpm/php-fpm.conf
	fi
}

if [ -e /tmp/owncloudinstalled ];
then
	echo "everything, or at least a single file, is in place - looks good :D"
else
	install_owncloud
	install_letsencrypt
	install_autorenew_letsencrypt

	phpfpm_conf
fi

#aqui daemon

/usr/sbin/cron -f &
/etc/init.d/php5-fpm start
/etc/init.d/nginx start
