# NGINX

![Deploy to Docker Hub](https://github.com/gokaygurcan/dockerfile-nginx/workflows/Deploy%20to%20Docker%20Hub/badge.svg?branch=master) ![MicroBadger](https://img.shields.io/microbadger/image-size/gokaygurcan/nginx.svg?style=flat&colorA=337ab7&colorB=252528) 

<h2>Environment variables</h2>

| Variable             | Path                   |
| -------------------- | ---------------------- |
| USR_SRC              | /usr/src               |
| USR_SRC_NGINX        | /usr/src/nginx         |
| USR_SRC_NGINX_MODS   | /usr/src/nginx/modules |

| Variable             | Version                |
| -------------------- | ---------------------- |
| NGINX_VERSION        | 1.19.2                 |
| OPENSSL_VERSION      | 1.1.1g                 |
| PAGESPEED_VERSION    | 1.13.35.2              |
| LIBMAXMINDDB_VERSION | 1.4.3                  |

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
