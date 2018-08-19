# gokaygurcan/dockerfile-nginx

FROM gokaygurcan/ubuntu:latest

LABEL maintainer="Gökay Gürcan <docker@gokaygurcan.com>"

USER root

ENV DEBIAN_FRONTEND="noninteractive" \
    USR_SRC=/usr/src \
    USR_SRC_NGINX=/usr/src/nginx \
    USR_SRC_NGINX_MODS=/usr/src/nginx/modules \
    NGINX_VERSION=1.15.2 \
    NJS_VERSION=0.2.2 \
    CACHE_PURGE_VERSION=2.3 \
    HEADERS_MORE_VERSION=0.33 \
    OPENSSL_VERSION=1.1.1-pre8 \
    PAGESPEED_VERSION=1.13.35.2 \
    PAGESPEED_RELEASE=stable

# install dependencies
RUN set -ex && \
    sudo apt-get update -qq && \
    sudo apt-get upgrade -yqq && \
    sudo apt-get install -yqq --no-install-recommends --no-install-suggests \
    apt-transport-https \
    apt-utils \
    aria2 \
    autotools-dev \
    autoconf \
    build-essential \
    ca-certificates \
    file \
    gcc \
    gzip \
    libmaxminddb0 \
    libmaxminddb-dev \
    libpcre3 \
    libpcre3-dev \
    make \
    mmdb-bin \
    tar \
    unzip \
    uuid-dev \
    wget \
    zlibc \
    zlib1g \
    zlib1g-dev

# download and compile geoip: geolite2-city.mmdb, geolite2-country.mmdb, geolite-city.dat and geolite-country.dat
WORKDIR ${USR_SRC}
RUN wget -q http://geolite.maxmind.com/download/geoip/api/c/GeoIP.tar.gz && \
    tar -zxf GeoIP.tar.gz && \
    rm GeoIP.tar.gz && \
    mv GeoIP-* GeoIP && \
    cd GeoIP && \
    sh ./configure && \
    make && \
    make install && \
    echo '/usr/local/lib' | tee -a /etc/ld.so.conf.d/geoip.conf && \
    ldconfig && \
    mkdir -p /usr/local/share/GeoIP && \
    cd /usr/local/share/GeoIP && \
    rm -rf ./* && \
    wget -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz && \
    gzip -d GeoIP.dat.gz && \
    mv GeoIP.dat geolite-country.dat && \
    wget -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && \
    gzip -d GeoLiteCity.dat.gz && \
    mv GeoLiteCity.dat geolite-city.dat && \
    wget -q http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.tar.gz && \
    tar -xzf GeoLite2-Country.tar.gz && \
    rm GeoLite2-Country.tar.gz && \
    mv GeoLite2-Country_*/GeoLite2-Country.mmdb geolite2-country.mmdb && \
    rm -rf GeoLite2-Country_* && \
    wget -q http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz && \
    tar -xzf GeoLite2-City.tar.gz && \
    rm GeoLite2-City.tar.gz && \
    mv GeoLite2-City_*/GeoLite2-City.mmdb geolite2-city.mmdb && \
    rm -rf GeoLite2-City_*

# download nginx
WORKDIR ${USR_SRC}
RUN wget -q https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -xzf nginx-${NGINX_VERSION}.tar.gz && \
    rm nginx-${NGINX_VERSION}.tar.gz && \
    mv nginx-* nginx && \
    mkdir -p ${USR_SRC_NGINX_MODS}

