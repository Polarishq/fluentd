# splunknova fluentd plugin

A Splunk Nova [fluentd] plugin to send events to [Splunk HTTP Event Collector (HEC)][hec] or [Splunk Nova][nova]. The Splunk Nova plugin is installed and managed via ruby and [bundler].

## What it does

Fluentd is an open source data collector, which lets you unify the data collection and consumption. HEC enables you to send data over HTTP (or HTTPS) directly to Splunk Enterprise or Splunk Cloud from your application. Splunk Nova Cloud APIs help you quickly collect your logs and metrics to make sense of data points in your apps and infrastructure.

### Prerequisities

- [bundler]
- [fluentd]
- [Homebrew]
- [Ruby]
- [Splunk HTTP Event Collector (HEC)][hec]
- [Splunk Nova][nova]

## Install

Works best on macOS and Linux.

### macOS
To install the fluentd splunknova plugin locally, we recommend using [homebrew] and [ruby]. Once the dependencies are installed, from the command line run:

```
brew install ruby
gem install bundler
```

## Run tests

To run tests, first install the related libraries:

```
$ bundle install --path vendor/bundle
$ bundle exec rake test
```

## Configure

What file is the user configuring?

**config: splunk_url**

The Splunk URL.

**config: splunk_format**

Then Splunk format (nova default) (not used yet)

**config: splunk_token**

The Splunk token (YOUR BASE64 ENCODED API KEYS)

**config: splunk_url_path**

The Splunk entry point (/services/collector/event by default)

## Setup K8 fluentd nova daemonset plugin

[Kubernetes], also called K8 or K8S (K–eight characters–S), is an open source orchestration framework for containerized applications. The [Docker platform][dockerkub] supports Kubernetes.

### Prerequisities

- Access to the [docker hub][dhub] repo: https://hub.docker.com/r/polarishq/fluentd_splunknova.
- Your Splunk Nova API Keys from [Splunk Nova][nova]
- A kubernetes server.

### Setup
To setup a kubernetes server, see [Hello Minikube][hello], a kubernetes tutorial with [Minikube].

### Configure

1. Clone or download

  ```
  git@github.com:Polarishq/nova_fluentd_plugin.git
  ```

2. To configure the k8 fluentd nova deamonset plugin, open the file [fluentd-daemonset-splunknova.yaml](k8_image/fluentd-daemonset-splunknova.yaml)

2. Within the file, edit the `SPLUNK_URL` and `SPLUNK_TOKEN` values using your Splunk Nova API Keys: Your Splunk api-username and Base-64 Encoded token. Save and close the file.

  ```yaml
  - name:  SPLUNK_URL
  value: 'https://api-username.splunknovadev.com:443'
  - name:  SPLUNK_TOKEN
  value: "SlA0KjdYcTJFVURGTkJaVGNUbURNT0pOSWJ2MzU4R1A6aHptUWFLT0TreWVTVjZyV3ZkdXdzWlhkVzBEdzgycDMxLVZDOTNkZG5ncDN2T1ZNaTY2bmN3NXdzak1LcGpWSa=="
  ```

3. From the command line, create a daemonset by running:

  ```Bash
    kubectl create -f fluentd-daemonset-splunknova.yaml
```

### Create a docker image
To create a snapshot of your k8 fluentd container, you may choose to create a docker image. Images are created with the build command, and they'll produce a container when started with the `run` command. Images are stored in a Docker registry such as https://hub.docker.com/.

From within the terminal, change directories into the   `polarishq/fluentd_splunknova` repo, and run:

```Bash
docker build -t polarishq/fluentd_splunknova k8_image/good_image
```

[bundler]: http://bundler.io/
[dhub]: https://hub.docker.com/
[dockerkub]: https://www.docker.com/kubernetes
[fluentd]: https://www.fluentd.org/
[hec]: http://dev.splunk.com/view/event-collector/SP-CAAAE6M
[hello]: https://kubernetes.io/docs/tutorials/stateless-application/hello-minikube/
[homebrew]: https://brew.sh/
[kubernetes]: https://kubernetes.io/
[minikube]: https://kubernetes.io/docs/getting-started-guides/minikube/
[nova]: https://www.splunknova.com/
[ruby]: https://www.ruby-lang.org/en/downloads/
