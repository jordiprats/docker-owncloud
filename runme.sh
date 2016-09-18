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

setup_cron()
{
	if [ ! -f "/tmp/cron.setup.ok" ];
	then
		cat <<EOF >> /var/spool/cron/crontabs/root
# m   h  dom mon dow   command
*/15 * * * * sudo -u www-data php -f /var/www/owncloud/cron.php > /dev/null 2>&1
EOF

		touch /tmp/cron.setup.ok
	fi
}

setup_ssl()
{
	mkdir -p /var/www/ssl
	if [ ! -e "/var/www/ssl/dhparam.pem" ];
	then
		if [ "$OWNCLOOUD_GENERATE_DH" -eq 1 ];
		then
			openssl dhparam -out /var/www/ssl/dhparam.pem 4096
		else
			#eliminar dh config nginx
			sed '/ssl_dhparam/d' -i /etc/nginx/conf.d/owncloud-nginx-vhost.conf
		fi
	fi

	if [ ! -e "/etc/letsencrypt/live/${OWNCLOUD_SERVERNAME}/privkey.pem" ];
	then
		cat <<EOF > /etc/owncloud.conf
rsa-key-size = 4096
email = example@example.com
domains = $OWNCLOUD_SERVERNAME
webroot-path = /var/www/owncloud
EOF

		/bin/bash /opt/letsencrypt-nginx-autorenew/renew.cert.sh /etc/owncloud.conf

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
	setup_cron

	setup_ssl
fi

#aqui daemon

/etc/init.d/php7.0-fpm start
/etc/init.d/nginx start
/usr/sbin/cron -f &

#initial scan

su www-data -c 'php /var/www/owncloud/console.php files:scan --all'

while true;
do
	sleep 10m;
done
