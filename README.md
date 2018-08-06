# NGINX

[![Docker Build Status](https://img.shields.io/docker/build/gokaygurcan/nginx.svg?style=for-the-badge&logo=docker&colorA=22b8eb)](https://hub.docker.com/r/gokaygurcan/nginx/)
[![Travis CI](https://img.shields.io/travis/gokaygurcan/dockerfile-nginx.svg?style=for-the-badge&logo=travis&colorA=39a85b)](https://travis-ci.org/gokaygurcan/dockerfile-nginx)

---

## Arguments

| Name                 | Value     |
| -------------------- | --------- |
| nginx_version        | 1.15.2    |
| njs_version          | 0.2.2     |
| cache_purge_version  | 2.3       |
| headers_more_version | 0.33      |
| openssl_version      | 1.0.2o    |
| pagespeed_version    | 1.13.35.2 |
| pagespeed_release    | stable    |

## Environment variables

| Name                 | Value                   |
| -------------------- | ----------------------- |
| USR_SRC              | /usr/src                |
| USR_SRC_NGINX        | /usr/src/nginx          |
| USR_SRC_NGINX_MODS   | /usr/src/nginx/modules  |
| NGINX_VERSION        | ${nginx_version}        |
| NJS_VERSION          | ${njs_version}          |
| CACHE_PURGE_VERSION  | ${cache_purge_version}  |
| HEADERS_MORE_VERSION | ${headers_more_version} |
| OPENSSL_VERSION      | ${openssl_version}      |
| PAGESPEED_VERSION    | ${pagespeed_version}    |
| PAGESPEED_RELEASE    | ${pagespeed_release}    |

---

To pull the image

```bash
docker pull gokaygurcan/nginx
```

To run an NGINX container

```bash
docker run --rm -p 80:80 gokaygurcan/nginx
```
