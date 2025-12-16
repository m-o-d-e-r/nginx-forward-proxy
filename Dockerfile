ARG OPENRESTY_PREFIX=/opt/openresty

FROM debian:12
ARG OPENRESTY_PREFIX

RUN apt update && \
    apt install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        daemontools \
        daemontools-run \
        git \
        gnupg \
        libpcre3 \
        libpcre3-dev \
        openssl libssl-dev \
        wget \
        zlib1g-dev

WORKDIR /opt
RUN git clone https://github.com/chobits/ngx_http_proxy_connect_module.git && \
    wget https://openresty.org/download/openresty-1.19.3.1.tar.gz && \
    tar xzf openresty-1.19.3.1.tar.gz && \
    rm openresty-1.19.3.1.tar.gz && \
    cd openresty-1.19.3.1 && \
    ./configure \
        --prefix=${OPENRESTY_PREFIX} \
        --add-module=/opt/ngx_http_proxy_connect_module \
        --with-http_ssl_module \
        --with-stream \
        --with-stream_ssl_module && \
    patch -d build/nginx-1.19.3/ -p 1 < /opt/ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_101504.patch && \
    make && \
    make install

ADD https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.142.0/otelcol-contrib_0.142.0_linux_amd64.deb otelcol-contrib_0.142.0_linux_amd64.deb
RUN dpkg -i ./otelcol-contrib_0.142.0_linux_amd64.deb && \
    rm otelcol-contrib_0.142.0_linux_amd64.deb

ENV PATH=${PATH}:${OPENRESTY_PREFIX}/nginx/sbin:${OPENRESTY_PREFIX}/bin/

COPY service /service
COPY etc/nginx/nginx.conf ${OPENRESTY_PREFIX}/nginx/conf/nginx.conf
COPY etc/otelcol-contrib/config.yaml /etc/otelcol-contrib/config.yaml

CMD ["svscan", "/service"]
