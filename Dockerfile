FROM ubuntu:16.04
MAINTAINER Jordi Prats

# https://github.com/owncloud/core/wiki/Maintenance-and-Release-Schedule
# https://download.owncloud.org/community/owncloud-9.1.0.zip
ENV OWNCLOUD_VERSION="9.1.0"
ENV OWNCLOUD_SERVERNAME="localhost"

RUN DEBIAN_FRONTEND=noninteractive ;\
    apt-get update && \
    apt-get install --assume-yes \
        bzip2 \
        cron \
        nginx \
	mariadb-server \
        openssl \
        php-apcu \
        php7.0-cli \
        php7.0-curl \
        php7.0-fpm \
        php7.0-gd \
        php7.0-gmp \
        php-imagick \
        php7.0-intl \
        php7.0-ldap \
        php7.0-mcrypt \
        php7.0-mysqlnd \
        php7.0-pgsql \
        php7.0-sqlite \
        smbclient \
        sudo \
	git \
	wget

COPY owncloud.asc /usr/local/src/
COPY runme.sh /usr/local/bin/
COPY owncloud-nginx-vhost.conf /etc/nginx/conf.d/

CMD /bin/bash /usr/local/bin/runme.sh

VOLUME ["/var/lib/mysql"]
