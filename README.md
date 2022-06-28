# NGINX

![Deploy to Docker Hub](https://github.com/gokaygurcan/dockerfile-nginx/workflows/Deploy%20to%20Docker%20Hub/badge.svg?branch=master)

<h2>Environment variables</h2>

| Variable             | Path                   |
| -------------------- | ---------------------- |
| USR_SRC              | /usr/src               |
| USR_SRC_NGINX        | /usr/src/nginx         |
| USR_SRC_NGINX_MODS   | /usr/src/nginx/modules |

| Variable             | Version                |
| -------------------- | ---------------------- |
| NGINX_VERSION        | 1.23.0                 |
| OPENSSL_VERSION      | 1.1.1n                 |
| PAGESPEED_VERSION    | 1.13.35.2              |
| LIBMAXMINDDB_VERSION | 1.6.0                  |

<h2>Additional packages</h2>

- libbrotli-dev
- libpcre3
- libpcre3-dev
- mmdb-bin
- uuid-dev
- zlibc
- zlib1g
- zlib1g-dev

<h2>Volumes</h2>

| Path             | Description                                                                            |
| ---------------- | -------------------------------------------------------------------------------------- |
| /etc/nginx       | NGINX configurations                                                                   |
| /var/log/nginx   | NGINX logs                                                                             |
| /var/www         | Default www folder                                                                     |
| /etc/letsencrypt | Let's Encrypt files (see [certbot](https://github.com/gokaygurcan/dockerfile-certbot)) |
| /usr/share/GeoIP | GeoIP database folder (see below)                                                      |

<h2>Ports</h2>

| Port | Process | TCP/UDP |
| ---- | ------- | ------- |
| 80   | NGINX   | TCP     |
| 443  | NGINX   | TCP     |

<h2>CMD</h2>

```bash
sudo nginx -g daemon off;
```

<h2>Usage</h2>

To pull the image

```bash
docker pull gokaygurcan/nginx
```

To run an NGINX container

```bash
# clone this repository
git clone https://github.com/gokaygurcan/dockerfile-nginx.git

# cd into it
cd dockerfile-nginx

# run nginx with the default configurations
docker run --rm -d --name nginx -p 80:80 -p 443:443 \
  -v `pwd`/docker/etc/nginx:/etc/nginx \
  gokaygurcan/nginx

# see if cURL returns anything good
curl -i http://localhost
```

<h2>GeoIP</h2>

To use GeoIP, you need to download City and/or Country databases from MaxMind. The best way to do it is to use their Docker container.

```bash
# create a volume for persistency
docker volume create usr-share-geoip

# download geoip databases
docker run --rm --name geoipupdate \
  -v usr-share-geoip:/usr/share/GeoIP \
  -e GEOIPUPDATE_FREQUENCY=0 \
  -e GEOIPUPDATE_ACCOUNT_ID='<your account id>' \
  -e GEOIPUPDATE_LICENSE_KEY='<your license key>' \
  -e GEOIPUPDATE_EDITION_IDS='GeoLite2-City GeoLite2-Country' \
  maxmindinc/geoipupdate

# you can start nginx with this additional volume now
docker run --rm -d --name nginx -p 80:80 -p 443:443 \
  -v `pwd`/docker/etc/nginx:/etc/nginx \
  -v usr-share-geoip:/usr/share/GeoIP \
  gokaygurcan/nginx
```
