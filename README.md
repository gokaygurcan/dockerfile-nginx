# NGINX

[![Docker Build Status](https://img.shields.io/docker/build/gokaygurcan/nginx.svg?style=for-the-badge&logo=docker&colorA=22b8eb)](https://hub.docker.com/r/gokaygurcan/nginx/)
[![Travis CI](https://img.shields.io/travis/gokaygurcan/dockerfile-nginx.svg?style=for-the-badge&logo=travis&colorA=39a85b)](https://travis-ci.org/gokaygurcan/dockerfile-nginx)

## Environment variables

| Name                 | Value                  |
| -------------------- | ---------------------- |
| USR_SRC              | /usr/src               |
| USR_SRC_NGINX        | /usr/src/nginx         |
| USR_SRC_NGINX_MODS   | /usr/src/nginx/modules |
| NGINX_VERSION        | 1.15.2                 |
| NJS_VERSION          | 0.2.2                  |
| CACHE_PURGE_VERSION  | 2.3                    |
| HEADERS_MORE_VERSION | 0.33                   |
| OPENSSL_VERSION      | 1.1.1-pre8             |
| PAGESPEED_VERSION    | 1.13.35.2              |
| PAGESPEED_RELEASE    | stable                 |

---

To pull the image

```bash
docker pull gokaygurcan/nginx
```

To run an NGINX container

```bash
docker run --rm -p 80:80 -p 443:443 gokaygurcan/nginx
```
