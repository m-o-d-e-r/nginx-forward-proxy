FROM debian:12

RUN apt update && \
    apt install -y --no-install-recommends nginx daemontools daemontools-run

ADD https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.142.0/otelcol-contrib_0.142.0_linux_amd64.deb otelcol-contrib_0.142.0_linux_amd64.deb
RUN dpkg -i ./otelcol-contrib_0.142.0_linux_amd64.deb && \
    rm otelcol-contrib_0.142.0_linux_amd64.deb

COPY service /service
COPY etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY etc/otelcol-contrib/config.yaml /etc/otelcol-contrib/config.yaml

CMD ["svscan", "/service"]
