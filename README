# Nginx Forward Proxy Container

This is a simple **HTTP forward proxy** that runs under **Nginx**.

## What it does

- Forwards standard proxy headers:
  - `Host`
  - `X-Real-IP`
  - `X-Forwarded-For`
  - `X-Forwarded-Proto`

## Components

- **Nginx** — HTTP proxy server
- **OpenResty** — installed and available for extensions
- **daemontools** — service supervision

## Build

To build the container you can use such command:

```bash
docker build -t nginx-forward-proxy .
```

## Run

Launching proxy locally:

```bash
docker run --rm --name nginx-forward-proxy nginx-forward-proxy
```
