# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Docker container that wraps Grafana Alloy (OpenTelemetry collector) with exposed ports for OTLP ingestion and monitoring. It receives telemetry data (traces, metrics, logs) via OTLP and forwards it to Grafana Cloud.

## Build and Run Commands

**Build the Docker image:**
```bash
docker build -t alloy-exposed .
```

**Run the container:**
```bash
docker run -p 4317:4317 -p 4318:4318 -p 12345:12345 \
  -e GRAFANA_CLOUD_OTLP_ENDPOINT="<endpoint>" \
  -e GRAFANA_CLOUD_INSTANCE_ID="<instance_id>" \
  -e GRAFANA_CLOUD_API_KEY="<api_key>" \
  alloy-exposed
```

**Access the Alloy UI:**
Navigate to http://localhost:12345 to verify the service is running.

## Architecture

### Configuration Pipeline (default.alloy)

The Alloy configuration uses River language to define an OpenTelemetry processing pipeline:

1. **otelcol.receiver.otlp** - Receives OTLP data on:
   - gRPC: port 4317
   - HTTP: port 4318

2. **otelcol.processor.attributes "force_host_id"** (traces only) - Inserts a stable `host.id` attribute (`neo-hst-prod-sender-id`) to ensure consistent host-hours tracking in Grafana Cloud

3. **otelcol.connector.host_info** (traces only) - Generates `traces_host_info` metrics with `grafana_host_id` for host-hours billing/tracking

4. **otelcol.processor.batch** - Batches all telemetry signals before export

5. **otelcol.exporter.otlphttp** - Exports to Grafana Cloud using basic auth

### Environment Variables

The configuration requires three environment variables:
- `GRAFANA_CLOUD_OTLP_ENDPOINT` - Grafana Cloud OTLP endpoint URL
- `GRAFANA_CLOUD_INSTANCE_ID` - Used as basic auth username
- `GRAFANA_CLOUD_API_KEY` - Used as basic auth password

### Exposed Ports

- **4317/tcp** - OTLP over gRPC
- **4318/tcp** - OTLP over HTTP
- **12345/tcp** - Alloy UI/monitoring interface
