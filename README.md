# docker-owncloud

owncloud container for docker based on:

* Ubuntu 16.04

using:

* nginx
* php-fpm
* MariaDB

Features:

* hardened TLS configuration
* **OPTIONALLY** generates unique Diffie-Hellman parameters (OWNCLOOUD_GENERATE_DH - default: true)

## example build

```
docker build -t eyp/docker .
```

## example run

create container for persistent storage

```
docker run --name persistend-owncloud -i -t eyp/owncloud /bin/true
```

run owncloud instance

```
docker run -d -e OWNCLOUD_VERSION="9.1.0" -e OWNCLOUD_SERVERNAME="localhost" -e OWNCLOUD_SSL_EMAIL="example@example.com" --volumes-from persistend-owncloud -p 9090:80 -p 9442:443 -t eyp/owncloud
```

