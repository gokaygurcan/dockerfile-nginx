# gokaygurcan/dockerfile-nginx

FROM rust:latest AS nginx-build
LABEL maintainer="Gökay Gürcan <docker@gokaygurcan.com>"

ARG DEBIAN_FRONTEND=noninteractive
ENV USR_SRC=/usr/src \
    USR_SRC_NGINX=/usr/src/nginx \
    USR_SRC_NGINX_MODS=/usr/src/nginx/modules \
    NGINX_VERSION=1.29.1 \
    OPENSSL_VERSION=3.5.2 \
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
    libclang-dev \
    libssl-dev \
    libxml2 \
    libxml2-dev \
    libxslt1-dev \
    mmdb-bin \
    pkg-config \
    uuid-dev \
    zlib1g \
    zlib1g-dev && \
    # start configuring the modules
    cd /tmp && \
    # maxmind geoip2
    curl -fSL https://github.com/maxmind/libmaxminddb/releases/download/${LIBMAXMINDDB_VERSION}/libmaxminddb-${LIBMAXMINDDB_VERSION}.tar.gz -o libmaxminddb-${LIBMAXMINDDB_VERSION}.tar.gz && \
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
    curl -fSL https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -o nginx-${NGINX_VERSION}.tar.gz && \
    tar -xzf nginx-${NGINX_VERSION}.tar.gz && \
    rm nginx-${NGINX_VERSION}.tar.gz && \
    mv nginx-* nginx && \
    # /usr/src/nginx/modules
    mkdir -p ${USR_SRC_NGINX_MODS} && \
    cd ${USR_SRC_NGINX_MODS} && \
    # openssl
    curl -fSL https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz -o openssl-${OPENSSL_VERSION}.tar.gz && \
    tar -xzf openssl-${OPENSSL_VERSION}.tar.gz && \
    rm openssl-${OPENSSL_VERSION}.tar.gz && \
    mv openssl-* openssl && \
    # nginx/nginx-acme
    git clone https://github.com/nginx/nginx-acme.git acme && \
    # nginx/njs
    git clone https://github.com/nginx/njs.git njs && \
    # leev/ngx_http_geoip2_module
    git clone https://github.com/leev/ngx_http_geoip2_module.git geoip2 && \
    # openresty/headers-more-nginx-module
    git clone https://github.com/openresty/headers-more-nginx-module.git headers-more && \
    # frickle/ngx_cache_purge
    git clone https://github.com/FRiCKLE/ngx_cache_purge.git cache-purge && \
    # kyprizel/testcookie-nginx-module
    git clone https://github.com/kyprizel/testcookie-nginx-module.git testcookie && \
    # vozlt/nginx-module-sysguard
    git clone https://github.com/vozlt/nginx-module-sysguard.git sysguard && \
    # aperezdc/ngx-fancyindex
    git clone https://github.com/aperezdc/ngx-fancyindex.git fancyindex && \
    # eustas/ngx_brotli
    git clone https://github.com/eustas/ngx_brotli.git brotli && \
    cd ${USR_SRC_NGINX_MODS}/brotli/deps && \
    rm -rf ./brotli && \
    # google/brotli
    git clone https://github.com/google/brotli.git brotli && \
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
    --add-dynamic-module=${USR_SRC_NGINX_MODS}/acme \
    --add-module=${USR_SRC_NGINX_MODS}/njs/nginx \
    --add-module=${USR_SRC_NGINX_MODS}/geoip2 \
    --add-module=${USR_SRC_NGINX_MODS}/headers-more \
    --add-module=${USR_SRC_NGINX_MODS}/cache-purge \
    --add-module=${USR_SRC_NGINX_MODS}/testcookie \
    --add-module=${USR_SRC_NGINX_MODS}/sysguard \
    --add-module=${USR_SRC_NGINX_MODS}/fancyindex \
    --add-module=${USR_SRC_NGINX_MODS}/brotli && \
    # make and install
    make && \
    make modules && \
    make install && \
    # housekeeping
    mkdir /etc/nginx/modules && \
    cp ${USR_SRC_NGINX}/objs/ngx_http_acme_module.so /etc/nginx/modules/ngx_http_acme_module.so && \
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

FROM gokaygurcan/ubuntu:latest
LABEL maintainer="Gökay Gürcan <docker@gokaygurcan.com>"

COPY --from=nginx-build /etc/nginx /etc/nginx
COPY --from=nginx-build /usr/lib /usr/lib
COPY --from=nginx-build /usr/local/lib /usr/local/lib
COPY --from=nginx-build /usr/local/nginx /usr/local/nginx
COPY --from=nginx-build /var/log/nginx /var/log/nginx
COPY --from=nginx-build /usr/sbin/nginx /usr/sbin/nginx

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
