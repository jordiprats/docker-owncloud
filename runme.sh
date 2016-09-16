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

	mkdir -p /usr/local/src/owncloud

	tar xf /usr/local/src/owncloud.tb2 -C /usr/local/src/owncloud
}

if [ -e /tmp/owncloudinstalled ];
then
	echo "everything, or at least a single file, looks good :D"
else
	install_owncloud
fi

#aqui daemon
