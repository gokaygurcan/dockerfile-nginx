# gokaygurcan/dockerfile-nginx

FROM gokaygurcan/ubuntu:18.04

LABEL maintainer="Gökay Gürcan <docker@gokaygurcan.com>"

ENV DEBIAN_FRONTEND="noninteractive"

ARG nginx_version=1.15.2
ARG njs_version=0.2.2
ARG cache_purge_version=2.3
ARG headers_more_version=0.33
ARG openssl_version=1.0.2o
ARG pagespeed_version=1.13.35.2
ARG pagespeed_release=stable

ENV USR_SRC=/usr/src \
    USR_SRC_NGINX=/usr/src/nginx \
    USR_SRC_NGINX_MODS=/usr/src/nginx/modules \
    NGINX_VERSION=${nginx_version} \
    NJS_VERSION=${njs_version} \
    CACHE_PURGE_VERSION=${cache_purge_version} \
    HEADERS_MORE_VERSION=${headers_more_version} \
    OPENSSL_VERSION=${openssl_version} \
    PAGESPEED_VERSION=${pagespeed_version} \
    PAGESPEED_RELEASE=${pagespeed_release}

RUN set -ex && \
    sudo apt-get update -q && \
    sudo apt-get upgrade -yq && \
    sudo apt-get install -yq --no-install-recommends --no-install-suggests \
    apt-transport-https \
    apt-utils \
    aria2 \
    autotools-dev \
    autoconf \
    aria2 \
    build-essential \
    ca-certificates \
    file \
    gzip \
    libpcre3 \
    libpcre3-dev \
    tar \
    unzip \
    wget \
    zlibc \
    zlib1g \
    zlib1g-dev && \
    sudo apt-get install uuid-dev -yq --no-install-recommends --no-install-suggests && \
    sudo apt-get autoclean -y && \
    sudo apt-get autoremove -y && \
    sudo rm -rf /var/lib/apt/lists/*

# download and compile geoip
WORKDIR ${USR_SRC}
RUN sudo wget http://geolite.maxmind.com/download/geoip/api/c/GeoIP.tar.gz && \
    sudo tar -zxvf GeoIP.tar.gz && \
    sudo rm GeoIP.tar.gz && \
    sudo mv GeoIP-* GeoIP && \
    cd GeoIP && \
    sudo sh ./configure && \
    sudo make && \
    sudo make install && \
    echo '/usr/local/lib' | sudo tee -a /etc/ld.so.conf.d/geoip.conf && \
    sudo ldconfig

# download nginx
RUN sudo wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    sudo tar -xzvf nginx-${NGINX_VERSION}.tar.gz && \
    sudo rm nginx-${NGINX_VERSION}.tar.gz && \
    sudo mv nginx-* nginx && \
    # create modules directory
    sudo mkdir -p ${USR_SRC_NGINX_MODS}

# download openssl
WORKDIR ${USR_SRC_NGINX_MODS}
RUN sudo wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz && \
    sudo tar -xzvf openssl-${OPENSSL_VERSION}.tar.gz && \
    sudo rm openssl-${OPENSSL_VERSION}.tar.gz && \
    sudo mv openssl-* openssl && \
    # download njx
    sudo wget -O njs-${NJS_VERSION}.tar.gz https://github.com/nginx/njs/archive/${NJS_VERSION}.tar.gz && \
    sudo tar -xzvf njs-${NJS_VERSION}.tar.gz && \
    sudo rm njs-${NJS_VERSION}.tar.gz && \
    sudo mv njs-* njs && \
    # download pagespeed
    sudo wget https://github.com/apache/incubator-pagespeed-ngx/archive/v${PAGESPEED_VERSION}-${PAGESPEED_RELEASE}.tar.gz && \
    sudo tar -xzvf v${PAGESPEED_VERSION}-${PAGESPEED_RELEASE}.tar.gz && \
    sudo rm v${PAGESPEED_VERSION}-${PAGESPEED_RELEASE}.tar.gz && \
    sudo mv *-pagespeed-* pagespeed

# download psol for pagespeed
WORKDIR ${USR_SRC_NGINX_MODS}/pagespeed
RUN sudo wget https://dl.google.com/dl/page-speed/psol/${PAGESPEED_VERSION}-x64.tar.gz && \
    sudo tar -xzvf ${PAGESPEED_VERSION}-x64.tar.gz && \
    sudo rm ${PAGESPEED_VERSION}-x64.tar.gz

# download headers-more-nginx-module
WORKDIR ${USR_SRC_NGINX_MODS}
RUN sudo wget https://github.com/openresty/headers-more-nginx-module/archive/v${HEADERS_MORE_VERSION}.tar.gz && \
    sudo tar -xzvf v${HEADERS_MORE_VERSION}.tar.gz && \
    sudo rm v${HEADERS_MORE_VERSION}.tar.gz && \
    sudo mv headers-more-nginx-module-* headers-more && \
    # download ngx cache purge module
    sudo wget https://github.com/FRiCKLE/ngx_cache_purge/archive/${CACHE_PURGE_VERSION}.tar.gz && \
    sudo tar -xzvf ${CACHE_PURGE_VERSION}.tar.gz && \
    sudo rm ${CACHE_PURGE_VERSION}.tar.gz && \
    sudo mv ngx_cache_purge-* cache-purge && \
    # download testcookie module
    sudo aria2c https://github.com/kyprizel/testcookie-nginx-module/tarball/master && \
    sudo tar -xzvf kyprizel-testcookie-nginx-module-*.tar.gz && \
    sudo rm kyprizel-testcookie-nginx-module-*.tar.gz && \
    sudo mv kyprizel-testcookie-nginx-module-* testcookie && \
    # download sysguard
    sudo aria2c https://github.com/vozlt/nginx-module-sysguard/tarball/master && \
    sudo tar -xzvf vozlt-nginx-module-sysguard-*.tar.gz && \
    sudo rm vozlt-nginx-module-sysguard-*.tar.gz && \
    sudo mv vozlt-nginx-module-sysguard-* sysguard && \
    # download geoip databases
    sudo mkdir -p /usr/local/share/GeoIP
WORKDIR /usr/local/share/GeoIP
RUN sudo rm -rf ./* && \
    sudo wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz && \
    sudo gzip -d GeoIP.dat.gz && \
    sudo wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && \
    sudo gzip -d GeoLiteCity.dat.gz

# compile nginx  
WORKDIR ${USR_SRC_NGINX}
RUN sudo sh ./configure \
    --conf-path=/etc/nginx/nginx.conf \
    --sbin-path=/usr/sbin/nginx \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --with-http_addition_module \
    --with-file-aio \
    --with-http_dav_module \
    --with-http_geoip_module \
    --with-http_gzip_static_module \
    --with-http_realip_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-openssl=./modules/openssl \
    --without-http_fastcgi_module \
    --without-http_uwsgi_module \
    --without-http_scgi_module \
    --add-module=${USR_SRC_NGINX_MODS}/njs/nginx \
    --add-module=${USR_SRC_NGINX_MODS}/pagespeed \
    --add-module=${USR_SRC_NGINX_MODS}/headers-more \
    --add-module=${USR_SRC_NGINX_MODS}/cache-purge \
    --add-module=${USR_SRC_NGINX_MODS}/testcookie \
    --add-module=${USR_SRC_NGINX_MODS}/sysguard && \
    sudo make && \
    sudo make install

WORKDIR /etc/nginx

EXPOSE 80 443

VOLUME /etc/nginx

STOPSIGNAL SIGTERM

CMD ["sudo", "nginx", "-g", "daemon off;"]
