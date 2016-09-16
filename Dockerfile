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
        openssl \
        php-apc \
        php5-apcu \
        php5-cli \
        php5-curl \
        php5-fpm \
        php5-gd \
        php5-gmp \
        php5-imagick \
        php5-intl \
        php5-ldap \
        php5-mcrypt \
        php5-mysqlnd \
        php5-pgsql \
        php5-sqlite \
        smbclient \
        sudo \
	wget

