FROM grafana/alloy:latest

LABEL description="Grafana Alloy with OTLP endpoints exposed for telemetry collection"
LABEL version="1.0"
LABEL maintainer="Daniel Bryars <seriouscallersonly@bryars.com>"

COPY default.alloy /etc/alloy/config.alloy

EXPOSE 4317/tcp 4318/tcp 12345/tcp 80/tcp

ENTRYPOINT ["/bin/alloy"]
CMD ["run", "--server.http.listen-addr=0.0.0.0:12345", "/etc/alloy/config.alloy"]