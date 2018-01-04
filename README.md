### What it is

Splunk Nova provide cloud APIs for logging and analyzing your app. Fluentd is an open source data collector that decouples data sources from backend systems by providing a unified logging layer in between. This layer allows developers and data analysts to utilize many types of logs as they are generated and send them directly to Splunk Nova.

### What it does

Splunk Nova Cloud APIs with the fluentd plugin help you quickly collect your logs, events, and metrics to make sense of data points in your apps and infrastructure.

### Why use it?

There are a couple of different ways to use the Splunk Nova fluentd plugin. You can use it with Splunk Nova to do this thing, or you can add a Minikube and use it with Kubernetes to do this other thing.

## Fluentd plugin with Splunk Nova

Works best on macOS and Linux.

### Prerequisities

-   [bundler]
-   [fluentd]
-   [Homebrew]
-   [Ruby]
  - [Splunk Nova][nova]

## Install

Works best with macOS and Linux

#### macOS

1. Clone or download the Splunk Nova Fluentd plugin.
    ```bash
    git@github.com:Polarishq/nova_fluentd_plugin.git
    ```
2. Use [homebrew] to install [ruby] and [bundler]. Once these dependencies are installed, from the command line run:

   ```bash
   brew install ruby
   ```
3. Fetch and update bundled gems by running the following [Bundler](http://bundler.io/) command:
   ```bash
   gem install bundler
   ```
4.    You're now ready to configure Splunk Nova with your API credentials.

### Configure

1. Configure your  `out_splunknova.rb` file by navigating to`lib` > `fluent` > `plugin `directory.
2. Open the `out_splunknova.rb` file and To configure the fluentd plugin, edit the following values sing your Splunk Nova api-username and Base-64 encoded token. Save and close the file.

**Sample**
* **splunk_url:** The Splunk Nova url `https://api.splunknova.com` prefixed with your `api-username`
* **splunk_token:** The Splunk token is your Base-64 encoded Nova API Key
* **splunk_format:** Then Splunk format `nova` by default
* **splunk_url_path:** The Splunk entry point `/services/collector/event` by default

**Example**
```
config_param :splunk_url,       :string,   :default => 'https://api.splunknova.com'
config_param :splunk_token,     :string    :default => 'QmFzZS02NCBFbmNvZGVkIFNwbHVuayBOb3ZhIEFQSSBLZXk='
config_param :splunk_format,    :string,   :default => 'nova'
config_param :splunk_url_path,  :string,   :default => '/v1/events'
```


## Fluentd plugin with Splunk Nova and Kubernetes using Docker

1. Create/replace the contents of your `Gemfile` with the following:

   ```ruby
   source "https://rubygems.org"

   gem "github-pages", group: :jekyll_plugins
   ```

2. Fetch and update bundled gems by running the following [Bundler](http://bundler.io/) command:

   ```bash
   bundle
   ```

## Usage

For detailed instructions on how to configure, customize, and more read the [documentation]


## Setup K8 fluentd nova daemonset plugin

[Kubernetes], is an open source orchestration framework for containerized applications. The [Docker platform][dockerkub] supports Kubernetes. The name Kubernetes originates from Greek, meaning helmsman or pilot. K8s is an abbreviation derived by replacing the 8 letters “ubernete” with “8”.

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

## Contribute

Having trouble working with the plugin? Found a typo in the documentation? Interested in adding a feature or [fixing a bug](https://github.com/splunknova/fluentd/issues)? Then [submit an issue](https://github.com/https://github.com/splunknova/fluentd/issues/new) or [pull request](https://help.github.com/articles/using-pull-requests/).

Contributing is a great way to learn more about new technologies and how to create helpful bug reports, feature requests and a good, clean pull request.

### Test

To set up your environment to develop this plugin, you'll first need to run tests.

1. Install the related libraries:

```
$ bundle install --path vendor/bundle
$ bundle exec rake test
```

2. Test the plugin, run `bundle exec rake preview` and open your browser at `http://localhost:0000/test/`.

This starts a server using the in the `test_out_splunknova.rb` directory. As modifications are made to the plugin and test site, it will regenerate and you should see the changes in the browser after a refresh.

### Pull Requests

When submitting a pull request:

1. Clone the repo.
2. Create a branch off of `master` and give it a meaningful name (e.g. `my-new-feature`).
3. Open a pull request on GitHub and describe the feature or fix.

[bundler]: http://bundler.io/
[dhub]: https://hub.docker.com/
[dockerkub]: https://www.docker.com/kubernetes
[fluentd]: https://www.fluentd.org/
[hello]: https://kubernetes.io/docs/tutorials/stateless-application/hello-minikube/
[homebrew]: https://brew.sh/
[kubernetes]: https://kubernetes.io/
[minikube]: https://kubernetes.io/docs/getting-started-guides/minikube/
[nova]: https://www.splunknova.com/
[ruby]: https://www.ruby-lang.org/en/downloads/
