# colima-otel

This repo helps MacOS users setup a simple containerized Splunk OTel Collector.  

Requirements:

- [Homebrew](https://brew.sh/) (for package management)
- [Colima](https://github.com/abiosoft/colima) (for container virtualization)
- [Docker Engine](https://www.docker.com/products/container-runtime/) (for container runtime)
- [Docker Compose](https://docs.docker.com/compose/) (for container configuration/orchestration).

These components combine to easily run a Splunk OTel Collector in a Docker container on MacOS.

Optional:

- [OTel CLI](https://github.com/serkan-ozal/otel-cli)

There's a script called [`otel-cli-test.sh`](./otel-cli-test.sh) that uses OTel CLI to send 2 test traces (1 via gRPC, and 1 via http) to the Splunk OTel Collector.

## Pre-requisites

### Homebrew

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

### Docker Engine

Run the Homebrew installer for `docker`:

```shell
brew install docker
```

### Docker Compose

Run the Homebrew installer for `docker-compose`:

```shell
brew install docker-compose
```

## Start Colima

Start the `colima` container virtualization:

```shell
colima start
```

A successfull startup will look something like:

```shell
❯ colima start
INFO[0000] starting colima                              
INFO[0000] runtime: docker                              
INFO[0001] starting ...                                  context=vm
INFO[0013] provisioning ...                              context=docker
INFO[0014] starting ...                                  context=docker
INFO[0015] done
```

## Configuration

### Required Configuration

#### Rename and edit `.env_example` file

Docker Compose can use a `.env` file to populate environment variables.  `.env_example` is a placeholder for sensitive env vars.

Copy the `.env_example` file to `.env`

```shell
cp .env_example .env
```

Configure the environment variables in the new `.env` file

```conf
SPLUNK_ACCESS_TOKEN=<YOUR_ACCESS_TOKEN>
SPLUNK_REALM=<YOUR_REALM>
```

### Optional Configuration

There are a few configuration options called out in the [Compose file comments](./docker-compose.yaml#L3-L21).

- Container `hostname` value to give the container a nice name in the UI
- OTel Collector config to adjust any and all Collector behavior

## Start the Docker Compose Services

The following command will start the Splunk OpenTelemetry Collector Compose Service:

```shell
docker-compose up -d
```

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
