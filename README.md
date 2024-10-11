# colima-otel

This repo helps MacOS users setup a simple containerized Splunk OTel Collector.  It requires Homebrew (for package management), [Colima](https://github.com/abiosoft/colima) (for container orchestration), and Docker (for container runtime) tooling. And it uses Docker Compose to orchestrate the OpenTelemetry Collector container.

In addition, and completely optional, there's a helper "test" script called [`otel-cli-test.sh`](./otel-cli-test.sh) that requires [`otel-cli`](https://github.com/serkan-ozal/otel-cli) in order to run it.  The script sends 2 test traces, 1 via gRPC, and 1 via http, to test the trace pipeline.

## Pre-requisites

- [Homebrew](https://brew.sh/)

To install Homebrew:

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Or, use the `pkg` installer from the [Releases](https://github.com/Homebrew/brew/releases) page on GitHub.  The latest installer at the time of writing this guide is [here](https://github.com/Homebrew/brew/releases/download/4.4.0/Homebrew-4.4.0.pkg).

## Installation of Tooling (via Homebrew)

### Colima

Run the Homebrew installer for `colima`:

```shell
brew install colima
```

This installer might take 3-5 minutes, so be patient!

### Docker CLI

Run the Homebrew installer for `docker` (CLI):

```shell
brew install docker
```

### Docker Compose CLI

Run the Homebrew installer for `docker-compose` (CLI):

```shell
brew install docker-compose
```

## Start Colima

Start the `colima` container orchestrator:

```shell
colima start
```

## Rename and edit `.env_example` file

Copy the `.env_example` file to `.env`

```shell
cp .env_example .env
```

Configure the environment variables in the new `.env` file

```conf
SPLUNK_ACCESS_TOKEN=<YOUR_ACCESS_TOKEN>
SPLUNK_REALM=<YOUR_REALM>
```

## Start the Docker Compose Services

The following command will start both the OTel Collector, and Jaeger:

```shell
docker-compose up -d
```

## Further Configuration

There are a few configuration options called out in the [Compose file comments](./docker-compose.yaml#L3-L21).

- Container `hostname` value to give the container a nice name in the UI
- OTel Collector config to adjust any and all Collector behavior

## Troubleshooting

Make sure the container is running:

```shell
docker ps
```

Example output:

```shell
CONTAINER ID   IMAGE                                           COMMAND      CREATED          STATUS          PORTS                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     NAMES
8899e729577b   quay.io/signalfx/splunk-otel-collector:latest   "/otelcol"   17 minutes ago   Up 17 minutes   0.0.0.0:1888->1888/tcp, :::1888->1888/tcp, 0.0.0.0:4317-4318->4317-4318/tcp, :::4317-4318->4317-4318/tcp, 0.0.0.0:6060->6060/tcp, :::6060->6060/tcp, 0.0.0.0:7276->7276/tcp, :::7276->7276/tcp, 0.0.0.0:8888-8889->8888-8889/tcp, :::8888-8889->8888-8889/tcp, 0.0.0.0:9080->9080/tcp, :::9080->9080/tcp, 8006/tcp, 0.0.0.0:9411->9411/tcp, :::9411->9411/tcp, 0.0.0.0:9943->9943/tcp, :::9943->9943/tcp, 0.0.0.0:13133->13133/tcp, :::13133->13133/tcp, 0.0.0.0:14250->14250/tcp, :::14250->14250/tcp, 0.0.0.0:14268->14268/tcp, :::14268->14268/tcp, 0.0.0.0:55680-55681->55680-55681/tcp, :::55680-55681->55680-55681/tcp, 9443/tcp, 0.0.0.0:55670->55679/tcp, [::]:55670->55679/tcp   splunk-otel-collector
```

Check for errors in the OpenTelemetry Collector log:

```shell
docker logs splunk-otel-collector
```


