# gokaygurcan/dockerfile-nginx

FROM gokaygurcan/ubuntu:latest

LABEL maintainer="Gökay Gürcan <docker@gokaygurcan.com>"

ENV DEBIAN_FRONTEND="noninteractive" \
    USR_SRC=/usr/src \
    USR_SRC_NGINX=/usr/src/nginx \
    USR_SRC_NGINX_MODS=/usr/src/nginx/modules \
    NGINX_VERSION=1.15.6 \
    OPENSSL_VERSION=1.1.1 \
    PAGESPEED_VERSION=1.13.35.2

USER root

RUN set -ex && \
    # install dependencies
    apt-get update -qq && \
    apt-get upgrade -yqq && \
    apt-get install -yqq --no-install-recommends --no-install-suggests \
    aria2 \
    libbrotli-dev \
    libmaxminddb0 \
    libmaxminddb-dev \
    libpcre3 \
    libpcre3-dev \
    mmdb-bin \
    uuid-dev \
    zlibc \
    zlib1g \
    zlib1g-dev && \
    # download and compile geoip: geolite2-city.mmdb, geolite2-country.mmdb, geolite-city.dat and geolite-country.dat
    cd ${USR_SRC} && \
    wget -q http://geolite.maxmind.com/download/geoip/api/c/GeoIP.tar.gz && \
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
    rm -rf GeoLite2-City_* && \
    # download nginx
    cd ${USR_SRC} && \
    wget -q https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -xzf nginx-${NGINX_VERSION}.tar.gz && \
    rm nginx-${NGINX_VERSION}.tar.gz && \
    mv nginx-* nginx && \
    # /usr/src/nginx/modules
    mkdir -p ${USR_SRC_NGINX_MODS} && \
    cd ${USR_SRC_NGINX_MODS} && \
    # openssl
    wget -q https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz && \
    tar -xzf openssl-${OPENSSL_VERSION}.tar.gz && \
    rm openssl-${OPENSSL_VERSION}.tar.gz && \
    mv openssl-* openssl && \
    # nginx/njs
    aria2c -q https://github.com/nginx/njs/tarball/master && \
    tar -xzf nginx-njs-*.tar.gz && \
    rm nginx-njs-*.tar.gz && \
    mv nginx-njs-* njs && \
    # openresty/headers-more-nginx-module
    aria2c -q https://github.com/openresty/headers-more-nginx-module/tarball/master && \
    tar -xzf openresty-headers-more-nginx-module-*.tar.gz && \
    rm openresty-headers-more-nginx-module-*.tar.gz && \
    mv openresty-headers-more-nginx-module-* headers-more && \
    # frickle/ngx_cache_purge
    aria2c -q https://github.com/FRiCKLE/ngx_cache_purge/tarball/master && \
    tar -xzf FRiCKLE-ngx_cache_purge-*.tar.gz && \
    rm FRiCKLE-ngx_cache_purge-*.tar.gz && \
    mv FRiCKLE-ngx_cache_purge-* cache-purge && \
    # kyprizel/testcookie-nginx-module
    aria2c -q https://github.com/kyprizel/testcookie-nginx-module/tarball/master && \
    tar -xzf kyprizel-testcookie-nginx-module-*.tar.gz && \
    rm kyprizel-testcookie-nginx-module-*.tar.gz && \
    mv kyprizel-testcookie-nginx-module-* testcookie && \
    # vozlt/nginx-module-sysguard
    aria2c -q https://github.com/vozlt/nginx-module-sysguard/tarball/master && \
    tar -xzf vozlt-nginx-module-sysguard-*.tar.gz && \
    rm vozlt-nginx-module-sysguard-*.tar.gz && \
    mv vozlt-nginx-module-sysguard-* sysguard && \
    # eustas/ngx_brotli
    aria2c -q https://github.com/eustas/ngx_brotli/tarball/master && \
    tar -xzf eustas-ngx_brotli-*.tar.gz && \
    rm eustas-ngx_brotli-*.tar.gz && \
    mv eustas-ngx_brotli-* brotli && \
    cd ${USR_SRC_NGINX_MODS}/brotli/deps && \
    rm -rf ./brotli && \
    aria2c -q https://github.com/google/brotli/tarball/master && \
    tar -xzf google-brotli-*.tar.gz && \
    rm google-brotli-*.tar.gz && \
    mv google-brotli-* brotli && \
    cd ${USR_SRC_NGINX_MODS} && \
    # aperezdc/ngx-fancyindex
    aria2c -q https://github.com/aperezdc/ngx-fancyindex/tarball/master && \
    tar -xzf aperezdc-ngx-fancyindex-*.tar.gz && \
    rm aperezdc-ngx-fancyindex-*.tar.gz && \
    mv aperezdc-ngx-fancyindex-* fancyindex && \
    # apache/incubator-pagespeed-ngx and psol
    wget -q https://github.com/apache/incubator-pagespeed-ngx/archive/v${PAGESPEED_VERSION}-stable.tar.gz && \
    tar -xzf v${PAGESPEED_VERSION}-stable.tar.gz && \
    rm v${PAGESPEED_VERSION}-stable.tar.gz && \
    mv *-pagespeed-* pagespeed && \
    cd ${USR_SRC_NGINX_MODS}/pagespeed && \
    wget -q https://dl.google.com/dl/page-speed/psol/${PAGESPEED_VERSION}-x64.tar.gz && \
    tar -xzf ${PAGESPEED_VERSION}-x64.tar.gz && \
    rm ${PAGESPEED_VERSION}-x64.tar.gz && \
    mkdir -p /var/cache/ngx_pagespeed && \
    # compile nginx
    cd ${USR_SRC_NGINX} && \
    sh ./configure \
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
    --add-module=${USR_SRC_NGINX_MODS}/sysguard \
    --add-module=${USR_SRC_NGINX_MODS}/brotli \
    --add-module=${USR_SRC_NGINX_MODS}/fancyindex && \
    make && \
    make install && \
    # cleanup
    apt-get autoclean -yqq && \
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
