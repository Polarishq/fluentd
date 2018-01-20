# Nova fluentd plugin

[![Travis Status for Nova fluentd plugin](https://travis-ci.org/splunknova/fluentd.svg?branch=master)](https://travis-ci.org/splunknova/fluentd)

## What it is

Splunk Nova provides cloud APIs for logging and analyzing your app. Fluentd is an open source data collector that decouples data sources from backend systems by providing a unified logging layer in between. This layer allows developers and data analysts to utilize many types of logs, as they are generated, and sends them directly to Splunk Nova.

## What it does

Splunk Nova Cloud APIs with the fluentd plugin help you quickly collect your logs and events to make sense of data points in your apps and infrastructure.

## Use cases

1. **Use the Fluentd plugin with Splunk Nova**

Use the Splunk Nova Fluentd plugin to send events and logs directly to Splunk Nova. In minutes, you can easily query these events using the Splunk [Nova-CLI].

2. **Use the Splunk Nova Fluentd plugin with Kubernetes (K8s) and Docker**

The Fluentd Nova plugin is containerized in a Docker image. This Docker image is used in a Kubernetes orchestrated cluster as a login system daemonset. The Fluentd Nova plugin gathers all logs from all running containers in a Kubernetes cluster. These logs are redirected to Splunk Nova and can be queried instantaneously.

## 1. Use the Fluentd plugin with Splunk Nova

Works best on macOS and Linux.

### Prerequisities

- [Bundler]
- [Fluentd]
- [Homebrew]
- [Ruby]
- [Splunk Nova API Keys][nova]

## Install

### macOS

1. Clone or download the Splunk Nova Fluentd plugin.

    ```bash
    git@github.com:splunknova/fluentd.git
    ```
1. Use [homebrew] to install [ruby] and [bundler]. Once these dependencies are installed, from the command line run:

   ```bash
   brew install ruby
   ```

1. Fetch and update bundled gems by running the following [Bundler](http://bundler.io/) command:
   ```bash
   gem install bundler
   ```

1. Sign up or Log in to [Splunk Nova][nova] which generates your API credentials.

You're now ready to configure the Fluentd plugin with your Splunk Nova API credentials.

### Configure

1. Configure your  `out_nova.rb` file by navigating to the plugin directory: `lib` > `fluent` > `plugin` directory.
1. Login to Splunk Nova and grab your [API Keys][apikeys].
1. Open the `out_nova.rb` file.
1. Configure the fluentd plugin, by editing the following values using your Splunk Nova `api-username` and `Base-64 encoded token`. Save and close the file.

**Sample**
* **splunk_url:** The Splunk Nova url `https://api.splunknova.com:443`.
* **splunk_token:** The Splunk token is your Base-64 encoded Nova API Key
* **splunk_format:** Then Splunk format `nova` by default
* **splunk_url_path:** The Splunk entry point `/services/collector/event` by default (<--this OR `v1/events`?)

**Example**

```ruby
config_param :splunk_url,       :string,   :default => 'api.splunknova.com:443'
config_param :splunk_token,     :string    :default => 'QmFzZS02NCBFbmNvZGVkIFNwbHVuayBOb3ZhIEFQSSBLZXk='
config_param :splunk_format,    :string,   :default => 'nova'
config_param :splunk_url_path,  :string,   :default => '/v1/events'
```

Verify that the splunknova/fluentd plugin is configured correctly to communicate with Splunk Nova:

```bash
Run verify command here
```

Expected output:

```bash
Huzzah,it's working!
```

Profit!

## 2. Use the Splunk Nova Fluentd plugin with Kubernetes (K8s) and Docker

[Kubernetes], is an open source framework that orchestrates and automate container deployments. The name Kubernetes originates from Greek, meaning helmsman or pilot. K8s is an abbreviation derived by replacing the 8 letters “ubernete” with “8”.

A [daemonset] is a K8s concept that is automatically deployed on each node of a K8s cluster. The Fluentd Nova plugin is used as a daemonset which runs a docker container. The daemonset ingests system and application logs and sends the data to Splunk Nova. One Docker container instance runs on each node of the cluster.

**Fluentd K8s Input**: The K8s plugin is a Fluentd input component that pulls logs.

**Splunk Nova Output**: The Splunk Nova plugin is a Fluentd output component that sends ingested data to Splunk Nova.

**K8s Add-on** (optional): K8s add-on are responsible for managing/config the daemonset through K8s API knowledge objects such asfield extraction, monitor dashboard, etc.

![Fluentd Nova K8s flow](/images/FluentdNovaflowK8s.png)

**Features:**

- Collect events and stats, allows you to correlate logs.
- Delivering host specific logs allows us to monitor components of a cluster.
- Log collection uses JSON logging driver.
- Enriches logs with kubernetes metadata (container, image, pod, daemon sets, jobs, cron jobs, etc).

### Prerequisities

- [Splunk Nova][nova] API Keys
- Access to the [docker hub][dhub] repo.
- `kubectl` is required, see [Install and Set Up kubectl](http://kubernetes.io/docs/user-guide/prereqs/).
- A running Kubernetes cluster. If new to Kubernetes, see [Hello Minikube][hello], a kubernetes tutorial with [Minikube].

### Install a Nova Fluentd plugin daemonset in your Kubernetes Cluster

1. To configure the Nova fluentd plugin Kubernetes daemonset, download and open the file: [`fluentd-daemonset-nova.yaml`]"https://raw.githubusercontent.com/splunknova/fluentd/master/docker_images/fluentd-daemonset-nova.yaml

1. Within the file, edit the `SPLUNK_URL` and `SPLUNK_TOKEN` values using your Splunk Nova API Keys. The `SPLUNK_URL` is your Splunk Nova `api-username`. The `SPLUNK_TOKEN` is your Base-64 encoded token. Save your edits, and close the file.

    ```yaml
    - name:  SPLUNK_URL
      value: 'https://api.splunknova.com:443'
    - name:  SPLUNK_TOKEN
      value: "<YOUR BASE64 ENCODED API KEY>=="
    ```

1. From the command line, create a daemonset by running:

     ```bash
    kubectl create -f fluentd-daemonset-nova.yaml
     ```

1. Start monitoring your Kubernetes cluster.


### Pull a docker image

<!-- TODO: docker run command-->

To pull a snapshot of your K8a fluentd container, you may choose to create a docker image. Docker images are created with the build command, and produce a container when started with the `run` command. Images are stored in a Docker registry: https://hub.docker.com/.

From within the terminal, change directories into the   `splunknova/fluentd` repo, and run:

    ```bash
      docker pull splunknova/fluentd
    ```

## Additional Resources

- [K8s Logging architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)
- [K8s Cluster debugging](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-cluster/)
- [Fluentd K8s logging](https://docs.fluentd.org/v0.12/articles/kubernetes-fluentd)
- [Fluentd K8s logging daemon code](https://github.com/fluent/fluentd-kubernetes-daemonset)

## Contribute

See review the guidelines for [contributing] to this repository.

[apikeys]: https://www.splunknova.com/apikeys
[bundler]: http://bundler.io/
[contributing]: https://github.com/splunknova/fluentd/blob/master/Contributing.md
[daemonset]: https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
[dhub]: https://hub.docker.com/
[dockerkub]: https://www.docker.com/kubernetes
[fluentd]: https://www.fluentd.org/
[hello]: https://kubernetes.io/docs/tutorials/stateless-application/hello-minikube/
[homebrew]: https://brew.sh/
[kops]: https://github.com/kubernetes/kops
[kubernetes]: https://kubernetes.io/
[minikube]: https://kubernetes.io/docs/getting-started-guides/minikube/
[nova]: https://www.splunknova.com/
[nova-cli]: https://github.com/splunknova/nova-cli
[ruby]: https://www.ruby-lang.org/en/downloads/
