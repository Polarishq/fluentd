### What it is

Splunk Nova provide cloud APIs for logging and analyzing your app. Fluentd is an open source data collector that decouples data sources from backend systems by providing a unified logging layer in between. This layer allows developers and data analysts to utilize many types of logs as they are generated and send them directly to Splunk Nova.

### What it does

Splunk Nova Cloud APIs with the fluentd plugin help you quickly collect your logs, events, and metrics to make sense of data points in your apps and infrastructure.

### Why use it?

**Use the Fluentd plugin with Splunk Nova**

Use the Splunk Nova Fluentd plugin to send events, logs, and metrics directly to Splunk Nova. Easily query these events using the Splunk [Nova-CLI].

**Use the Splunk Nova Fluentd plugin with Kubernetes (K8s) and Docker**

The Fluentd data pipeline runs a K8s daemonset that ingests system and application events, logs, and metrics across containers and send these data to Splunk Nova. The orchestrated daemonset runs as a a docker image container.

## Use the Fluentd plugin with Splunk Nova

Works best on macOS and Linux.

### Prerequisities

-   [Bundler]
-   [Fluentd]
-   [Homebrew]
-   [Ruby]
-   [Splunk Nova][nova] API Keys

## Install

### macOS

1. Clone or download the Splunk Nova Fluentd plugin.
    ```bash
    git@github.com:splunknova/fluentd.git
    ```
2. Use [homebrew] to install [ruby] and [bundler]. Once these dependencies are installed, from the command line run:

   ```bash
   brew install ruby
   ```
