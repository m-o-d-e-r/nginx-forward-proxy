FROM debian:12

RUN apt update && \
    apt install --no-install-recommends -y \
        zip build-essential wget gnupg ca-certificates nginx

RUN wget -O - https://openresty.org/package/pubkey.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/openresty.gpg && \
    codename=`grep -Po 'VERSION="[0-9]+ \(\K[^)]+' /etc/os-release` && \
    echo "deb http://openresty.org/package/debian $codename openresty" | tee /etc/apt/sources.list.d/openresty.list && \
    apt update && \
    apt install -y openresty

WORKDIR /opt
RUN mkdir -p daemontools && \
    cd daemontools && \
    wget http://cr.yp.to/daemontools/daemontools-0.76.tar.gz && \
    tar -xpf daemontools-0.76.tar.gz && \
    rm -f daemontools-0.76.tar.gz && \
    cd admin/daemontools-0.76 && \
    echo "gcc -O2 -Wimplicit -Wunused -Wcomment -Wchar-subscripts -Wuninitialized -Wshadow -Wcast-qual -Wcast-align -Wwrite-strings -include /usr/include/errno.h" > src/conf-cc && \
    package/install

COPY service /service
COPY etc/nginx.conf /etc/nginx/nginx.conf

CMD ["svscan", "/service"]
