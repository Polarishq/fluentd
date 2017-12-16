# splunknova fluentd plugin

A Splunk Nova [fluentd] plugin to send events to [Splunk HTTP Event Collector (HEC)][hec] or [Splunk Nova][nova].

## What it does

Fluentd is an open source data collector which lets you unify data collection and consumption. HEC enables you to send data over HTTP or HTTPS directly from your application to Splunk Enterprise or Splunk Cloud. Splunk Nova Cloud APIs help you quickly collect your logs and metrics to make sense of data points in your apps and infrastructure.

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

## Configure in Ruby

To configure the fluentd plugin, you'll need to modify the following values:

* **splunk_url:** The Splunk Nova url `https://api.splunknova.com` prefixed with your `api-username`
* **splunk_token:** The Splunk token is your Base-64 encoded Nova API Key
* **splunk_format:** Then Splunk format `nova` by default
* **splunk_url_path:** The Splunk entry point `/services/collector/event` by default

open the `out_splunknova.rb` file and modify the `splunk_url` and `splunk_token` values using your Splunk Nova api-username and Base-64 encoded token. Save and close the file.

```
config_param :splunk_url,       :string,   :default => 'https://api.splunknova.com'
config_param :splunk_token,     :string    :default => 'QmFzZS02NCBFbmNvZGVkIFNwbHVuayBOb3ZhIEFQSSBLZXk='
config_param :splunk_format,    :string,   :default => 'nova'
config_param :splunk_url_path,  :string,   :default => '/v1/events'
```

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

3. Within the file, edit the `SPLUNK_URL` and `SPLUNK_TOKEN` values using your Splunk Nova API Keys: Your Splunk api-username and Base-64 encoded token. Save and close the file.

  ```yaml
  - name:  SPLUNK_URL
  value: 'https://api-username.splunknovadev.com:443'
  - name:  SPLUNK_TOKEN
  value: "SlA0KjdYcTJFVURGTkJaVGNUbURNT0pOSWJ2MzU4R1A6aHptUWFLT0TreWVTVjZyV3ZkdXdzWlhkVzBEdzgycDMxLVZDOTNkZG5ncDN2T1ZNaTY2bmN3NXdzak1LcGpWSa=="
  ```

4. From the command line, create a daemonset by running:

  ```Bash
    kubectl create -f fluentd-daemonset-splunknova.yaml
```

### Create a docker image
To create a snapshot of your k8 fluentd container, you may choose to create a docker image. Images are created with the build command, and they'll produce a container when started with the `run` command. Images are stored in a Docker registry such as https://hub.docker.com/.

From within the terminal, change directories into the   `splunknova/fluentd` repo, and run:

```Bash
docker build -t splunknova/fluentd k8_image/docker_image
```

## Contributing

Check out [CONTRIBUTING.md](CONTRIBUTING.md) to submit pull requests via GitHub.

[bundler]: http://bundler.io/
[contributing]: https://github.com/splunknova/fluentd/Contributing.md
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