3. Fetch and update bundled gems by running the following [Bundler](http://bundler.io/) command:
   ```bash
   gem install bundler
   ```
4. Sign up or Log in to [Splunk Nova][nova] which generates your API credentials.

You're now ready to configure the Fluentd plugin with your Splunk Nova API credentials.

### Configure

1. Configure your  `out_splunknova.rb` file by navigating to the plugin directory: `lib` > `fluent` > `plugin `directory.
2. Login to Splunk Nova and grab your [API Keys][apikeys].
3. Open the `out_splunknova.rb` file.
4. Configure the fluentd plugin, by editing the following values using your Splunk Nova `api-username` and `Base-64 encoded token`. Save and close the file.

**Sample**
* **splunk_url:** The Splunk Nova url `https://api.splunknova.com`.
* **splunk_token:** The Splunk token is your Base-64 encoded Nova API Key
* **splunk_format:** Then Splunk format `nova` by default
* **splunk_url_path:** The Splunk entry point `/services/collector/event` by default (<--this OR `v1/events`?)


**Example**
```
config_param :splunk_url,       :string,   :default => 'api.splunknova.com'
config_param :splunk_token,     :string    :default => 'QmFzZS02NCBFbmNvZGVkIFNwbHVuayBOb3ZhIEFQSSBLZXk='
config_param :splunk_format,    :string,   :default => 'nova'
config_param :splunk_url_path,  :string,   :default => '/v1/events'
```

Verify that the splunknova/fluentd plugin is configured correctly to communicate with Splunk Nova:

```
Run verify command here
```

Expected output:

```
Huzzah,it's working!
```

Profit!

## Use the Splunk Nova Fluentd plugin with Kubernetes (K8s) and Docker

The [Docker platform][dockerkub] supports Kubernetes. This means that developers can build test and deploy containerized apps with Docker. Docker Swarm provides native clustering functionality for Docker containers, which turns a group of Docker engines into a single, virtual Docker engine.

[Kubernetes], is an open source framework that helps to orchestrate and automate container deployments, such as a Docker Swarm. The name Kubernetes originates from Greek, meaning helmsman or pilot. K8s is an abbreviation derived by replacing the 8 letters “ubernete” with “8”.

A [daemonset] is a K8s concept that is automatically deployed on each node of a K8s cluster.  A Fluentd data pipeline is running in the daemonset that ingests system and application logs and send these data to Splunk Nova.
The daemonset is running as a a docker image container.

**Fluentd K8s Input**: The K8s plugin is a Fluentd input component that gets logs or pulls system metrics.

**Splunk Nova Output**: The Splunk Nova plugin is a Fluentd output component that send ingested data to Splunk Nova.

**K8s Add-on** (optional): K8s add-on are responsible for managing/config the daemonset through K8s API knowledge objects such asfield extraction, monitor dash board, etc.

### Prerequisities

-   Access to the [docker hub][dhub] repo: https://hub.docker.com/r/polarishq/fluentd_splunknova.
-   [Splunk Nova][nova] API Keys
-   A Kubernetes server.

## Install

### macOS with Homebrew

1. Clone or download the Splunk Nova Fluentd plugin.
    ```bash
    git@github.com:splunknova/fluentd.git
    ```
2. Use [homebrew] to install [ruby] and [bundler]. Once these dependencies are installed, from the command line run:

   ```bash
   brew install ruby
   ```
3. Fetch and update bundled gems by running the following [Bundler](http://bundler.io/) command:
   ```bash
   gem install bundler
   ```
4. You're now ready to configure Splunk Nova with your API credentials.


### Configure

1.  To configure the Kubernetes fluentd Splunk Nova daemonset plugin, open the file: `fluentd-daemonset-splunknova.yaml`

2. Within the file, edit the `SPLUNK_URL` and `SPLUNK_TOKEN` values using your Splunk Nova API Keys. The `SPLUNK_URL` is your Splunk Nova `api-username`. The `SPLUNK_TOKEN` is your Base-64 encoded token.

  ```yaml
  - name:  SPLUNK_URL
  value: 'https://api.splunknova.com'
  - name:  SPLUNK_TOKEN
  value: "SlA0KjdYcTJFVURGTkJaVGNUbURNT0pOSWJ2MzU4R1A6aHptUWFLT0TreWVTVjZyV3ZkdXdzWlhkVzBEdzgycDMxLVZDOTNkZG5ncDN2T1ZNaTY2bmN3NXdzak1LcGpWSa=="
  ```

3. Save and close the file.

4. From the command line,change directories into the   `splunknova/fluentd` repo, and create a daemonset by running:

    ```
    kubectl create -f fluentd-daemonset-splunknova.yaml
    ```

### Create a docker image

To create a snapshot of your K8a fluentd container, you may choose to create a docker image. Docker images are created with the build command, and produce a container when started with the `run` command. Images are stored in a Docker registry: https://hub.docker.com/.

From within the terminal, change directories into the   `splunknova/fluentd` repo, and run:

    ```
    docker build -t splunknova/fluentd k8_image/docker_image
    ```

### Create a Kubernetes cluster

#### Local cluster

To create a local Kubernetes cluster., see [Hello Minikube][hello], a kubernetes tutorial with [Minikube].

#### Production cluster

To setup a production grade Kubernetes cluster, see [kops].

## Additional Resources

-   [K8s Logging architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)
-   [K8s Cluster debugging](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-cluster/)
-   [Fluentd K8s logging](https://docs.fluentd.org/v0.12/articles/kubernetes-fluentd)
-   [Fluentd K8s logging daemon code](https://github.com/fluent/fluentd-kubernetes-daemonset)

## Contribute

Having trouble working with the plugin? Found a typo in the documentation? Interested in adding a feature or [fixing a bug](https://github.com/splunknova/fluentd/issues)? Then [submit an issue](https://github.com/splunknova/fluentd/issues/new) or [pull request](https://help.github.com/articles/using-pull-requests/).

Contributing is a great way to learn more about new technologies and how to create helpful bug reports, feature requests and a good, clean pull request.

#### Test

To set up your environment to develop this plugin, you'll first need to run tests.

1. Install the related libraries:

   ```
   bundle install --path vendor/bundle
   ```
2. Run the tests:
   ```
   bundle exec rake test
   ```
This starts a server using the in the `test_out_splunknova.rb` directory.

3. Open your browser and verify `http://localhost:0000/test/`.

As modifications are made to the plugin and test site, it will regenerate and you should see the changes in the browser after a refresh.

#### Pull Requests

When submitting a pull request:

1. Clone the repo.
2. Create a branch off of `master` and give it a meaningful name (e.g. `my-new-feature`).
3. Open a pull request on GitHub and describe the feature or fix.

[apikeys]: https://www.splunknova.com/apikeys
[bundler]: http://bundler.io/
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
