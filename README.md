# Nginx Forward Proxy Container

This is a simple **HTTP forward proxy** that runs under **Nginx**.

## What it does

- Forwards standard proxy headers:
  - `Host`
  - `X-Real-IP`
  - `X-Forwarded-For`
  - `X-Forwarded-Proto`

## Components

- **nginx** — HTTP proxy server
- **otel** — sending logs to the Splunk (for now just to the stdout)

## Run

Launching proxy locally:

```bash
docker compose up
```
