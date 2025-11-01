# alloy-exposed

A Docker container that wraps Grafana Alloy (OpenTelemetry collector) with exposed ports for OTLP ingestion and monitoring. This container receives telemetry data (traces, metrics, logs) via OTLP and forwards it to Grafana Cloud.

## Features

- Pre-configured OTLP receivers on standard ports (gRPC and HTTP)
- Automatic batching and forwarding to Grafana Cloud
- Stable host.id injection for consistent host-hours tracking
- Built-in UI for monitoring on port 80

## Exposed Ports

- **4317/tcp** - OTLP over gRPC
- **4318/tcp** - OTLP over HTTP
- **12345/tcp** - Alloy UI/monitoring interface
- **80/tcp** - Alloy HTTP server UI

## Prerequisites

You'll need the following from your Grafana Cloud account:
- OTLP endpoint URL
- Instance ID (used as username)
- API key (used as password)

## Quick Start

### Build the Docker Image

```bash
docker build -t alloy-exposed .
```

### Run the Container

```bash
docker run -p 4317:4317 -p 4318:4318 -p 12345:12345 -p 80:80 \
  -e GRAFANA_CLOUD_OTLP_ENDPOINT="<your-endpoint>" \
  -e GRAFANA_CLOUD_INSTANCE_ID="<your-instance-id>" \
  -e GRAFANA_CLOUD_API_KEY="<your-api-key>" \
  alloy-exposed
```

### Verify It's Working

Navigate to http://localhost:80 to access the Alloy UI and verify the service is running.

## Configuration

The container uses a pre-configured Alloy pipeline (`default.alloy`) that:

1. Receives OTLP data on ports 4317 (gRPC) and 4318 (HTTP)
2. Processes traces to inject a stable `host.id` attribute
3. Generates host-hours metrics for Grafana Cloud billing/tracking
4. Batches all telemetry signals
5. Exports to Grafana Cloud via OTLP/HTTP with basic authentication

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `GRAFANA_CLOUD_OTLP_ENDPOINT` | Your Grafana Cloud OTLP endpoint URL | Yes |
| `GRAFANA_CLOUD_INSTANCE_ID` | Your Grafana Cloud instance ID (basic auth username) | Yes |
| `GRAFANA_CLOUD_API_KEY` | Your Grafana Cloud API key (basic auth password) | Yes |

## Technologies Used

- [Grafana Alloy](https://grafana.com/docs/alloy/latest/) - OpenTelemetry collector distribution
- Docker
- OpenTelemetry Protocol (OTLP)

## Use Cases

This container is ideal for:
- Quick OTLP collection setup in development environments
- Centralized telemetry collection for microservices
- Testing OpenTelemetry instrumentation locally before deploying to production
- Simple forwarding of telemetry data to Grafana Cloud
