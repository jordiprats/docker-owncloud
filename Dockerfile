FROM ubuntu:16.04

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