# download openssl, njx, cache purge, test cookie, sysguard, nchan, pagespeed and psol
WORKDIR ${USR_SRC_NGINX_MODS}
RUN wget -q https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz && \
    tar -xzf openssl-${OPENSSL_VERSION}.tar.gz && \
    rm openssl-${OPENSSL_VERSION}.tar.gz && \
    mv openssl-* openssl && \
    wget -q https://github.com/nginx/njs/archive/${NJS_VERSION}.tar.gz && \
    tar -xzf ${NJS_VERSION}.tar.gz && \
    rm ${NJS_VERSION}.tar.gz && \
    mv njs-* njs && \
    wget -q https://github.com/openresty/headers-more-nginx-module/archive/v${HEADERS_MORE_VERSION}.tar.gz && \
    tar -xzf v${HEADERS_MORE_VERSION}.tar.gz && \
    rm v${HEADERS_MORE_VERSION}.tar.gz && \
    mv headers-more-nginx-module-* headers-more && \
    wget -q https://github.com/FRiCKLE/ngx_cache_purge/archive/${CACHE_PURGE_VERSION}.tar.gz && \
    tar -xzf ${CACHE_PURGE_VERSION}.tar.gz && \
    rm ${CACHE_PURGE_VERSION}.tar.gz && \
    mv ngx_cache_purge-* cache-purge && \
    aria2c -q https://github.com/kyprizel/testcookie-nginx-module/tarball/master && \
    tar -xzf kyprizel-testcookie-nginx-module-*.tar.gz && \
    rm kyprizel-testcookie-nginx-module-*.tar.gz && \
    mv kyprizel-testcookie-nginx-module-* testcookie && \
    aria2c -q https://github.com/vozlt/nginx-module-sysguard/tarball/master && \
    tar -xzf vozlt-nginx-module-sysguard-*.tar.gz && \
    rm vozlt-nginx-module-sysguard-*.tar.gz && \
    mv vozlt-nginx-module-sysguard-* sysguard && \
    aria2c -q https://github.com/slact/nchan/tarball/master && \
    tar -xzf slact-nchan-*.tar.gz && \
    rm slact-nchan-*.tar.gz && \
    mv slact-nchan-* nchan && \
    wget -q https://github.com/apache/incubator-pagespeed-ngx/archive/v${PAGESPEED_VERSION}-${PAGESPEED_RELEASE}.tar.gz && \
    tar -xzf v${PAGESPEED_VERSION}-${PAGESPEED_RELEASE}.tar.gz && \
    rm v${PAGESPEED_VERSION}-${PAGESPEED_RELEASE}.tar.gz && \
    mv *-pagespeed-* pagespeed && \
    cd ${USR_SRC_NGINX_MODS}/pagespeed && \
    wget -q https://dl.google.com/dl/page-speed/psol/${PAGESPEED_VERSION}-x64.tar.gz && \
    tar -xzf ${PAGESPEED_VERSION}-x64.tar.gz && \
    rm ${PAGESPEED_VERSION}-x64.tar.gz && \
    mkdir -p /var/ngx_pagespeed_cache

# compile nginx
WORKDIR ${USR_SRC_NGINX}
RUN sh ./configure \
    --conf-path=/etc/nginx/nginx.conf \
    --sbin-path=/usr/sbin/nginx \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --with-http_addition_module \
    --with-file-aio \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_geoip_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-openssl=${USR_SRC_NGINX_MODS}/openssl \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    --without-http_fastcgi_module \
    --without-http_uwsgi_module \
    --without-http_scgi_module \
    --add-module=${USR_SRC_NGINX_MODS}/njs/nginx \
    --add-module=${USR_SRC_NGINX_MODS}/pagespeed \
    --add-module=${USR_SRC_NGINX_MODS}/headers-more \
    --add-module=${USR_SRC_NGINX_MODS}/cache-purge \
    --add-module=${USR_SRC_NGINX_MODS}/testcookie \
    --add-module=${USR_SRC_NGINX_MODS}/nchan \
    --add-module=${USR_SRC_NGINX_MODS}/sysguard && \
    make && \
    make install

# cleanup
RUN apt-get autoclean -yqq && \
    apt-get autoremove -yqq && \
    rm -rf ${USR_SRC_NGINX} && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

WORKDIR /etc/nginx

# copy configs from docker folder
COPY docker /

# Diffie-Hellman
RUN openssl dhparam -dsaparam -out /etc/nginx/dhparam.pem 4096

EXPOSE 80/tcp 443/tcp

# possible folders to map
VOLUME [ "/etc/nginx", "/var/log/nginx", "/var/www", "/etc/letsencrypt" ]

STOPSIGNAL SIGTERM

USER ubuntu

CMD [ "sudo", "nginx", "-g", "daemon off;" ]
