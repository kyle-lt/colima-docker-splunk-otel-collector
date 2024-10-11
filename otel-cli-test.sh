#!/bin/sh

# https://github.com/serkan-ozal/otel-cli

# Get start time in milliseconds ("date" command only support second resolution in MacOS)
start_time=$(node -e 'console.log(Date.now())')

sleep 2

# Get end time in milliseconds ("date" command only support second resolution in MacOS)
end_time=$(node -e 'console.log(Date.now())')

# Create new `traceid`
export OTEL_CLI_TRACE_ID=$(otel-cli generate-id -t trace)

# Export test span over grpc
otel-cli export \
  --name otel-cli-trace-grpc --service-name otel-cli-test-service \
  --start-time-millis ${start_time} --end-time-millis ${end_time} \
  --endpoint http://localhost:4317 --protocol grpc \
  --kind CLIENT --status-code OK --attributes serviceName=otel-cli-test-service \
  --resource-attributes service.kind=test protocol.type=grpc

# Create new `traceid`
export OTEL_CLI_TRACE_ID=$(otel-cli generate-id -t trace)

# Export test span over http
otel-cli export \
  --name otel-cli-trace-http --service-name otel-cli-test-service \
  --start-time-millis ${start_time} --end-time-millis ${end_time} \
  --endpoint http://localhost:4318 --protocol http/json \
  --kind CLIENT --status-code OK --attributes serviceName=otel-cli-test-service \
  --resource-attributes service.kind=test protocol.type=http

########################################

exit 0