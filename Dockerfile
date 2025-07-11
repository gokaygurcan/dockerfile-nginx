# gokaygurcan/dockerfile-nginx

FROM gokaygurcan/ubuntu:latest AS build-nginx
LABEL maintainer="Gökay Gürcan <docker@gokaygurcan.com>"

ARG DEBIAN_FRONTEND=noninteractive
ENV USR_SRC=/usr/src \
    USR_SRC_NGINX=/usr/src/nginx \
    USR_SRC_NGINX_MODS=/usr/src/nginx/modules \
    NGINX_VERSION=1.29.0 \
    OPENSSL_VERSION=3.5.0 \
    LIBMAXMINDDB_VERSION=1.12.2

USER root

RUN set -ex && \
    # configure apt to always assume Y
    echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes && \
    # update package sources
    apt-get update -qq && \
    # upgrade packages
    apt-get upgrade -yqq && \
    apt-get dist-upgrade -yqq && \
    # install packages
    apt-get install -yqq --no-install-recommends --no-install-suggests \
    libbrotli-dev \
    libmaxminddb-dev \
    libpcre3 \
    libpcre3-dev \
    libxml2 \
    libxml2-dev \
    libxslt1-dev \
    mmdb-bin \
    uuid-dev \
    zlib1g \
    zlib1g-dev && \
    # maxmind geoip2
    cd /tmp && \
    wget -q https://github.com/maxmind/libmaxminddb/releases/download/${LIBMAXMINDDB_VERSION}/libmaxminddb-${LIBMAXMINDDB_VERSION}.tar.gz && \
    tar -xzf libmaxminddb-*.tar.gz && \
    rm libmaxminddb-*.tar.gz && \
    cd libmaxminddb-* && \
    ./configure && \
    make && \
    make check && \
    make install && \
    ldconfig && \
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
    # leev/ngx_http_geoip2_module
    aria2c -q https://github.com/leev/ngx_http_geoip2_module/tarball/master && \
    tar -xzf leev-ngx_http_geoip2_module-*.tar.gz && \
    rm leev-ngx_http_geoip2_module-*.tar.gz && \
    mv leev-ngx_http_geoip2_module-* geoip2 && \
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
    # google/brotli
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
    # compile nginx
    cd ${USR_SRC_NGINX} && \
    sh ./configure \
    --conf-path=/etc/nginx/nginx.conf \
    --sbin-path=/usr/sbin/nginx \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --with-cc-opt=-Wno-error \
    --with-http_addition_module \
    --with-file-aio \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-openssl=${USR_SRC_NGINX_MODS}/openssl \
    --with-compat \
    --with-mail \
    --with-mail_ssl_module \
    --with-stream_ssl_preread_module \
    --with-stream_realip_module \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    --without-http_fastcgi_module \
    --without-http_uwsgi_module \
    --without-http_scgi_module \
    --add-module=${USR_SRC_NGINX_MODS}/njs/nginx \
    --add-module=${USR_SRC_NGINX_MODS}/geoip2 \
    --add-module=${USR_SRC_NGINX_MODS}/headers-more \
    --add-module=${USR_SRC_NGINX_MODS}/cache-purge \
    --add-module=${USR_SRC_NGINX_MODS}/testcookie \
    --add-module=${USR_SRC_NGINX_MODS}/sysguard \
    --add-module=${USR_SRC_NGINX_MODS}/brotli \
    --add-module=${USR_SRC_NGINX_MODS}/fancyindex && \
    # make and install
    make && \
    make install && \
    echo "✓" | tee /usr/local/nginx/html/index.html && \
    # Diffie-Hellman
    openssl dhparam -dsaparam -out /etc/nginx/dhparam.pem 4096 && \
    # configure dynamic linker run-time bindings
    ldconfig -v && \
    # clean up
    rm /etc/nginx/*.default && \
    apt-get autoclean -yqq && \
    apt-get autoremove -yqq && \
    rm -rf ${USR_SRC_NGINX} && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    rm -rf /var/tmp/* && \
    rm -rf /tmp/* && \
    # forward request and error logs to docker log collector
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# FROM ubuntu:noble
FROM gokaygurcan/ubuntu:latest
LABEL maintainer="Gökay Gürcan <docker@gokaygurcan.com>"

COPY --from=build-nginx /etc/nginx /etc/nginx
COPY --from=build-nginx /usr/lib /usr/lib
COPY --from=build-nginx /usr/local/lib /usr/local/lib
COPY --from=build-nginx /usr/local/nginx /usr/local/nginx
COPY --from=build-nginx /var/log/nginx /var/log/nginx
COPY --from=build-nginx /usr/sbin/nginx /usr/sbin/nginx

WORKDIR /etc/nginx

# copy configs from docker folder
COPY docker /

ENV PATH="${PATH}:/usr/sbin/nginx"

EXPOSE 80/tcp 443/tcp

# possible folders to map
VOLUME [ "/etc/nginx", "/var/log/nginx", "/var/www", "/etc/letsencrypt", "/usr/share/GeoIP" ]

STOPSIGNAL SIGTERM

USER ubuntu

HEALTHCHECK --interval=60s --start-period=60s CMD curl -f http://localhost/ || exit 1

CMD [ "sudo", "nginx", "-g", "daemon off;" ]
