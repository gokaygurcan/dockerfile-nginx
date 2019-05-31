# NGINX

[![Docker Build Status](https://img.shields.io/docker/build/gokaygurcan/nginx.svg?style=for-the-badge&logo=docker&colorA=22b8eb)](https://hub.docker.com/r/gokaygurcan/nginx/) [![Travis CI](https://img.shields.io/travis/gokaygurcan/dockerfile-nginx.svg?style=for-the-badge&logo=travis&colorA=39a85b)](https://travis-ci.org/gokaygurcan/dockerfile-nginx) [![MicroBadger](https://img.shields.io/microbadger/image-size/gokaygurcan/nginx.svg?style=for-the-badge&colorA=337ab7&colorB=252528)](https://microbadger.com/images/gokaygurcan/nginx)

<h2>Environment variables</h2>

| Variable           | Path                   |
| ------------------ | ---------------------- |
| USR_SRC            | /usr/src               |
| USR_SRC_NGINX      | /usr/src/nginx         |
| USR_SRC_NGINX_MODS | /usr/src/nginx/modules |

| Variable           | Version                |
| ------------------ | ---------------------- |
| NGINX_VERSION      | 1.17.0                 |
| OPENSSL_VERSION    | 1.1.1c                 |
| PAGESPEED_VERSION  | 1.13.35.2              |
| GEOIP2_VERSION     | 1.3.2                  |

<h2>Additional packages</h2>

- aria2
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
git clone https://github.com/gokaygurcan/dockerfile-nginx.git
docker run --rm -d --name nginx -p 80:80 -p 443:443 -v `pwd`/dockerfile-nginx/docker/etc/nginx:/etc/nginx gokaygurcan/nginx
curl -i http://localhost
```

---

[![Buy me a coffee](https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-2.svg)](https://www.buymeacoffee.com/gokaygurcan)
